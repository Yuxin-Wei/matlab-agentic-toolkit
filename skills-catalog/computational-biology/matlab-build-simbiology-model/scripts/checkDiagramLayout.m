function results = checkDiagramLayout(model)
% Internal use only
% Used by the matlab-build-simbiology-model agent skill during diagram layout.
% NOT FOR EXTERNAL USE - Subject to change.
%
% CHECKDIAGRAMLAYOUT Run all diagram layout checks in one call.
%
%   results = checkDiagramLayout(model)
%
%   Runs containment check and connection-line-through-block check on the
%   model's diagram. Returns a struct with fields:
%     .containment  — struct array of containment violations
%     .lineThrough  — struct array of line-through-block violations
%     .nContainment — number of containment violations
%     .nLineThrough — number of line-through-block violations
%     .overlap      — struct array of block overlap/proximity violations
%     .nOverlap     — number of overlap violations
%     .nTotal       — total violations (containment + lineThrough + overlap)
%
%   Each containment violation has: .rxnIndex, .reaction, .compartment, .type
%   Each lineThrough violation has: .rxnIndex, .reaction, .species, .blockedBy, .blockedByType
%   Each overlap violation has: .block1, .block2, .block1Type, .block2Type, .distance
%
%   Example:
%     model = getModelByUUID('uuid-xxx');
%     r = checkDiagramLayout(model);
%     fprintf('Total violations: %d\n', r.nTotal);

    MAX_BLOCKS = 400;  % Safety limit — bail out for very large models
    allRxns  = model.Reactions;
    allSp    = model.Species;
    allComps = model.Compartments;
    nR = numel(allRxns);
    nS = numel(allSp);
    nC = numel(allComps);

    % Guard: bail out if model exceeds safe size for this algorithm
    if (nR + nS) > MAX_BLOCKS
        warning('checkDiagramLayout:modelTooLarge', ...
            'Model has %d blocks (limit: %d). Skipping layout check to avoid excessive compute time.', ...
            nR+nS, MAX_BLOCKS);
        results.containment  = struct('rxnIndex', {}, 'reaction', {}, 'compartment', {}, 'type', {});
        results.lineThrough  = struct('rxnIndex', {}, 'reaction', {}, 'species', {}, 'blockedBy', {}, 'blockedByType', {});
        results.overlap      = struct('block1', {}, 'block2', {}, 'block1Type', {}, 'block2Type', {}, 'distance', {});
        results.nContainment = -1;
        results.nLineThrough = -1;
        results.nOverlap     = -1;
        results.nTotal       = -1;
        return
    end

    %% === Containment Check ===
    compBounds = zeros(nC, 4);  % [x1 y1 x2 y2]
    compNames  = cell(nC, 1);
    for c = 1:nC
        p = simbio.diagram.getBlock(allComps(c), 'Position');
        compBounds(c,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)];
        compNames{c} = allComps(c).Name;
    end

    contViols = struct('rxnIndex', {}, 'reaction', {}, 'compartment', {}, 'type', {});
    for i = 1:nR
        rp = simbio.diagram.getBlock(allRxns(i), 'Position');
        rb = [rp(1), rp(2), rp(1)+rp(3), rp(2)+rp(4)];

        involvedComps = getInvolvedComps(allRxns(i));
        isInterComp = numel(involvedComps) > 1;

        for c = 1:nC
            cb = compBounds(c,:);
            if rb(1) < cb(3) && rb(3) > cb(1) && rb(2) < cb(4) && rb(4) > cb(2)
                isInvolved = any(strcmp(compNames{c}, involvedComps));
                if ~isInvolved
                    v.rxnIndex = i;
                    v.reaction = allRxns(i).Reaction;
                    v.compartment = compNames{c};
                    v.type = 'WRONG_COMP';
                    contViols(end+1) = v; %#ok<AGROW>
                elseif isInterComp
                    v.rxnIndex = i;
                    v.reaction = allRxns(i).Reaction;
                    v.compartment = compNames{c};
                    v.type = 'INTER_COMP_INSIDE_OWN';
                    contViols(end+1) = v; %#ok<AGROW>
                end
            end
        end
    end

    %% === Line-Through-Block Check ===
    % Collect all block bounding rects
    blkRect = zeros(nR+nS, 4);
    blkName = cell(nR+nS, 1);
    blkType = cell(nR+nS, 1);
    blkIdx  = zeros(nR+nS, 1);

    for i = 1:nR
        p = simbio.diagram.getBlock(allRxns(i), 'Position');
        blkRect(i,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)];
        blkName{i} = allRxns(i).Reaction;
        blkType{i} = 'rxn';
        blkIdx(i)  = i;
    end
    for i = 1:nS
        p = simbio.diagram.getBlock(allSp(i), 'Position');
        k = nR + i;
        blkRect(k,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)];
        blkName{k} = [allSp(i).Parent.Name '.' allSp(i).Name];
        blkType{k} = 'sp';
        blkIdx(k)  = i;
    end

    lineViols = struct('rxnIndex', {}, 'reaction', {}, 'species', {}, ...
                       'blockedBy', {}, 'blockedByType', {});
    for i = 1:nR
        rp = simbio.diagram.getBlock(allRxns(i), 'Position');
        rcx = rp(1) + rp(3)/2;
        rcy = rp(2) + rp(4)/2;
        connSp = [allRxns(i).Reactants; allRxns(i).Products];

        for s = 1:numel(connSp)
            if isempty(connSp(s)) || isempty(connSp(s).Name)
                continue
            end
            sp = connSp(s);
            spp = simbio.diagram.getBlock(sp, 'Position');
            scx = spp(1) + spp(3)/2;
            scy = spp(2) + spp(4)/2;
            spName = [sp.Parent.Name '.' sp.Name];

            for b = 1:size(blkRect, 1)
                % Skip self
                if strcmp(blkType{b}, 'rxn') && blkIdx(b) == i, continue; end
                if strcmp(blkType{b}, 'sp')  && strcmp(blkName{b}, spName), continue; end

                if lineIntersectsRect(rcx, rcy, scx, scy, blkRect(b,:))
                    lv.rxnIndex     = i;
                    lv.reaction     = allRxns(i).Reaction;
                    lv.species      = spName;
                    lv.blockedBy    = blkName{b};
                    lv.blockedByType = blkType{b};
                    lineViols(end+1) = lv; %#ok<AGROW>
                end
            end
        end
    end

    %% === Overlap / Proximity Check ===
    % Flag any two non-compartment blocks whose centers are within 10px
    MIN_DIST = 10;
    nBlk = nR + nS;
    blkCenter = zeros(nBlk, 2);
    for b = 1:nBlk
        blkCenter(b,:) = [(blkRect(b,1)+blkRect(b,3))/2, (blkRect(b,2)+blkRect(b,4))/2];
    end

    overlapViols = struct('block1', {}, 'block2', {}, ...
                          'block1Type', {}, 'block2Type', {}, 'distance', {});
    for a = 1:nBlk
        for b = a+1:nBlk
            d = sqrt((blkCenter(a,1)-blkCenter(b,1))^2 + ...
                     (blkCenter(a,2)-blkCenter(b,2))^2);
            if d < MIN_DIST
                ov.block1 = blkName{a};
                ov.block2 = blkName{b};
                ov.block1Type = blkType{a};
                ov.block2Type = blkType{b};
                ov.distance = round(d, 1);
                overlapViols(end+1) = ov; %#ok<AGROW>
            end
        end
    end

    %% === Build results ===
    results.containment  = contViols;
    results.lineThrough  = lineViols;
    results.nContainment = numel(contViols);
    results.nLineThrough = numel(lineViols);
    results.overlap      = overlapViols;
    results.nOverlap     = numel(overlapViols);
    results.nTotal       = numel(contViols) + numel(lineViols) + numel(overlapViols);

end

%% === Helper: get compartment names involved in a reaction ===
function comps = getInvolvedComps(rxn)
    connSp = [rxn.Reactants; rxn.Products];
    comps = {};
    for s = 1:numel(connSp)
        if ~isempty(connSp(s)) && ~isempty(connSp(s).Name)
            comps{end+1} = connSp(s).Parent.Name; %#ok<AGROW>
        end
    end
    comps = unique(comps);
end

%% === Helper: parametric line-rect intersection (Liang-Barsky) ===
% Copyright 2026 The MathWorks, Inc.

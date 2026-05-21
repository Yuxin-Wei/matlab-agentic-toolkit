function nFixed = repositionAllReactions(model)
% Internal use only
% Used by the matlab-build-simbiology-model agent skill during diagram layout.
% NOT FOR EXTERNAL USE - Subject to change.
%
% REPOSITIONALLREACTIONS Batch-reposition reaction nodes to crossing-free positions.
%
%   nFixed = repositionAllReactions(model)
%
%   Repositions reactions using cooperative logic:
%     1. For each reaction with violations, identify blocking reactions.
%     2. If a blocker is an intra-compartment reaction blocking an
%        inter-compartment reaction, reposition the blocker first (it has
%        more positional freedom inside its parent compartment).
%     3. Re-check the original reaction — if violation resolved, skip it.
%     4. After targeted passes, a settle pass re-evaluates all moved
%        reactions against the stable final layout.
%
%   Only moves reactions that have violations or that block other reactions.
%   Returns the total number of reactions repositioned.
%
%   Example:
%     model = getModelByUUID('uuid-xxx');
%     nFixed = repositionAllReactions(model);
%     fprintf('Repositioned %d reactions\n', nFixed);
%     results = checkDiagramLayout(model);
%     fprintf('Remaining violations: %d\n', results.nTotal);
%
%   See also: computeSafeReactionPosition, checkDiagramLayout

    MAX_BLOCKS = 400;  % Safety limit — bail out for very large models
    allRxns = model.Reactions;
    allSp   = model.Species;
    nR = numel(allRxns);
    nS = numel(allSp);
    nFixed = 0;

    % Guard: bail out if model exceeds safe size for this algorithm
    if (nR + nS) > MAX_BLOCKS
        warning('repositionAllReactions:modelTooLarge', ...
            'Model has %d blocks (limit: %d). Skipping repositioning to avoid excessive compute time.', ...
            nR+nS, MAX_BLOCKS);
        return
    end

    MAX_PASSES = 3;
    movedIndices = false(nR, 1);

    %% Classify reactions
    isInterComp = false(nR, 1);
    for i = 1:nR
        comps = getInvolvedCompartments(allRxns(i));
        isInterComp(i) = numel(comps) > 1;
    end

    %% Targeted passes with cooperative repositioning
    for pass = 1:MAX_PASSES
        movedThisPass = 0;
        for i = 1:nR
            if ~reactionHasViolation(model, allRxns(i))
                continue
            end

            % If this is an inter-compartment reaction, try cooperative fix:
            % find intra-compartment blockers and move them first
            if isInterComp(i)
                blockers = findBlockingReactions(model, allRxns(i));
                for bi = 1:numel(blockers)
                    bIdx = blockers(bi);
                    % Only cooperatively move intra-compartment blockers
                    if ~isInterComp(bIdx)
                        oldBPos = simbio.diagram.getBlock(allRxns(bIdx), 'Position');
                        newBPos = computeSafeReactionPosition(model, allRxns(bIdx));
                        if ~isequal(oldBPos, newBPos)
                            simbio.diagram.setBlock(allRxns(bIdx), 'Position', newBPos);
                            movedThisPass = movedThisPass + 1;
                            movedIndices(bIdx) = true;
                        end
                    end
                end

                % Re-check after moving blockers
                if ~reactionHasViolation(model, allRxns(i))
                    continue
                end
            end

            % Standard repositioning for this reaction
            oldPos = simbio.diagram.getBlock(allRxns(i), 'Position');
            newPos = computeSafeReactionPosition(model, allRxns(i));

            if ~isequal(oldPos, newPos)
                simbio.diagram.setBlock(allRxns(i), 'Position', newPos);
                movedThisPass = movedThisPass + 1;
                movedIndices(i) = true;
            end
        end
        nFixed = nFixed + movedThisPass;

        if movedThisPass == 0
            break
        end

        results = checkDiagramLayout(model);
        if results.nTotal == 0
            break
        end
    end

    %% Settle pass: re-evaluate moved reactions against stable layout
    if any(movedIndices)
        settleCount = 0;
        for i = 1:nR
            if ~movedIndices(i)
                continue
            end

            oldPos = simbio.diagram.getBlock(allRxns(i), 'Position');
            newPos = computeSafeReactionPosition(model, allRxns(i));

            if ~isequal(oldPos, newPos)
                simbio.diagram.setBlock(allRxns(i), 'Position', newPos);
                settleCount = settleCount + 1;
            end
        end
        nFixed = nFixed + settleCount;
    end

    % Final summary
    results = checkDiagramLayout(model);
    fprintf('repositionAllReactions: %d reactions moved across %d pass(es). ', nFixed, pass);
    fprintf('Remaining violations: %d\n', results.nTotal);
end

%% === Helper: find reactions blocking a given reaction's connection lines ===
function blockerIndices = findBlockingReactions(model, rxn)
% Returns indices (into model.Reactions) of other reaction nodes whose
% blocks intersect the connection lines of the given reaction.

    allRxns = model.Reactions;
    nR = numel(allRxns);
    blockerIndices = [];

    rxnPos = simbio.diagram.getBlock(rxn, 'Position');
    rxnCx = rxnPos(1) + rxnPos(3)/2;
    rxnCy = rxnPos(2) + rxnPos(4)/2;

    % Connected species centers
    connSp = [rxn.Reactants; rxn.Products];
    connCenters = [];
    for s = 1:numel(connSp)
        if isempty(connSp(s)) || isempty(connSp(s).Name)
            continue
        end
        spp = simbio.diagram.getBlock(connSp(s), 'Position');
        connCenters(end+1, :) = [spp(1)+spp(3)/2, spp(2)+spp(4)/2]; %#ok<AGROW>
    end
    nConn = size(connCenters, 1);

    % Check each other reaction
    for i = 1:nR
        if allRxns(i) == rxn, continue; end
        p = simbio.diagram.getBlock(allRxns(i), 'Position');
        blockRect = [p(1), p(2), p(1)+p(3), p(2)+p(4)];
        for s = 1:nConn
            if lineIntersectsRect(rxnCx, rxnCy, connCenters(s,1), connCenters(s,2), blockRect)
                blockerIndices(end+1) = i; %#ok<AGROW>
                break  % only count each blocker once
            end
        end
    end
end

%% === Helper: get unique compartment names involved in a reaction ===
function comps = getInvolvedCompartments(rxn)
    connSp = [rxn.Reactants; rxn.Products];
    comps = {};
    for s = 1:numel(connSp)
        if ~isempty(connSp(s)) && ~isempty(connSp(s).Name)
            comps{end+1} = connSp(s).Parent.Name; %#ok<AGROW>
        end
    end
    comps = unique(comps);
end

%% === Helper: check if a single reaction has a layout violation ===
function hasViol = reactionHasViolation(model, rxn)
% Tests whether the given reaction node has any line-through-block,
% containment, or proximity violation in its current position.

    RXN_W = 15; RXN_H = 15;
    MIN_PROXIMITY = 20;
    hasViol = false;

    rxnPos = simbio.diagram.getBlock(rxn, 'Position');
    rxnCx = rxnPos(1) + RXN_W/2;
    rxnCy = rxnPos(2) + RXN_H/2;

    % Connected species
    connSp = [rxn.Reactants; rxn.Products];
    connNames = {};
    connCenters = [];
    for s = 1:numel(connSp)
        if isempty(connSp(s)) || isempty(connSp(s).Name)
            continue
        end
        sp = connSp(s);
        spp = simbio.diagram.getBlock(sp, 'Position');
        connNames{end+1} = [sp.Parent.Name '.' sp.Name]; %#ok<AGROW>
        connCenters(end+1, :) = [spp(1)+spp(3)/2, spp(2)+spp(4)/2]; %#ok<AGROW>
    end
    nConn = size(connCenters, 1);
    if nConn == 0
        return
    end

    % Identify involved compartments
    involvedComps = {};
    for s = 1:numel(connSp)
        if ~isempty(connSp(s)) && ~isempty(connSp(s).Name)
            involvedComps{end+1} = connSp(s).Parent.Name; %#ok<AGROW>
        end
    end
    involvedComps = unique(involvedComps);
    isInterComp = numel(involvedComps) > 1;

    % Check containment: inter-compartment reactions should not be inside
    % any compartment
    allComps = model.Compartments;
    rxnRect = [rxnPos(1), rxnPos(2), rxnPos(1)+RXN_W, rxnPos(2)+RXN_H];
    if isInterComp
        for c = 1:numel(allComps)
            cp = simbio.diagram.getBlock(allComps(c), 'Position');
            compRect = [cp(1), cp(2), cp(1)+cp(3), cp(2)+cp(4)];
            if rxnRect(1) >= compRect(1) && rxnRect(3) <= compRect(3) && ...
               rxnRect(2) >= compRect(2) && rxnRect(4) <= compRect(4)
                hasViol = true;
                return
            end
        end
    end

    % Build block list (excluding this reaction and connected species)
    allRxns = model.Reactions;
    allSp = model.Species;
    blocks = zeros(0, 4);

    for i = 1:numel(allRxns)
        if allRxns(i) == rxn, continue; end
        p = simbio.diagram.getBlock(allRxns(i), 'Position');
        blocks(end+1,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)]; %#ok<AGROW>
    end
    for i = 1:numel(allSp)
        spName = [allSp(i).Parent.Name '.' allSp(i).Name];
        if any(strcmp(spName, connNames)), continue; end
        p = simbio.diagram.getBlock(allSp(i), 'Position');
        blocks(end+1,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)]; %#ok<AGROW>
    end

    % Check line-through-block
    for s = 1:nConn
        for b = 1:size(blocks, 1)
            if lineIntersectsRect(rxnCx, rxnCy, connCenters(s,1), connCenters(s,2), blocks(b,:))
                hasViol = true;
                return
            end
        end
    end

    % Check proximity to other reaction/species blocks
    for b = 1:size(blocks, 1)
        blkCx = (blocks(b,1) + blocks(b,3)) / 2;
        blkCy = (blocks(b,2) + blocks(b,4)) / 2;
        d = sqrt((rxnCx - blkCx)^2 + (rxnCy - blkCy)^2);
        if d < MIN_PROXIMITY
            hasViol = true;
            return
        end
    end
end

%% === Helper: parametric line-rect intersection (Liang-Barsky) ===
% Copyright 2026 The MathWorks, Inc.

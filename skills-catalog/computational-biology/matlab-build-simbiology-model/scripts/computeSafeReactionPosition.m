function pos = computeSafeReactionPosition(model, rxn)
% Internal use only
% Used by the matlab-build-simbiology-model agent skill during diagram layout.
% NOT FOR EXTERNAL USE - Subject to change.
%
% COMPUTESAFEREACTIONPOSITION Find a crossing-free position for a reaction node.
%
%   pos = computeSafeReactionPosition(model, rxn)
%
%   Computes a position [x y 15 15] for the reaction node such that the
%   connection lines to all its reactants and products do not pass through
%   any other block (species or reaction) in the diagram.
%
%   Strategy:
%     1. Compute the ideal midpoint between connected species.
%     2. Sample candidate positions along the midpoint line and in a grid
%        around it.
%     3. For each candidate, test all connection lines against all blocks.
%     4. Return the candidate closest to the ideal midpoint that has zero
%        line-through-block violations.
%     5. If no perfect position exists, return the candidate with the
%        fewest violations.
%
%   Example:
%     model = getModelByUUID('uuid-xxx');
%     rxn = model.Reactions(25);
%     pos = computeSafeReactionPosition(model, rxn);
%     simbio.diagram.setBlock(rxn, 'Position', pos);

    RXN_W = 15; RXN_H = 15;
    MAX_BLOCKS = 400;  % Safety limit — bail out for very large models

    %% Collect all block bounding rects (excluding this reaction)
    allRxns = model.Reactions;
    allSp   = model.Species;
    nR = numel(allRxns);
    nS = numel(allSp);

    % Guard: bail out if model exceeds safe size for this algorithm
    if (nR + nS) > MAX_BLOCKS
        % Fall back to simple midpoint placement — full search is too expensive
        connSp = [rxn.Reactants; rxn.Products];
        cx = 50; cy = 50;
        nConn = 0;
        for s = 1:numel(connSp)
            if ~isempty(connSp(s)) && ~isempty(connSp(s).Name)
                spp = simbio.diagram.getBlock(connSp(s), 'Position');
                cx = cx + spp(1) + spp(3)/2;
                cy = cy + spp(2) + spp(4)/2;
                nConn = nConn + 1;
            end
        end
        if nConn > 0
            cx = cx / nConn; cy = cy / nConn;
        end
        pos = [round(cx - RXN_W/2), round(cy - RXN_H/2), RXN_W, RXN_H];
        warning('computeSafeReactionPosition:modelTooLarge', ...
            'Model has %d blocks (limit: %d). Using simple midpoint placement.', nR+nS, MAX_BLOCKS);
        return
    end

    % Find this reaction's index
    rxnIdx = 0;
    for i = 1:nR
        if allRxns(i) == rxn
            rxnIdx = i;
            break
        end
    end

    % Connected species info
    connSp = [rxn.Reactants; rxn.Products];
    connNames = {};
    connCenters = [];
    for s = 1:numel(connSp)
        if isempty(connSp(s)) || isempty(connSp(s).Name)
            continue
        end
        sp = connSp(s);
        spp = simbio.diagram.getBlock(sp, 'Position');
        scx = spp(1) + spp(3)/2;
        scy = spp(2) + spp(4)/2;
        connNames{end+1} = [sp.Parent.Name '.' sp.Name]; %#ok<AGROW>
        connCenters(end+1, :) = [scx, scy]; %#ok<AGROW>
    end
    nConn = size(connCenters, 1);

    if nConn == 0
        % No connected species — place at origin
        pos = [50, 50, RXN_W, RXN_H];
        return
    end

    % Build block list (excluding this reaction and its connected species)
    blocks = zeros(0, 4);
    blockNames = {};
    for i = 1:nR
        if i == rxnIdx, continue; end
        p = simbio.diagram.getBlock(allRxns(i), 'Position');
        blocks(end+1,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)]; %#ok<AGROW>
        blockNames{end+1} = allRxns(i).Reaction; %#ok<AGROW>
    end
    for i = 1:nS
        spName = [allSp(i).Parent.Name '.' allSp(i).Name];
        if any(strcmp(spName, connNames)), continue; end
        p = simbio.diagram.getBlock(allSp(i), 'Position');
        blocks(end+1,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)]; %#ok<AGROW>
        blockNames{end+1} = spName; %#ok<AGROW>
    end

    % Also collect compartment bounds for containment avoidance
    allComps = model.Compartments;
    involvedComps = {};
    for s = 1:numel(connSp)
        if ~isempty(connSp(s)) && ~isempty(connSp(s).Name)
            involvedComps{end+1} = connSp(s).Parent.Name; %#ok<AGROW>
        end
    end
    involvedComps = unique(involvedComps);
    isInterComp = numel(involvedComps) > 1;

    compBounds = zeros(0, 4);
    for c = 1:numel(allComps)
        if isInterComp || ~any(strcmp(allComps(c).Name, involvedComps))
            p = simbio.diagram.getBlock(allComps(c), 'Position');
            compBounds(end+1,:) = [p(1), p(2), p(1)+p(3), p(2)+p(4)]; %#ok<AGROW>
        end
    end

    %% Compute ideal midpoint
    idealCx = mean(connCenters(:,1));
    idealCy = mean(connCenters(:,2));

    %% Collect all compartment positions for gap-based candidate generation
    allCompPos = zeros(numel(allComps), 4);  % [x y w h] for each compartment
    allCompNames = cell(1, numel(allComps));
    for c = 1:numel(allComps)
        allCompPos(c,:) = simbio.diagram.getBlock(allComps(c), 'Position');
        allCompNames{c} = allComps(c).Name;
    end

    % Identify involved compartment positions
    involvedCompPos = zeros(numel(involvedComps), 4);
    for ic = 1:numel(involvedComps)
        for c = 1:numel(allComps)
            if strcmp(allCompNames{c}, involvedComps{ic})
                involvedCompPos(ic,:) = allCompPos(c,:);
                break
            end
        end
    end

    %% Determine if this is an elimination reaction (null product or null reactant)
    isElimination = false;
    elimCompIdx = 0;  % index into involvedComps for the single involved compartment
    if isscalar(involvedComps)
        nReactants = numel(rxn.Reactants);
        nProducts  = numel(rxn.Products);
        hasNullReactant = (nReactants == 0);
        hasNullProduct  = (nProducts == 0);
        if hasNullReactant || hasNullProduct
            isElimination = true;
            elimCompIdx = 1;
        end
    end

    %% For elimination reactions, shift ideal midpoint to the quiet side
    %  of the compartment. Otherwise the ideal point lands on the species
    %  center and wins with score 0, blocking inter-compartment lines.
    if isElimination && elimCompIdx > 0
        cp = involvedCompPos(elimCompIdx,:);
        cpCx = cp(1) + cp(3)/2;
        cpCy = cp(2) + cp(4)/2;

        otherCenters = zeros(0, 2);
        for c = 1:numel(allComps)
            if ~any(strcmp(allCompNames{c}, involvedComps))
                ocp = allCompPos(c,:);
                otherCenters(end+1,:) = [ocp(1)+ocp(3)/2, ocp(2)+ocp(4)/2]; %#ok<AGROW>
            end
        end
        if ~isempty(otherCenters)
            sidePoints = [cp(1) - 30, cpCy;          % left
                          cp(1)+cp(3) + 30, cpCy;    % right
                          cpCx, cp(2) - 30;           % top
                          cpCx, cp(2)+cp(4) + 30];    % bottom
            bestDist = -1;
            bestSide = 4;  % default to bottom
            for si = 1:4
                minD = inf;
                for oc = 1:size(otherCenters, 1)
                    d = sqrt((sidePoints(si,1)-otherCenters(oc,1))^2 + ...
                             (sidePoints(si,2)-otherCenters(oc,2))^2);
                    if d < minD, minD = d; end
                end
                if minD > bestDist
                    bestDist = minD;
                    bestSide = si;
                end
            end
            idealCx = sidePoints(bestSide, 1);
            idealCy = sidePoints(bestSide, 2);
        end
    end

    %% Generate candidate positions
    % Sample along the line between connected species at different t values
    candidates = [];

    if nConn == 2
        % Two-species: sample along the connecting line
        p1 = connCenters(1,:);
        p2 = connCenters(2,:);
        tValues = [0.5, 0.45, 0.55, 0.4, 0.6, 0.35, 0.65, 0.3, 0.7, ...
                   0.25, 0.75, 0.2, 0.8, 0.15, 0.85, 0.1, 0.9, 0.05, 0.95];
        for t = tValues
            cx = p1(1) + t*(p2(1)-p1(1));
            cy = p1(2) + t*(p2(2)-p1(2));
            candidates(end+1,:) = [cx, cy]; %#ok<AGROW>
        end

        % Perpendicular offset candidates along the connecting line
        lineDir = p2 - p1;
        lineLen = sqrt(lineDir(1)^2 + lineDir(2)^2);
        if lineLen > 0
            perpDir = [-lineDir(2), lineDir(1)] / lineLen;  % unit perpendicular
            perpOffsets = [-100 -80 -60 -40 -20 20 40 60 80 100];
            perpTValues = [0.3 0.4 0.5 0.6 0.7];
            for t = perpTValues
                basePt = p1 + t * (p2 - p1);
                for po = perpOffsets
                    candidates(end+1,:) = basePt + po * perpDir; %#ok<AGROW>
                end
            end
        end
    end

    % Grid search around ideal midpoint (covers off-line positions)
    offsets = [-120 -80 -60 -40 -20 0 20 40 60 80 120];
    for dx = offsets
        for dy = offsets
            candidates(end+1,:) = [idealCx + dx, idealCy + dy]; %#ok<AGROW>
        end
    end

    %% Gap-based candidates for inter-compartment reactions
    if isInterComp && numel(involvedComps) >= 2
        % Get bounding boxes of the two primary involved compartments
        cp1 = involvedCompPos(1,:);  % [x y w h]
        cp2 = involvedCompPos(2,:);  % [x y w h]
        % Convert to edges: [left top right bottom]
        c1L = cp1(1); c1T = cp1(2); c1R = cp1(1)+cp1(3); c1B = cp1(2)+cp1(4);
        c2L = cp2(1); c2T = cp2(2); c2R = cp2(1)+cp2(3); c2B = cp2(2)+cp2(4);

        % Midpoint of the gap between compartment centers
        gapMidX = (c1L + c1R + c2L + c2R) / 4;
        gapMidY = (c1T + c1B + c2T + c2B) / 4;

        % Horizontal gap midpoints (between right edge of left comp and left edge of right comp)
        if c1R < c2L
            hGapX = (c1R + c2L) / 2;
            hGapYs = linspace(min(c1T, c2T) - 20, max(c1B, c2B) + 20, 9);
            for gy = hGapYs
                candidates(end+1,:) = [hGapX, gy]; %#ok<AGROW>
            end
        elseif c2R < c1L
            hGapX = (c2R + c1L) / 2;
            hGapYs = linspace(min(c1T, c2T) - 20, max(c1B, c2B) + 20, 9);
            for gy = hGapYs
                candidates(end+1,:) = [hGapX, gy]; %#ok<AGROW>
            end
        end

        % Vertical gap midpoints (between bottom of top comp and top of bottom comp)
        if c1B < c2T
            vGapY = (c1B + c2T) / 2;
            vGapXs = linspace(min(c1L, c2L) - 20, max(c1R, c2R) + 20, 9);
            for gx = vGapXs
                candidates(end+1,:) = [gx, vGapY]; %#ok<AGROW>
            end
        elseif c2B < c1T
            vGapY = (c2B + c1T) / 2;
            vGapXs = linspace(min(c1L, c2L) - 20, max(c1R, c2R) + 20, 9);
            for gx = vGapXs
                candidates(end+1,:) = [gx, vGapY]; %#ok<AGROW>
            end
        end

        % Points just outside each edge of each involved compartment
        edgeMargins = [20 40 60];
        for ic = 1:numel(involvedComps)
            cp = involvedCompPos(ic,:);
            cpL = cp(1); cpT = cp(2); cpR = cp(1)+cp(3); cpB = cp(2)+cp(4);
            cpCx = cp(1) + cp(3)/2;
            cpCy = cp(2) + cp(4)/2;
            for em = edgeMargins
                % Left of compartment
                candidates(end+1,:) = [cpL - em, cpCy]; %#ok<AGROW>
                % Right of compartment
                candidates(end+1,:) = [cpR + em, cpCy]; %#ok<AGROW>
                % Above compartment
                candidates(end+1,:) = [cpCx, cpT - em]; %#ok<AGROW>
                % Below compartment
                candidates(end+1,:) = [cpCx, cpB + em]; %#ok<AGROW>
            end
        end

        % Fine grid around the gap midpoint
        fineOffsets = [-40 -30 -20 -10 0 10 20 30 40];
        for dx = fineOffsets
            for dy = fineOffsets
                candidates(end+1,:) = [gapMidX + dx, gapMidY + dy]; %#ok<AGROW>
            end
        end
    end

    %% Elimination reaction: candidates on the quiet side of the compartment
    if isElimination && elimCompIdx > 0
        cp = involvedCompPos(elimCompIdx,:);
        cpL = cp(1); cpT = cp(2); cpR = cp(1)+cp(3); cpB = cp(2)+cp(4);
        cpCx = cp(1) + cp(3)/2;
        cpCy = cp(2) + cp(4)/2;

        % Find the "quiet" side — side farthest from other compartments' centers
        otherCompCenters = zeros(0, 2);
        for c = 1:numel(allComps)
            if ~any(strcmp(allCompNames{c}, involvedComps))
                ocp = allCompPos(c,:);
                otherCompCenters(end+1,:) = [ocp(1)+ocp(3)/2, ocp(2)+ocp(4)/2]; %#ok<AGROW>
            end
        end

        % Score each side by distance from other compartments (higher = quieter)
        sideCenters = [cpL - 30, cpCy;   % left
                       cpR + 30, cpCy;   % right
                       cpCx, cpT - 30;   % top
                       cpCx, cpB + 30];  % bottom

        if ~isempty(otherCompCenters)
            sideScores = zeros(4, 1);
            for si = 1:4
                minDist = inf;
                for oc = 1:size(otherCompCenters, 1)
                    d = sqrt((sideCenters(si,1) - otherCompCenters(oc,1))^2 + ...
                             (sideCenters(si,2) - otherCompCenters(oc,2))^2);
                    if d < minDist
                        minDist = d;
                    end
                end
                sideScores(si) = minDist;
            end
            [~, sortedSides] = sort(sideScores, 'descend');
        else
            sortedSides = [1 2 3 4];
        end

        % Generate candidates on the two quietest sides
        elimMargins = [20 30 40 60 80];
        for si = 1:min(2, numel(sortedSides))
            sideIdx = sortedSides(si);
            for em = elimMargins
                if sideIdx == 1      % left
                    candidates(end+1,:) = [cpL - em, cpCy]; %#ok<AGROW>
                    candidates(end+1,:) = [cpL - em, cpCy - 20]; %#ok<AGROW>
                    candidates(end+1,:) = [cpL - em, cpCy + 20]; %#ok<AGROW>
                elseif sideIdx == 2  % right
                    candidates(end+1,:) = [cpR + em, cpCy]; %#ok<AGROW>
                    candidates(end+1,:) = [cpR + em, cpCy - 20]; %#ok<AGROW>
                    candidates(end+1,:) = [cpR + em, cpCy + 20]; %#ok<AGROW>
                elseif sideIdx == 3  % top
                    candidates(end+1,:) = [cpCx, cpT - em]; %#ok<AGROW>
                    candidates(end+1,:) = [cpCx - 20, cpT - em]; %#ok<AGROW>
                    candidates(end+1,:) = [cpCx + 20, cpT - em]; %#ok<AGROW>
                elseif sideIdx == 4  % bottom
                    candidates(end+1,:) = [cpCx, cpB + em]; %#ok<AGROW>
                    candidates(end+1,:) = [cpCx - 20, cpB + em]; %#ok<AGROW>
                    candidates(end+1,:) = [cpCx + 20, cpB + em]; %#ok<AGROW>
                end
            end
        end
    end

    %% Evaluate each candidate
    MIN_PROXIMITY = 20;  % minimum center-to-center distance from other blocks
    nCand = size(candidates, 1);
    violations = zeros(nCand, 1);
    proximityViols = zeros(nCand, 1);  % count of blocks too close
    inComp     = false(nCand, 1);  % true if inside a non-involved compartment
    distToIdeal = zeros(nCand, 1);

    % Precompute block centers for proximity check
    nBlk = size(blocks, 1);
    blkCenters = zeros(nBlk, 2);
    for b = 1:nBlk
        blkCenters(b,:) = [(blocks(b,1)+blocks(b,3))/2, ...
                           (blocks(b,2)+blocks(b,4))/2];
    end

    for ci = 1:nCand
        cx = candidates(ci, 1);
        cy = candidates(ci, 2);
        rxnRect = [cx - RXN_W/2, cy - RXN_H/2, cx + RXN_W/2, cy + RXN_H/2];

        % Check containment violation
        for cc = 1:size(compBounds, 1)
            cb = compBounds(cc,:);
            if rxnRect(1) < cb(3) && rxnRect(3) > cb(1) && ...
               rxnRect(2) < cb(4) && rxnRect(4) > cb(2)
                inComp(ci) = true;
                break
            end
        end

        % Check line-through-block for each connection
        for s = 1:nConn
            scx = connCenters(s, 1);
            scy = connCenters(s, 2);
            for b = 1:nBlk
                if lineIntersectsRect(cx, cy, scx, scy, blocks(b,:))
                    violations(ci) = violations(ci) + 1;
                end
            end
        end

        % Check proximity to other blocks (avoid overlapping/stacking)
        for b = 1:nBlk
            d = sqrt((cx - blkCenters(b,1))^2 + (cy - blkCenters(b,2))^2);
            if d < MIN_PROXIMITY
                proximityViols(ci) = proximityViols(ci) + 1;
            end
        end

        distToIdeal(ci) = sqrt((cx - idealCx)^2 + (cy - idealCy)^2);
    end

    %% Second pass: wider search if no zero-violation candidate found
    score = violations * 10000 + inComp * 50000 + proximityViols * 5000 + distToIdeal;
    [bestScore, ~] = min(score);
    if bestScore >= 10000
        % No clean candidate found — expand search
        candidates2 = [];

        % Wider grid around ideal midpoint
        wideOffsets = [-200 -160 -120 -80 -40 0 40 80 120 160 200];
        for dx = wideOffsets
            for dy = wideOffsets
                candidates2(end+1,:) = [idealCx + dx, idealCy + dy]; %#ok<AGROW>
            end
        end

        % Finer grid in ±40px range around gap midpoints for inter-compartment
        if isInterComp && numel(involvedComps) >= 2
            cp1 = involvedCompPos(1,:);
            cp2 = involvedCompPos(2,:);
            gapMidX2 = (cp1(1) + cp1(3)/2 + cp2(1) + cp2(3)/2) / 2;
            gapMidY2 = (cp1(2) + cp1(4)/2 + cp2(2) + cp2(4)/2) / 2;
            fineOffsets2 = -40:5:40;
            for dx = fineOffsets2
                for dy = fineOffsets2
                    candidates2(end+1,:) = [gapMidX2 + dx, gapMidY2 + dy]; %#ok<AGROW>
                end
            end
        end

        % Evaluate second-pass candidates
        nCand2 = size(candidates2, 1);
        violations2 = zeros(nCand2, 1);
        proximityViols2 = zeros(nCand2, 1);
        inComp2 = false(nCand2, 1);
        distToIdeal2 = zeros(nCand2, 1);

        for ci = 1:nCand2
            cx = candidates2(ci, 1);
            cy = candidates2(ci, 2);
            rxnRect = [cx - RXN_W/2, cy - RXN_H/2, cx + RXN_W/2, cy + RXN_H/2];

            for cc = 1:size(compBounds, 1)
                cb = compBounds(cc,:);
                if rxnRect(1) < cb(3) && rxnRect(3) > cb(1) && ...
                   rxnRect(2) < cb(4) && rxnRect(4) > cb(2)
                    inComp2(ci) = true;
                    break
                end
            end

            for s = 1:nConn
                scx = connCenters(s, 1);
                scy = connCenters(s, 2);
                for b = 1:nBlk
                    if lineIntersectsRect(cx, cy, scx, scy, blocks(b,:))
                        violations2(ci) = violations2(ci) + 1;
                    end
                end
            end

            for b = 1:nBlk
                d = sqrt((cx - blkCenters(b,1))^2 + (cy - blkCenters(b,2))^2);
                if d < MIN_PROXIMITY
                    proximityViols2(ci) = proximityViols2(ci) + 1;
                end
            end

            distToIdeal2(ci) = sqrt((cx - idealCx)^2 + (cy - idealCy)^2);
        end

        % Merge second-pass results with first-pass
        candidates  = [candidates; candidates2];
        violations  = [violations; violations2];
        proximityViols = [proximityViols; proximityViols2];
        inComp      = [inComp; inComp2];
        distToIdeal = [distToIdeal; distToIdeal2];
    end

    %% Select best candidate
    % Priority: no containment, fewest line violations, no proximity issues, closest to ideal
    score = violations * 10000 + inComp * 50000 + proximityViols * 5000 + distToIdeal;
    [~, bestIdx] = min(score);

    bestCx = candidates(bestIdx, 1);
    bestCy = candidates(bestIdx, 2);
    pos = [round(bestCx - RXN_W/2), round(bestCy - RXN_H/2), RXN_W, RXN_H];

    if violations(bestIdx) > 0
        fprintf('Warning: Best position for R%d still has %d line violation(s).\n', ...
            rxnIdx, violations(bestIdx));
        fprintf('  Position: [%d %d %d %d]\n', pos);
    end
end

%% === Helper: parametric line-rect intersection (Liang-Barsky) ===
% Copyright 2026 The MathWorks, Inc.

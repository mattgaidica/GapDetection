% Runs some computation on the points. Gets the distances between each
% point frame-by-frame, then computes the difference or delta of each point
% distance between frames (large spikes in this show when a significant
% even occurs).

function [maxIndexes,allPointsDist,allPointsPhase,diffDistances,diffRanges]=pointCompute(allPoints)
    disp('Computing points...')
    
    % could possibly use the 'distmat' library
    %allPointsDist = zeros(size(allPoints,1),size(allPoints,3)-1);
    allPointsDist = zeros(size(allPoints,1),size(allPoints,3));
    allPointsPhase = zeros(size(allPoints,1),size(allPoints,3));
    refPoint = [300 300];
    
    for i=1:size(allPointsDist,1) %rows of points
       for j=1:size(allPointsDist,2) %frames
           % euclidean dist for each point and frame relative to arbitrary point
           allPointsDist(i,j) = pdist([allPoints(i,1,j) allPoints(i,2,j);refPoint]);
           % phase relationship between each point relative to arbitrary point
           allPointsPhase(i,j) = atan((refPoint(1)-allPoints(i,1,j))/(refPoint(2)-allPoints(i,2,j)));
       end
    end

    diffDistances = zeros(size(allPointsDist,1),size(allPointsDist,2)-1);
    figure;
    hold on;
    for i=1:size(allPointsDist,1) %points rows 
       diffDistance = diff(allPointsDist(i,:)); %change in distance
       diffDistances(i,:) = diffDistance(1,:);
       plot(diffDistance);
       %plot(allPointsDist(i,:))
    end
    hold off;
    
    % it will be important to only use the points that actually deflect (or
    % change), so they need to be ordered into a list of max deflection.
    % This measures peak-to-peak of a point.
    diffRanges = zeros(size(diffDistances,1),1);
    for i=1:size(diffDistances,1) %diffVect points
        diffRanges(i,1) = range(diffDistances(i,:));
    end
    
    % knowing the average angle identifies a center of the target (the
    % ear). Since this area is already highly masked, it is only mildly
    % instructive to use this metric. More important is whether or not this
    % angle drastically changes, this signals that a point is moving
    % 'normal' to the reference point
    %avgPhase = mean(mean(allPointsPhase)); %this locates a central angle for all points
    maxDiffPhases = zeros(size(allPointsPhase,1),1);
    figure;
    hold on;
    for i=1:size(allPointsPhase,1) %points rows 
       maxDiffPhases(i,:) = max(abs(diff(allPointsPhase(i,:))));
       %plot(allPointsPhase(i,:));
       plot(diff(allPointsPhase(i,:)));
    end
    %plot(1:size(allPointsPhase,2),avgPhase,'*','Color','green');
    hold off;

    [diffValue,maxIndexes]=sort(diffRanges,'descend'); % order by max range with indexes
    maxIndexes = maxIndexes(diffValue < 15); %window filter for large abberations, could also do minimum
    thresholdPhasesIndexes = find(maxDiffPhases<.02); %remove large phase changes, value from observation
    maxIndexes = maxIndexes(ismember(maxIndexes,thresholdPhasesIndexes)); %remove phase abberations
    
end
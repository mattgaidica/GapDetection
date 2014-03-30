% Runs some computation on the points. Gets the distances between each
% point frame-by-frame, then computes the difference or delta of each point
% distance between frames (large spikes in this show when a significant
% even occurs).

function [allPointsDist,diffVects,diffRanges,maxIndexes]=pointCompute(allPoints)
    disp('Computing points...')
    
    % could possibly use the 'distmat' library
    %allPointsDist = zeros(size(allPoints,1),size(allPoints,3)-1);
    allPointsDist = zeros(size(allPoints,1),size(allPoints,3));
    for i=1:size(allPointsDist,1) %rows of points
       for j=1:size(allPointsDist,2) %frames
           % euclidean dist from one frame to the next
           % 300 300 arbitrary point on animals back!
           allPointsDist(i,j) = pdist([allPoints(i,1,j) allPoints(i,2,j);300 300]);
       end
    end

    diffVects = zeros(size(allPointsDist,1),size(allPointsDist,2)-1);
    figure;
    hold on;
    for i=1:size(allPointsDist,1) %points rows 
       diffVect = diff(allPointsDist(i,:)); %change in distance
       diffVects(i,:) = diffVect(1,:);
       plot(diffVect);
       %plot(allPointsDist(i,:))
    end
    hold off;

    % it will be important to only use the points that actually deflect (or
    % change), so they need to be ordered into a list of max deflection.
    % This measures peak-to-peak of a point.
    diffRanges = zeros(size(diffVects,1),1);
    for i=1:size(diffVects,1) %diffVect points
        diffRanges(i,1) = range(diffVects(i,:));
    end

    [B,I]=sort(diffRanges,'descend'); % order by max range with indexes
    maxIndexes = I(B < 12); %window filter for large abberations
end
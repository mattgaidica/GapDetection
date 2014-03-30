% This runs all the functions in order and saves the variables in an m-file
% at the end. If you are using similar videos you don't need to re-draw the
% region of interest (ROI), so you can pass that in from your first
% session.

function runAll(videoFile,leftRoi,rightRoi)    
    if(isempty(leftRoi))
        leftRoi=drawRoi(videoFile);
    end
    if(isempty(rightRoi))
        rightRoi=drawRoi(videoFile);
    end
    
    leftMask=earMask(videoFile,leftRoi);
    rightMask=earMask(videoFile,rightRoi);
    
    leftAllPoints=trackPoints(videoFile,leftMask);
    rightAllPoints=trackPoints(videoFile,rightMask);
    
    [leftIndexes,leftPointsDist,leftPointsPhase,leftDiffDistances,leftDiffRanges]=pointCompute(leftAllPoints);
    [rightIndexes,rightPointsDist,rightPointsPhase,rightDiffDistances,rightDiffRanges]=pointCompute(rightAllPoints);
    
    displayEars(videoFile,leftIndexes,leftAllPoints,rightIndexes,rightAllPoints);
    
    [~,name,~] = fileparts(videoFile);
    save([name '_' datestr(now,'ddmmyyyy_HHMM')]);
    
    disp('Done.')
end
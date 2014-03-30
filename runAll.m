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
    
    [leftPointDist,leftDiffVects,leftDiffRanges,leftMaxIndexes]=pointCompute(leftAllPoints);
    [rightPointDist,rightDiffVects,rightDiffRanges,rightMaxIndexes]=pointCompute(rightAllPoints);
    
    displayEars(videoFile,leftMaxIndexes,leftAllPoints,rightMaxIndexes,rightAllPoints);
    
    [~,name,~] = fileparts(videoFile);
    save([name '_' datestr(now,'ddmmyyyy_HHMM')]);
    
    disp('Done.')
end
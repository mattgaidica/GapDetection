function runAll(videoFile)
    leftRoi=drawRoi(videoFile);
    rightRoi=drawRoi(videoFile);
    leftMask=earMask(videoFile,leftRoi);
    rightMask=earMask(videoFile,rightRoi);
    leftAllPoints=trackPoints(videoFile,leftMask);
    rightAllPoints=trackPoints(videoFile,rightMask);
    [leftPointDist,leftDiffVects,leftDiffRanges,leftMaxIndexes]=pointCompute(leftAllPoints);
    [rightPointDist,rightDiffVects,rightDiffRanges,rightMaxIndexes]=pointCompute(rightAllPoints);
    
    displayEars(videoFile,leftMaxIndexes,leftAllPoints,rightMaxIndexes,rightAllPoints);
    
    save(datestr(now,'ddmmyyyy_HHMM'));
end
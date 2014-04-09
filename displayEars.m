% Draws points onto a video. Most importantly, it is not until this final
% step that the amount of points ('samples') is chosen to represent the
% centroid of the ear. This takes the most active (based on deflection)
% points and averages them together to represent the final ear data point.

function [meanLeft,meanRight,saveVideoAs]=displayEars(videoFile,leftIndexes,leftAllPoints,rightIndexes,rightAllPoints)
    video = VideoReader(videoFile);
    
    [pathstr,name,ext] = fileparts(videoFile);
    saveVideoAs = fullfile(pathstr,['MG_' name ext]);
    newVideo = VideoWriter(saveVideoAs,'Motion JPEG AVI');
    newVideo.Quality = 100;
    newVideo.FrameRate = 20;
    open(newVideo);
    
    meanLeft = zeros(video.NumberOfFrames,2);
    meanRight = zeros(video.NumberOfFrames,2);
    
    maxPoints = 2;
    leftIndexes = leftIndexes(1:min(maxPoints,size(leftIndexes,1)));
    rightIndexes = rightIndexes(1:min(maxPoints,size(rightIndexes,1)));

    for i=1:video.NumberOfFrames
        disp(['Writing video...' num2str(i)])
        im = read(video,i);
        meanLeft(i,:) = mean(leftAllPoints(leftIndexes,:,i));
        im = insertShape(im,'Circle',[meanLeft(i,:) 4],'Color','green');
        meanRight(i,:) = mean(rightAllPoints(rightIndexes,:,i));
        im = insertShape(im,'Circle',[meanRight(i,:) 4],'Color','green');
        for j=1:size(leftIndexes,1) %how many points to plot, max 2
            im = insertShape(im,'FilledCircle',[leftAllPoints(leftIndexes(j),:,i) 2]);
        end
        for j=1:size(rightIndexes,1) %how many points to plot, max 2
            im = insertShape(im,'FilledCircle',[rightAllPoints(rightIndexes(j),:,i) 2]);
        end
        writeVideo(newVideo,im);
        imshow(im)
    end
    close(newVideo);
end
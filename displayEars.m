function [meanLeft,meanRight,saveVideoAs]=displayEars(videoFile,leftMaxIndexes,leftAllPoints,rightMaxIndexes,rightAllPoints)
    video = VideoReader(videoFile);
    
    [pathstr,name,ext] = fileparts(videoFile);
    saveVideoAs = fullfile(pathstr,['MG_' name '.' ext]);
    newVideo = VideoWriter(saveVideoAs,'Motion JPEG AVI');
    newVideo.Quality = 100;
    newVideo.FrameRate = 20;
    open(newVideo);

    samplePoints = 5;
    for i=1:video.NumberOfFrames
        disp(i)
        im = read(video,i);
        meanLeft = mean(leftAllPoints(leftMaxIndexes(1:samplePoints),:,i));
        im = insertShape(im,'Circle',[meanLeft 4],'Color','green');
        meanRight = mean(rightAllPoints(rightMaxIndexes(1:samplePoints),:,i));
        im = insertShape(im,'Circle',[meanRight 4],'Color','green');
        for j=1:samplePoints; %how many points to plot
            im = insertShape(im,'FilledCircle',[leftAllPoints(leftMaxIndexes(j),:,i) 2]);
            im = insertShape(im,'FilledCircle',[rightAllPoints(rightMaxIndexes(j),:,i) 2]);
        end
        writeVideo(newVideo,im);
        %imshow(im)
    end
    close(newVideo);
end
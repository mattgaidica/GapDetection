function displayEars(videoFile,leftCentroids,rightCentroids,coords)
    video = VideoReader(videoFile);
    
    newVideo = VideoWriter(['MG2_' videoFile],'Motion JPEG AVI');
    newVideo.Quality = 100;
    newVideo.FrameRate = 20;
    open(newVideo);

    leftClean = cleanEars(leftCentroids);
    leftOverallMean = nanmean(leftClean);
    leftMeanSlope = (leftOverallMean(2)-coords(2))/(leftOverallMean(1)-coords(1));
    leftMeanAngle = atan(leftMeanSlope);
    
    rightClean = cleanEars(rightCentroids);
    rightOverallMean = nanmean(rightClean);
    rightMeanSlope = (rightOverallMean(2)-coords(2))/(rightOverallMean(1)-coords(1));
    rightMeanAngle = atan(rightMeanSlope);
    
    for i=60:100%video.NumberOfFrames
        disp(i)
        im = read(video,i);
        im = insertShape(im,'FilledCircle',[coords(1) coords(2) 10]);

        im = drawEar(im,leftClean(i,:),leftMeanAngle,coords);
        im = drawEar(im,rightClean(i,:),rightMeanAngle,coords);
        writeVideo(newVideo,im);
        
        %imshow(im)
    end
    close(newVideo);
end

function [im]=drawEar(im,point,meanAngle,coords)
    dist = pdist([point(1,:);coords]);
    newRow = round(coords(2)-dist*sin(meanAngle));
    newCol = round(coords(1)-dist*cos(meanAngle));

    im = insertShape(im,'Line',[newCol newRow coords(1) coords(2)]);
    im = insertShape(im,'FilledCircle',[newCol newRow 3],'Color','red');
end
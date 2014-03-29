function [allMasks]=earMask(videoFile,ROI)
    video = VideoReader(videoFile);
    detector = vision.ForegroundDetector('NumTrainingFrames', 30,'InitialVariance', 10*10);
    allMasks = zeros(video.Height,video.Width);

    for i=30:110%video.NumberOfFrames
        disp(i)
        im = read(video,i);
        foregroundMask = step(detector,im);

        hsvIm = rgb2hsv(im);
        v = hsvIm(:,:,3);
        %v(v < .2) = 0; %if you wanted to bound brightness
        v(~ROI>0) = 0;
        
        iterativeMask = foregroundMask&v;
        iterativeMask = bwdist(iterativeMask) < 3;
        iterativeMask = imopen(iterativeMask,strel('disk',3));
        iterativeMask = imclose(iterativeMask,strel('disk',3));
        iterativeMask = imfill(iterativeMask,'holes');
        
        if(i==1)
            allMasks=iterativeMask;
        else
            allMasks = imfill(allMasks,'holes');
            allMasks = allMasks|iterativeMask;
        end
    end
end
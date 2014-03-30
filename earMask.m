% Uses a foreground detector (only applied after NumTrainingFrames) and
% compiles an overall movement mask. Paired with the ROI, this is useful in
% pinpointing where to look for features.

function [allMasks]=earMask(videoFile,Roi)
    video = VideoReader(videoFile);
    detector = vision.ForegroundDetector('NumTrainingFrames',30,'InitialVariance',10*10);
    allMasks = zeros(video.Height,video.Width);
    % bounding the frames where movement occurs makes this a bit more
    % accurate and speeds things up, optional (ex. 1:video.NumberOfFrames)
    for i=30:110
        disp(['Creating mask from foreground... ' num2str(i)])
        im = read(video,i);
        foregroundMask = step(detector,im);

        % simply extracts the brightness channel from the HSV image, useful
        % if you wanted to threshold, but could use rgb2gray instead
        hsvIm = rgb2hsv(im);
        v = hsvIm(:,:,3);
        %v(v < .2) = 0;
        v(~Roi>0) = 0; %applies the ROI to this image itself
        
        % these are just cleaning up the image, turning specs into blobs
        iterativeMask = foregroundMask&v;
        iterativeMask = bwdist(iterativeMask) < 2;
        iterativeMask = imopen(iterativeMask,strel('disk',2));
        iterativeMask = imclose(iterativeMask,strel('disk',2));
        iterativeMask = imfill(iterativeMask,'holes');
        
        if(i==1)
            allMasks=iterativeMask;
        else
            allMasks = imfill(allMasks,'holes');
            allMasks = allMasks|iterativeMask;
        end
        imshow(allMasks);
    end
end
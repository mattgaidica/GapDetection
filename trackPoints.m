function [allPoints]=trackPoints(videoFile,mask)
    video = VideoReader(videoFile);
    
    props = regionprops(mask,'Area','BoundingBox');
    [maxArea,maxIndex] = max([props.Area]);
    region = round(props(maxIndex).BoundingBox);
    
    im = read(video,1);
    imGray = im2double(rgb2gray(im));
    imGray(~mask) = NaN;
    maskRegion = imGray(region(2):(region(2)+region(4)),region(1):(region(1)+region(3)));
    maskRegion = inpaint_nans(maskRegion); %blurred
    imGray(region(2):(region(2)+region(4)),region(1):(region(1)+region(3))) = maskRegion(:,:);
    imGray(isnan(imGray)) = 0;
    
%     threeChMask = repmat(mask, [1, 1, 3]);
%     im(~threeChMask) = 0;
    %im = insertShape(im, 'Rectangle', region,'Color', 'red'); %reference
 
    points = detectMinEigenFeatures(imGray,'ROI',region);
    tracker = vision.PointTracker('MaxBidirectionalError',inf,'BlockSize',[11 11]);
    initialize(tracker,points.Location,im);

    allPoints = zeros(size(points,1),2,video.NumberOfFrames);
    for i=1:video.NumberOfFrames
        disp(i)
        im = read(video,i);
        [points, validity] = step(tracker,im);
        allPoints(:,:,i) = points(validity,:);
%         im=insertMarker(im,points(validity,:),'+');
%         imshow(im);
    end
end
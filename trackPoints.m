function [allPoints]=trackPoints(videoFile,mask)
    video = VideoReader(videoFile);

    im = read(video,1);
    %im = im&mask; %apply mask
    props = regionprops(mask,'Area','BoundingBox');
    [maxArea,maxIndex] = max([props.Area]);
    region = round(props(maxIndex).BoundingBox);

    points = detectMinEigenFeatures(rgb2gray(im),'ROI',region);
    tracker = vision.PointTracker('MaxBidirectionalError', inf,'BlockSize',[21 21]);
    initialize(tracker,points.Location,im);

    allPoints = zeros(size(points,1),2,video.NumberOfFrames);
    for i=1:video.NumberOfFrames
        disp(i)
        im = read(video,i);
        [points, validity] = step(tracker,im);
        allPoints(:,:,i) = points(validity,:);
    end
end
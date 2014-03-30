function [allPoints]=trackPoints(videoFile,mask)
    video = VideoReader(videoFile);
    im = read(video,1);
    
    [C,H,W] = FindLargestRectangles(mask,[0 0 1]);
    [~,pos] = max(C(:));
    [r,c] = ind2sub(size(C),pos);
    region = [c,r,W(r,c),H(r,c)];
    
%     im = insertShape(im,'Rectangle', region,'Color', 'red'); %reference
 
    points = detectMinEigenFeatures(rgb2gray(im),'ROI',region);
    tracker = vision.PointTracker('MaxBidirectionalError',inf,'BlockSize',[15 15]);
    initialize(tracker,points.Location,im);

    allPoints = zeros(size(points,1),2,video.NumberOfFrames);
    for i=1:video.NumberOfFrames
        disp(['Tracking points...' num2str(i)])
        im = read(video,i);
        [points,validity] = step(tracker,im);
%         badIndexes = find(validity==0);
%         for j=1:size(badIndexes)
%            points(badIndexes(j),:) = NaN(1,2); 
%         end
      
        allPoints(:,:,i) = points(validity,:);
%         im=insertMarker(im,points(validity,:),'+');
%         imshow(im);
    end
end
% Adds a tracking object to the masked-ROI's that have been created.
% Because the Eigen features use a square region, this finds the largest
% region within the masked-ROI and uses that. If you don't do this, you
% will get features points on the edges of the ears and the grating of the
% cage.

function [allPoints]=trackPoints(videoFile,mask)
    video = VideoReader(videoFile);
    im = read(video,1);
    
    % http://www.mathworks.com/matlabcentral/fileexchange/28155-inscribedrectangle/content/html/Inscribed_Rectangle_demo.html
    [C,H,W] = FindLargestRectangles(mask,[0 0 1]);
    [~,pos] = max(C(:));
    [r,c] = ind2sub(size(C),pos);
    region = [c,r,W(r,c),H(r,c)];
    
%     im = insertShape(im,'Rectangle', region,'Color', 'red'); %reference
 
    points = detectMinEigenFeatures(rgb2gray(im),'ROI',region);
    % Anything other than inf for the 'MaxBidirectionalError' requires you
    % to handle validity flags since the matrix is of a predefined size
    tracker = vision.PointTracker('MaxBidirectionalError',inf,'BlockSize',[15 15]);
    initialize(tracker,points.Location,im);

    allPoints = zeros(size(points,1),2,video.NumberOfFrames);
    iteratedValidity = ones(size(points));
    for i=1:video.NumberOfFrames
        disp(['Tracking points...' num2str(i)])
        im = read(video,i);
        [points,validity] = step(tracker,im);
        iteratedValidity = iteratedValidity&validity;
        allPoints(:,:,i) = points;
        im=insertMarker(im,points(validity,:),'+');
        imshow(im);
    end
    % prune everything that was ever invalid
    allPoints = allPoints(iteratedValidity,:,:);
end
video = VideoReader('videos/NO_PPN BBN Trial 8.avi');
videoPlayer = vision.VideoPlayer('Position', [100, 100, 680, 520]);

objectFrame = read(video,1);
figure; imshow(objectFrame);
objectRegion=round(getPosition(imrect));
% objectImage = insertShape(objectFrame, 'Rectangle', objectRegion,'Color', 'red');
% figure; imshow(objectImage); title('Yellow box shows object region');

points = detectMinEigenFeatures(rgb2gray(objectFrame), 'ROI', objectRegion);
pointImage = insertMarker(objectFrame, points.Location, '+', 'Color', 'white');
figure, imshow(pointImage), title('Detected interest points');

markerInserter = vision.MarkerInserter('Shape','Plus','BorderColor','White');

tracker = vision.PointTracker('MaxBidirectionalError', inf,'BlockSize',[21 21]);
initialize(tracker,points.Location,objectFrame);

allPoints = zeros(size(points,1),2,video.NumberOfFrames);

for i=1:video.NumberOfFrames
      frame = read(video,i);
      [points, validity] = step(tracker, frame);
      out = insertMarker(frame, points(validity, :), '+');
      step(videoPlayer, out);
      allPoints(:,:,i) = points(validity,:);
end

release(videoPlayer);

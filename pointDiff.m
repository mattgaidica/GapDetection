allPointsDist = zeros(size(allPoints,1),size(allPoints,3)-1);
for i=1:size(allPointsDist,1) %rows of points
   for j=1:size(allPointsDist,2) %frames
       %euclidean dist from one frame to the next
       allPointsDist(i,j) = pdist([allPoints(i,1,j) allPoints(i,2,j);allPoints(i,1,j+1) allPoints(i,2,j+1)]);
   end
end

diffVects = zeros(size(allPointsDist,1),size(allPointsDist,2)-1);
hold on;
for i=1:size(allPointsDist,1) %points rows 
   diffVect = diff(allPointsDist(i,:)); %change  in distance
   diffVects(i,:) = diffVect(1,:);
   plot(diffVect);
   %plot(allPointsDist(i,:))
end
hold off;

diffRanges = zeros(size(diffVects,1),1);
for i=1:size(diffVects,1) %diffVect points
    diffRanges(i,1) = range(diffVects(i,:));
end

[B,I]=sort(diffRanges,'descend'); % order by max range with indexes
I = I(B < 8); %window filter for bad data points
figure;
video = VideoReader('videos/NO_PPN BBN Trial 8.avi');
for i=1:video.NumberOfFrames
    disp(i)
    im = read(video,i);
    for j=1:10 %how many points to plot
        im = insertShape(im,'Circle',[allPoints(I(j),:,i) 2]);
    end
    imshow(im)
end
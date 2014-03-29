function [centroids]=findEars(videoFile,coords,mask)
%idx = sub2ind(size(A), row, col)
%[r, c] = ind2sub(size(A), idx)

    video = VideoReader(videoFile);
    detector = vision.ForegroundDetector('NumTrainingFrames', 30,'InitialVariance', 10*10);
    centroids = NaN(video.NumberOfFrames,2);

%     allMasks = zeros(video.Height,video.Width);

    for i=30:100%video.NumberOfFrames
        disp(i)
        im = read(video,i);
        foregroundMask = step(detector,im);

        hsvIm = rgb2hsv(im);
        v = hsvIm(:,:,3);
        %v(v < .2) = 0;
        v(~mask>0) = 0;
        
        finalMask = foregroundMask&v;
        %finalMask = bwdist(finalMask) < 2;
        finalMask = imopen(finalMask,strel('disk',3));
        finalMask = imclose(finalMask,strel('disk',3));
        finalMask = imfill(finalMask,'holes');
        imshow(finalMask);
        
%         if(i==1)
%             allMasks=finalMask;
%         else
%             allMasks = imfill(allMasks,'holes');
%             allMasks=allMasks|finalMask;
%         end
%         red = im(:,:,1);     
%         red(allMasks > 0) = 1;
%         im(:,:,1) = red;
%         

        %imshow(im);
        
        [r,c] = find(finalMask>0);
        dist = zeros(size(r));
        for j=1:size(r,1)
           dist(j) = pdist([coords(1) coords(2);c(j) r(j)]);
        end
        distr = round(dist);
        modeIndexes=find(distr==min(distr)); %most frequent distance (min right now)
        % averaged center
        centroid = [mean(c(modeIndexes)),mean(r(modeIndexes))];
        centroids(i,:) = centroid;
        
        hold on;
        for j=1:size(modeIndexes)
            plot(c(modeIndexes(j)),r(modeIndexes(j)),'o');
        end 
        plot(centroid(1),centroid(2),'*','Color','red');
        hold off;

% 
%         props = regionprops(finalMask,'Area','Centroid');
%         if(~isempty(props))
%             centroids = cat(1,props.Centroid);
%             leftIndexes = find(centroids(:,2)>=300);
%             if(max([props(leftIndexes).Area]) > 50)
%                 leftCentroids(i,:) = [mean(centroids(leftIndexes,1)) mean(centroids(leftIndexes,2))];
%             end
%             rightIndexes = find(centroids(:,2)<300);
%             if(max([props(rightIndexes).Area]) > 50)
%                 rightCentroids(i,:) = [mean(centroids(rightIndexes,1)) mean(centroids(rightIndexes,2))];
%             end
%         end
    end
end
function [centroids] = cleanEars(centroids)
    [rows,~,~] = find(~isnan(centroids));
    startIndex = min(rows); % where everything starts
    endIndex = max(rows); % where everything ends
    
    [vals,ids] = max(centroids); %indexes
    minVals = min(centroids);
    
    fillThis = NaN((endIndex-startIndex)+1,2);
    fillThis(1,:) = minVals(1,:);
    fillThis(size(fillThis,1),:) = minVals(1,:);
    fillThis(min(ids)-startIndex,:) = [vals(1) vals(2)];
    fillThis(endIndex-max(ids),:) = [vals(1) vals(2)];
    fillThis = inpaint_nans(fillThis);
    
    centroids(startIndex:endIndex,:)=fillThis;
    
    for i=1:startIndex-1
        centroids(i,:) = centroids(startIndex,:);
    end
    for i=endIndex+1:size(centroids,1)
        centroids(i,:) = centroids(endIndex,:);
    end
    
% 
%     cleanCentroids = inpaint_nans(cleanCentroids);
    
%     window = 2;
%     x = cleanCentroids(:,1);
%     y = cleanCentroids(:,2);
%     x = medfilt1(x,window);
%     y = medfilt1(y,window);
%     x = smooth(x,window);
%     y = smooth(y,window);
%     cleanCentroids(:,1) = x;
%     cleanCentroids(:,2) = y;
    
    %rawCentroids(minIndex:maxIndex,:) = cleanCentroids;
end
function [mask]=drawRoi(videoFile)
    video = VideoReader(videoFile);
    im = read(video,1);
    h_im = imshow(im);
    mask = createMask(imfreehand,h_im);
    mask = imfill(mask,'holes');
    close;
end
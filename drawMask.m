function [BW]=drawMask(im)
    h_im = imshow(im);
    BW=createMask(imfreehand,h_im);
end
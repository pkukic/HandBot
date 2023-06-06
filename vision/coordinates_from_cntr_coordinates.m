function [x_new, y_new] = coordinates_from_cntr_coordinates(img, x, y)
    img_size = size(img);
    c_x = img_size(2) / 2;
    c_y = img_size(1) / 2;
    x_new = x + c_x;
    y_new = y + c_y;
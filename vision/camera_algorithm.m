function [] = camera_algorithm(img, color_order)
    green_coordinates = get_green_coordinates(img);
    blue_coordinates = get_blue_coordinates(img);
    yellow_coorindates = get_yellow_coordinates(img);

    

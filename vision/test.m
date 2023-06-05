function [colors] = test(image, cameraParams, R, t)
    blue_test_image = get_blue_coordinates(image);
    green_test_image = get_green_coordinates(image);
    yellow_test_image = get_yellow_coordinates(image);
    black_test_image = get_black_coordinates(image);

    blue = pointsToWorld(cameraParams, R, t, blue_test_image);
    green = pointsToWorld(cameraParams, R, t, green_test_image);
    yellow = pointsToWorld(cameraParams, R, t, yellow_test_image);
    black = pointsToWorld(cameraParams, R, t, black_test_image);
    colors = [blue; green; yellow; black];
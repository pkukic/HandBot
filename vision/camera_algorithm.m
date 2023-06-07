function [p1, p2, p3, p4, p5, p6] = camera_algorithm(img, color_order, R, t, cameraParams)
    % Outputs the coordinates in the robot frame according to designated
    % color order (p2, p4, p6 are points on the black rectangle) 
    green_coordinates = get_green_coordinates(img);
    blue_coordinates = get_blue_coordinates(img);
    yellow_coorindates = get_yellow_coordinates(img);

    green_robot_frame = pointsToWorld(cameraParams.Intrinsics, R, t, green_coordinates);
    blue_robot_frame = pointsToWorld(cameraParams.Intrinsics, R, t, blue_coordinates);
    yellow_robot_frame = pointsToWorld(cameraParams.Intrinsics, R, t, yellow_coorindates);

    robot_frame_dictionary = containers.Map();
    robot_frame_dictionary('g') = green_robot_frame;
    robot_frame_dictionary('b') = blue_robot_frame;
    robot_frame_dictionary('y') = yellow_robot_frame;

    p1 = robot_frame_dictionary(color_order(1));
    p3 = robot_frame_dictionary(color_order(2));
    p5 = robot_frame_dictionary(color_order(3));

    [b1, b2, b3] = get_black_coordinates(img);
    
    p2 = pointsToWorld(cameraParams.Intrinsics, R, t, b1);
    p4 = pointsToWorld(cameraParams.Intrinsics, R, t, b2);
    p6 = pointsToWorld(cameraParams.Intrinsics, R, t, b3);
    


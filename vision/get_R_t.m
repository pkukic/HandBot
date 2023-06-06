function [R, t] = get_R_t(img, cameraParams)
    % using the instrinsic parameters we can undistort the image if necessary 
    % [img_undist, newOrigin] = undistortImage(img,cameraParams,'OutputView','full');

    % detect corners in the image
    [imagePoints,boardSize] = detectCheckerboardPoints(img);

    % set size of a square in milimeters and calculate locations in the checkerboard frame
    squareSize = 18;
    checkerboard_points = generateCheckerboardPoints(boardSize, squareSize);
    
    % create homogeneous coordinates
    checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];
    
    % measure the pose of the pattern in the frame {R}

    T = [0 -1 0 217;
         -1 0 0 73;
         0 0 -1 0;
         0 0 0 1];
    
    % transform corner points to frame {R}
    worldPoints = transpose(T*transpose(checkerboard_points_h));
    worldPoints = worldPoints(:,1:2);
    
    % calculate extrinsic parameters
    [R, t] = extrinsics(imagePoints, worldPoints, cameraParams);
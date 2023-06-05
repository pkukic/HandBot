load('cameraParams.mat');

img = imread('determine_coordinates.png');
[img_undist,newOrigin] = undistortImage(img,cameraParams,'OutputView','full');

coordinates_green_img = get_green_coordinates(img_undist);
coordinates_black_img = get_black_coordinates(img_undist);
coordinates_blue_img = get_blue_coordinates(img_undist);
coordinates_yellow_img = get_yellow_coordinates(img_undist);

imagePoints = [coordinates_green_img; 
                coordinates_black_img; 
                coordinates_blue_img, 
                coordinates_yellow_img];
worldPoints = [115, 90;
                45, 80;
                -25, 120;
                -55, 20];

[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);
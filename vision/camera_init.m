load('cameraParams.mat');

img = imread('calculate_transformation.jpg');
[img_undist,newOrigin] = undistortImage(img, cameraParams, 'OutputView', 'full');

[R, t] = get_R_t(img_undist, cameraParams);
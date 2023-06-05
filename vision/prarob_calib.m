%% assignment 1 - get images
camera_info = imaqhwinfo('winvideo', 1);
% use camera_info = imaqhwinfo('winvideo') on Windows machine

% uncomment lines below if you get memory issue errors
% imaqreset;
% imaqmex('feature','-limitPhysicalMemoryUsage',false);

video_obj = videoinput('winvideo', camera_info.DeviceID, camera_info.DefaultFormat);

video_obj.ReturnedColorSpace = 'rgb';
f = figure('Visible', 'off'); 
vidRes = video_obj.VideoResolution;
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));
num_images = 20;
for i=1:num_images
    % preview video object
    preview(video_obj, hImage);
    waitforbuttonpress;
    stoppreview(video_obj);
    % start to enable grab
    start(video_obj);
    img = getdata(video_obj);
    img = img(:, :, (1:3));
    imwrite(img, "calib_img"+num2str(i)+".png")
    % imwrite(img, "determine_coordinates.png")
    stop(video_obj);

end

clear video_obj

%% Assignment 2
% After running the Camera Calibrator app, display the matrix of intrinsic
% parameters

cameraParams.Intrinsics.IntrinsicMatrix

%% Assignment 3
camera_info = imaqhwinfo('winvideo', 2);
% get one image
video_obj = videoinput('winvideo', camera_info.DeviceID, camera_info.DefaultFormat);
video_obj.ReturnedColorSpace = 'rgb';
f = figure('Visible', 'off'); 
vidRes = video_obj.VideoResolution;
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));
% preview video object
preview(video_obj, hImage);
waitforbuttonpress;
stoppreview(video_obj);
% start to enable grab
start(video_obj);
img = getdata(video_obj);
img = img(:, :, (1:3));
stop(video_obj);
clear video_obj

% using the instrinsic parameters we can undistort the image if necessary 
[img_undist,newOrigin] = undistortImage(img,cameraParams,'OutputView','full');

% detect corners in the image
[imagePoints,boardSize] = detectCheckerboardPoints(img_undist);

% set size of a square in milimeters and calculate locations in the checkerboard frame
squareSize = 18;
worldPoints = generateCheckerboardPoints(boardSize, squareSize);

% calculate extrinsic parameters
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);

[orientation_from_pattern, location_from_pattern] = extrinsicsToCameraPose(R, t);

% display location of the camera with respect to the pattern frame
location_from_pattern

%% Assignment 4
squareSize = 18;
checkerboard_points = generateCheckerboardPoints(boardSize, squareSize);

% create homogeneous coordinates
checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];

% measure the pose of the pattern in the frame {R}
T = [1 0 0 43;
     0 -1 0 99;
     0 0 -1 0; 
     0 0 0 1]; 

% transform corner points to frame {R}
worldPoints = transpose(T*transpose(checkerboard_points_h));
worldPoints = worldPoints(:,1:2);

[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);

[orientation_from_world, location_from_world] = extrinsicsToCameraPose(R, t);

% display position of camera in the {R} frame
location_from_world

%% Assignment 5
camera_info = imaqhwinfo('winvideo', 2);
% get one image where camera axis is vertical with respect to the pattern
video_obj = videoinput('winvideo', camera_info.DeviceID, camera_info.DefaultFormat);
video_obj.ReturnedColorSpace = 'rgb';
f = figure('Visible', 'off'); 
vidRes = video_obj.VideoResolution;
imageRes = fliplr(vidRes);
hImage = imshow(zeros(imageRes));
% preview video object
preview(video_obj, hImage);
waitforbuttonpress;
stoppreview(video_obj);
% start to enable grab
start(video_obj);
img = getdata(video_obj);
img = img(:, :, (1:3));
stop(video_obj);
clear video_obj
imshow(img)

% using the instrinsic parameters we can undistort the image if necessary 
[img_undist,newOrigin] = undistortImage(img,cameraParams,'OutputView','full');

% detect corners in the image
[imagePoints,boardSize] = detectCheckerboardPoints(img_undist);

% set size of a square in milimeters and calculate locations in the checkerboard frame
squareSize = 18;
checkerboard_points = generateCheckerboardPoints(boardSize, squareSize);

% create homogeneous coordinates
checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];

% measure the pose of the pattern in the frame {R}
T = [1 0 0 43;
     0 -1 0 99;
     0 0 -1 0; 
     0 0 0 1];

% transform corner points to frame {R}
worldPoints = transpose(T*transpose(checkerboard_points_h));
worldPoints = worldPoints(:,1:2);

% calculate extrinsic parameters
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);

[orientation_from_pattern, location_from_pattern] = extrinsicsToCameraPose(R, t);

% insert processing to extract the colored circle from the image
img_hsv = rgb2hsv(img);

red_lower_h_bound = 0.90;
red_upper_h_bound = 1;
min_saturation = 0.3;
min_value = 0.3;

img_red = img_hsv(:,:,1) > red_lower_h_bound & ...
           img_hsv(:,:,1) < red_upper_h_bound & ...
           img_hsv(:,:,2) > min_saturation & ...
           img_hsv(:,:,3) > min_value;

% extract the centroid of the colored circle 
m_00 = calculate_moment(img_red, [0 0]);
m_10 = calculate_moment(img_red, [1 0]);
m_01 = calculate_moment(img_red, [0 1]);

u = m_10 / m_00;
v = m_01 / m_00;

% using intrinsic camera matrix and distance of the pattern from the camera
% calculate the world coordinates of the colored circle

% z_pattern = % distance of the pattern from the camera
% u = % centroid x value in pixels
% v = % centroid y value in pixels
% cx, cy, fx, fy are instrinsic camera parameters, extract them from the
% matrix
cx =  cameraParams.Intrinsics.K(1, 3);
cy =  cameraParams.Intrinsics.K(2, 3);
fx =  cameraParams.Intrinsics.K(1, 1);
fy =  cameraParams.Intrinsics.K(2, 2);
z_pattern = location_from_pattern(3);
% insert calculation from the lecture slides
x_camera = [];
y_camera = [];
z_camera = [];

% convert to homogeneous coordinates
centroid_camera_h = [x_camera; y_camera; z_camera; 1];

% calculate centroid in world coordinate frame
T_world_camera = [orientation_from_world', location_from_world'; 0 0 0 1];

centroid_world_h = T_world_camera * centroid_camera_h;

% display position of the object in frame {R}
centroid_world = centroid_world_h(1:3,1)

%% Assignment 6

% get one image with arbitrary orientation of the pattern
% video_obj = videoinput('winvideo', camera_info.DeviceID, camera_info.DefaultFormat);
% video_obj.ReturnedColorSpace = 'rgb';
% f = figure('Visible', 'off'); 
% vidRes = video_obj.VideoResolution;
% imageRes = fliplr(vidRes);
% hImage = imshow(zeros(imageRes));
% % preview video object
% preview(video_obj, hImage);
% waitforbuttonpress;
% stoppreview(video_obj);
% % start to enable grab
% start(video_obj);
% img = getdata(video_obj);
% img = img(:, :, (1:3));
% stop(video_obj);
% clear video_obj

img = imread('test_image.png');
img = img(:, :, (1:3));

% using the instrinsic parameters we can undistort the image if necessary 
[img_undist,newOrigin] = undistortImage(img,cameraParams,'OutputView','full');

% detect corners in the image
[imagePoints,boardSize] = detectCheckerboardPoints(img_undist);

% set size of a square in milimeters and calculate locations in the checkerboard frame
squareSize = 19;
checkerboard_points = generateCheckerboardPoints(boardSize, squareSize);

% create homogeneous coordinates
checkerboard_points_h = [checkerboard_points zeros(size(checkerboard_points,1),1) ones(size(checkerboard_points,1),1)];

% measure the pose of the pattern in the frame {R}
T = [1 0 0 43;
     0 -1 0 99;
     0 0 -1 0;
     0 0 0 1];

% transform corner points to frame {R}
worldPoints = transpose(T*transpose(checkerboard_points_h));
worldPoints = worldPoints(:,1:2);

% calculate extrinsic parameters
[R, t] = extrinsics(imagePoints, worldPoints, cameraParams);

% insert processing to extract the colored circle from the image
img_hsv = rgb2hsv(img);

red_lower_h_bound = 0.90;
red_upper_h_bound = 1;
min_saturation = 0.3;
min_value = 0.3;

img_red = img_hsv(:,:,1) > red_lower_h_bound & ...
           img_hsv(:,:,1) < red_upper_h_bound & ...
           img_hsv(:,:,2) > min_saturation & ...
           img_hsv(:,:,3) > min_value;
imshow(img_red)
% extract the centroid of the colored circle 
m_00 = calculate_moment(img_red, [0 0]);
m_10 = calculate_moment(img_red, [1 0]);
m_01 = calculate_moment(img_red, [0 1]);

u = m_10 / m_00;
v = m_01 / m_00;

% u = % centroid x value in pixels
% v = % centroid y value in pixels

% display position of the object in frame {R}
pointsToWorld(cameraParams.Intrinsics, R, t, [u v])


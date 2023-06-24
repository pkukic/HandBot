load('cameraParams.mat');

% img = imread('calculate_transformation.jpg');
camera_info = imaqhwinfo('winvideo', 2);
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
[img_undist,newOrigin] = undistortImage(img, cameraParams, 'OutputView', 'full');

[R, t] = get_R_t(img_undist, cameraParams);
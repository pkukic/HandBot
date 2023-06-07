function [p1, p2, p3, p4, p5, p6] = camera(color_order, cameraParams, R, t)
    % color_order is like ['g', 'y', 'b']
    % take the image
    camera_info = imaqhwinfo('winvideo', 1);
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
    
    [img, newOrigin] = undistortImage(img,cameraParams,'OutputView','full');

    % return the points
    [p1, p2, p3, p4, p5, p6] = camera_algorithm(img, color_order, R, t, cameraParams);
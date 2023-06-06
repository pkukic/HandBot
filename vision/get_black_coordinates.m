function [coordinates] = get_black_coordinates(image)
    image = image(:,:,(1:3));
    gauss_filt = fspecial('gaussian', [20,20], 2);
    image = imfilter(image, gauss_filt);
    image_gray = rgb2gray(image);
    threshold = 50;

    image_extracted = image_gray < threshold;
    se = strel("square", 20);
    image_closed = imclose(image_extracted, se);

    image_single_centroid = only_largest_area(image_closed);
    img_size = size(image_single_centroid);
    center_point = [img_size(2) / 2, img_size(1) / 2];

    % Perform connected component analysis
    cc = bwconncomp(image_single_centroid);
    
    % Calculate the properties of connected components
    props = regionprops(cc, 'Orientation', 'BoundingBox');
    boundingBox = props.BoundingBox;
    % Get the orientation
    angle = -props.Orientation;

    % Rotate the image
    % rotatedImage = imrotate(image_single_centroid, angle, 'bilinear');
    % rotatedImage = imresize(rotatedImage, size(image_single_centroid));
    % img_size_r = size(rotatedImage);
    % center_point_r = [img_size_r(2) / 2, img_size_r(1) / 2];
    % imshow(rotatedImage);
    % center_points_diff = center_point_r - center_point;
    
    % % Get the bounding box of the shape in the rotated image
    % % Perform connected component analysis
    % cc = bwconncomp(rotatedImage);
    % 
    % Calculate the properties of connected components
    % cc_r = bwconncomp(rotatedImage);
    % props = regionprops(cc_r, 'BoundingBox');
    % 
    % % Get the bounding box of the rectangle
    % boundingBox = props.BoundingBox;
    % 
    % calculate bounding box coordinates
    top_left = [boundingBox(1), boundingBox(2)];
    top_right = [boundingBox(1) + boundingBox(3), boundingBox(2)];
    bottom_left = [boundingBox(1), boundingBox(2) + boundingBox(4)];
    bottom_right = [boundingBox(1) + boundingBox(3), boundingBox(2) + boundingBox(4)];
    % 
    % x_increment = (top_right(1) - top_left(1)) / 6;
    % y_rotated = (bottom_left(2) + top_left(2)) / 2;
    % 
    % x1_rotated = top_left(1) + x_increment;
    % x2_rotated = top_left(1) + 3 * x_increment;
    % x3_rotated = top_left(1) + 5 * x_increment;
    % 
    % p1_r = [x1_rotated, y_rotated];
    % p2_r = [x2_rotated, y_rotated];
    % p3_r = [x3_rotated, y_rotated];
    % 
    % imshow(rotatedImage)
    % hold on;
    % plot([top_left(1), top_right(1), bottom_left(1), bottom_right(1)], [top_left(2), top_right(2), bottom_left(2), bottom_right(2)], 'r*');
    % plot(p1_r(1), p1_r(2), 'ro');
    % plot(p2_r(1), p2_r(2), 'go');
    % plot(p3_r(1), p3_r(2), 'bo');
    % plot(center_point_r(1), center_point_r(2), 'y*');
    % hold off;
    % 
    % p1_r_cntr = coordinates_to_cntr_coordinates(rotatedImage, p1_r(1), p1_r(2));
    % p2_r_cntr = coordinates_to_cntr_coordinates(rotatedImage, p2_r(1), p2_r(2));
    % p3_r_cntr = coordinates_to_cntr_coordinates(rotatedImage, p3_r(1), p3_r(2));
    % 
    % R = [cosd(angle) -sind(angle); sind(angle) cosd(angle)];
    % 
    % 
    % p1_cntr = R * p1_r_cntr';
    % p2_cntr = R * p2_r_cntr';
    % p3_cntr = R * p3_r_cntr';
    % [x1, y1] = coordinates_from_cntr_coordinates(image_single_centroid, p1_cntr(1), p1_cntr(2));
    % [x2, y2] = coordinates_from_cntr_coordinates(image_single_centroid, p2_cntr(1), p2_cntr(2));
    % [x3, y3] = coordinates_from_cntr_coordinates(image_single_centroid, p3_cntr(1), p3_cntr(2));

    % imshow(image_single_centroid)
    % hold on;
    % plot(x1, y1, 'ro');
    % plot(x2, y2, 'go');
    % plot(x3, y3, 'bo');
    % hold off;




    % 
    % % imshow(rotatedImage);
    % % 
    % % % Display the points in the original image coordinate system
    % % hold on;
    % % plot(p1_r(1), p1_r(2), 'ro');
    % % plot(p2_r(1), p2_r(2), 'go');
    % % plot(p3_r(1), p3_r(2), 'bo');
    % % hold off;
    % 
    % % Define the rotation matrix
    % R = [cosd(angle) -sind(angle); sind(angle) cosd(angle)];
    % R = R';
    % % disp(R)
    % imageCenterOriginal = (size(image_single_centroid)) / 2;
    % imageCenterRotated = (size(rotatedImage)) / 2;
    % % disp(size(rotatedImage));
    % disp(size(image_single_centroid));
    % % disp(angle)
    % 
    % % Calculate the coordinates in the original image coordinate system
    % % point1_original = R' * (p1_r - [cols/2; rows/2]) + [cols/2; rows/2];
    % % point2_original = R' * (p2_r - [cols/2; rows/2]) + [cols/2; rows/2];
    % % point3_original = R' * (p3_r - [cols/2; rows/2]) + [cols/2; rows/2];
    % 
    % % point1_original = (R * (p1_r' - [cols/2; rows/2]))' + [cols/2, rows/2];
    % % point2_original = (R * (p2_r' - [cols/2; rows/2]))' + [cols/2, rows/2];
    % % point3_original = (R * (p3_r' - [cols/2; rows/2]))' + [cols/2, rows/2];
    % 
    % point1_original = R * (p1_r' - [imageCenterRotated(2); imageCenterRotated(1)]) + [imageCenterOriginal(2); imageCenterOriginal(1)];
    % point2_original = R * (p2_r' - [imageCenterRotated(2); imageCenterRotated(1)]) + [imageCenterOriginal(2); imageCenterOriginal(1)];
    % point3_original = R * (p3_r' - [imageCenterRotated(2); imageCenterRotated(1)]) + [imageCenterOriginal(2); imageCenterOriginal(1)];
    % 
    % % disp(point1_original)
    % % disp(point2_original)
    % % disp(point3_original)
    % %Display the original image
    % 
    % rotatedImage = imrotate(rotatedImage, -angle, 'bilinear');
    % imshow(rotatedImage);
    % 
    % % Display the points in the original image coordinate system
    % hold on;
    % plot(point1_original(1), point1_original(2), 'ro');
    % plot(point2_original(1), point2_original(2), 'go');
    % plot(point3_original(1), point3_original(2), 'bo');
    % hold off;




    % % 
    % Find column and row indices of non-zero (1) pixels
    [rowIndices, colIndices] = find(image_single_centroid == 1);

    % get the bottom pixel
    % Find the pixel with the highest y-value
    [~, maxRowIndex] = max(rowIndices);
    y_bottom = rowIndices(maxRowIndex);
    x_bottom = colIndices(maxRowIndex);

    % get the top pixel
    % Find the pixel with the lowest y-value
    [~, minRowIndex] = min(rowIndices);
    y_top = rowIndices(minRowIndex);
    x_top = colIndices(minRowIndex);

    x_increment = round((top_right(1) - top_left(1))/ 6);
    y_increment = round((bottom_left(2) - top_left(2)) / 6);

    % the rectangle is going left to right
    if x_bottom < x_top
        x1 = bottom_left(1) + x_increment;
        y1 = top_left(2) + 5 * y_increment;

        x2 = bottom_left(1) + 3 * x_increment;
        y2 = top_left(2) + 3 * y_increment;

        x3 = bottom_left(1) + 5 * x_increment;
        y3 = top_left(2) + y_increment;
    else
        % the rectangle is going right to left
        x1 = bottom_left(1) + 5 * x_increment;
        y1 = top_left(2) + 5 * y_increment;

        x2 = bottom_left(1) + 3 * x_increment;
        y2 = top_left(2) + 3 * y_increment;

        x3 = bottom_left(1) + x_increment;
        y3 = top_left(2) + y_increment;
    end

    imshow(image_single_centroid);
    hold on;
    % plot([top_left(1), top_right(1), bottom_left(1), bottom_right(1)], [top_left(2), top_right(2), bottom_left(2), bottom_right(2)], 'r*');
    % plot([x_top, x_bottom], [y_top, y_bottom], 'r*');
    plot([x1, x2, x3], [y1, y2, y3], 'r*');
    %plot([x_top, x_bottom, x_left, x_right], [y_top, y_bottom, y_left, y_right], 'r*');
    hold off;
    

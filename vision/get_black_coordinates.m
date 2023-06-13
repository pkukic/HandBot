function [p1, p2, p3] = get_black_coordinates(image)
    gauss_filt = fspecial('gaussian', [20,20], 2);
    image = imfilter(image, gauss_filt);
    image_gray = rgb2gray(image);
    threshold = 50;

    image_extracted = image_gray < threshold;
    se = strel("square", 20);
    image_closed = imclose(image_extracted, se);

    % imshow(image_closed)

    image_single_centroid = only_largest_area(image_closed);

    % Perform connected component analysis
    cc = bwconncomp(image_single_centroid);
    
    % Calculate the properties of connected components
    props = regionprops(cc, 'Orientation', 'BoundingBox');
    boundingBox = props.BoundingBox;

    % calculate bounding box coordinates
    top_left = [boundingBox(1), boundingBox(2)];
    top_right = [boundingBox(1) + boundingBox(3), boundingBox(2)];
    bottom_left = [boundingBox(1), boundingBox(2) + boundingBox(4)];
    bottom_right = [boundingBox(1) + boundingBox(3), boundingBox(2) + boundingBox(4)];

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

    p1 = [x1, y1];
    p2 = [x2,  y2];
    p3 = [x3, y3];

    % imshow(image_single_centroid);
    % hold on;
    % % plot([top_left(1), top_right(1), bottom_left(1), bottom_right(1)], [top_left(2), top_right(2), bottom_left(2), bottom_right(2)], 'r*');
    % % plot([x_top, x_bottom], [y_top, y_bottom], 'r*');
    % plot([x1, x2, x3], [y1, y2, y3], 'r*');
    % %plot([x_top, x_bottom, x_left, x_right], [y_top, y_bottom, y_left, y_right], 'r*');
    % hold off;
    

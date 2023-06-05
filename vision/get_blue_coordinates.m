function [coordinates] = get_blue_coordinates(image)
    image = image(:,:,(1:3));
    gauss_filt = fspecial('gaussian', [5,5], 1.5);
    image = imfilter(image, gauss_filt);
    image_hsv = rgb2hsv(image);
    green_lower_hsv_boud = 0.6;
    green_upper_hsv_bound = 0.7;
    min_saturation = 0.5;
    min_value = 0.5;

    image_extracted = image_hsv(:,:,1) > green_lower_hsv_boud & ...
                        image_hsv(:,:,1) < green_upper_hsv_bound & ...
                        image_hsv(:,:,2) > min_saturation & ...
                        image_hsv(:,:,3) > min_value;
    se = strel("square", 7);
    image_closed = imclose(image_extracted, se);
    image_single_centroid = only_largest_area(image_closed);
    stats = regionprops(image_single_centroid, 'Centroid', 'Area');
    centroid = stats.Centroid;

    imshow(image_single_centroid);
    figure;
    imshow(image);
    hold on;
    plot(centroid(1), centroid(2), 'r*'); % Plot the centroid as a red star
    hold off;

    coordinates = [centroid(1), centroid(2)];

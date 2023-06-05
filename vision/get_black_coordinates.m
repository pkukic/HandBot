function [coordinates] = get_black_coordinates(image)
    image = image(:,:,(1:3));
    gauss_filt = fspecial('gaussian', [10,10], 1.5);
    image = imfilter(image, gauss_filt);
    image_gray = rgb2gray(image);
    threshold = 50;

    image_extracted = image_gray < threshold;
    se = strel("square", 20);
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

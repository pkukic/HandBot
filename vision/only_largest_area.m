function [largest_area_bin] = only_largest_area(img)
    largest_area_bin = bwareafilt(img, 1);
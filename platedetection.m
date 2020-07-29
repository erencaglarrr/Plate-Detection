close all;
clear all;

%�l�eklendirme ve siyah beyaz i�lemi 
figure(1);
im1 = imread('4.jpg');
im2 = imresize(im1, [550 580]);
im2 = rgb2gray(im2);
imshow(im2);
title('Original Grayscale Image');

%Kenar bulma 
[BW1,thresh] = edge(im2,'canny',0.5);
figure(2); imshow(BW1); 
BW2 = edge(im2,'log');
BW = or(BW1,BW2);
figure(11); imshow(BW);
title('Edge Detection Image');

%Dikey ve yatay �izgiler ayr�ld�
figure(3);
BW_v = imdilate(BW, strel('line', 3, 90));
BW_vh = imdilate(BW_v, strel('line', 3, 0));
imshow(BW_vh);
title('Horizontal and Vertical Line Dilation');

%500 den k���k pixel b�lgeleri remove ettim
figure(4);
BW_open = bwareaopen(BW, 500);
imshow(BW_open);
title('Remove Small Regions <500 pixels');

%B�lgedeki bo�luklar� doldurdum
figure(5);
BW_fill = imfill(BW_open, 'holes');
imshow(BW_fill);
title('Fill region holes');

%dikd�rtgen b�lge bulma
regions = regionprops(BW_fill, 'BoundingBox', 'Image', 'Extent');
regionsNum = size(regions,1);

%dikd�rtgenleri boyutlar�na g�re filtreledim
for i = 1:regionsNum
    region = regions(i);
    if size(region.Image,2) >= 4*size(region.Image,1) ... 
            && region.Extent > 0.7
        plate = imcrop(im2, region.BoundingBox); 
    else
        plate = 0; %olumsuz sonu�lar i�in error vermesin diye yazd�m 
    end
end


%Kenar bulma i�lemi 
figure(8);
BW_plate = edge(plate,'canny');
BW_plate = 1-BW_plate;
imshow(BW_plate); 
title('Edge Detection of Plate'); 

%yanl��sa canny ile tekrar hesaplamaya giri� 
a = input('y/n: ');
if a == 1 
    close all
else
    
close all;
figure(1);
im1 = imresize(im1, [555 741]);
im1 = rgb2gray(im1);
imshow(im1);
title('Original Grayscale Image');

%Edge Detection
figure(2);
[BW,thresh] = edge(im1,'canny', 0.5);
imshow(BW);
title('Edge Detection Image');

figure(3);
BW_v = imdilate(BW, strel('line', 3, 90));
BW_vh = imdilate(BW_v, strel('line', 3, 0));
imshow(BW_vh);
title('Horizontal and Vertical Line Dilation');

%500 pixelden k���k pixelleri sildim
figure(4);
BW_open = bwareaopen(BW_vh, 500);
imshow(BW_open);
title('Remove Small Regions <500 pixels');

%B�lgedeki delikleri doldurdum
figure(5);
BW_fill = imfill(BW_open, 'holes');
imshow(BW_fill);
title('Fill region holes');

%11 11 lik bir yap� eleman� ile imerode ettim
figure(6);
BW_er = imerode(BW_fill, strel('rectangle', [11 11]));
imshow(BW_er);
title('Erode by rectangle');
 
regions = regionprops(BW_er, 'BoundingBox', 'Image', 'Extent');
regionsNum = size(regions,1);

for i = 1:regionsNum
    region = regions(i);
    if size(region.Image,2) >= 4*size(region.Image,1) ... 
            && region.Extent > 0.8
        plate = imcrop(im1, region.BoundingBox); 
        
        figure(1);
        rectangle('position', region.BoundingBox, 'edgecolor', ...
            'g', 'linewidth',2);
        break;
    end
end

figure(8);
BW_plate = edge(plate,'canny');
BW_plate = 1-BW_plate;
imshow(BW_plate); 
title('Edge Detection of Plate');

end



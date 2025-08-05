function Active_Image=Load_image(filename, Plot_YN)

Active_Image=imread(filename);

if Plot_YN
    figure()
    subplot(2,3,2)
    imagesc(Active_Image)
    title('Original Image')
    subplot(2,3,5)
    imagesc(Active_Image(:,:,1))
    title('RED')
    subplot(2,3,6)
    imagesc(Active_Image(:,:,2))
    title('GREEN')
    subplot(2,3,4)
    imagesc(Active_Image(:,:,3))
    title('BLUE')

    f=figure(111);
    pixPerUm = 260/ 69.4;
    unit = sprintf('%sm', '\mu'); % micrometer
    scalebarLength=70;
    hAx = axes(f);
    imshow(Active_Image(1:929,:,:))
    hScalebar = scalebar(hAx, 'x', scalebarLength, unit, 'Location', 'southeast', ...
        'ConversionFactor', pixPerUm,'Color', 'w', 'LineWidth',2  );


    figure()
    imshow(Active_Image(1:929,:,:))
%     title('Original Image') 
    figure()
    imshow(Active_Image)
%     title('Original Image')
    figure()
    imshow(Active_Image(1:929,:,2))
    colormap gray
%     title('Green channel')
    figure()
    imshow(Active_Image(1:929,:,3))
%     title('Blue channel')
    colormap gray
end





end
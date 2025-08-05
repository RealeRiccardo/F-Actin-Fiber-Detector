function Polarization_perp_parall=Detect_parall_perp_fibers(Fibers_image, ROI, Active_image, Plot_YN)

% % % LOAD DIRECTRIX DATA
x1=ROI.Directrix.Position(1,1);
x2=ROI.Directrix.Position(2,1);
y1=ROI.Directrix.Position(1,2);
y2=ROI.Directrix.Position(2,2);

Polarization_threshold=0.7;

% % % COMPUTE DIRECTRIX ORIENTATION
Slope=-(y2-y1)/(x2-x1);
Dir_angle = atand(Slope);

% % % CREATE BASE CONVOLUTION MASK
Conv_mask_half_window=5;
Orientations_points=30;
Conv_mask_base=false(201,201);
Conv_mask_base(:,99:101)=true;

% CYCLE ON PARALLEL ORIENTATIONS
Orientations_mask_list_parall=((Dir_angle-Orientations_points):2:(Dir_angle+Orientations_points))-90;
Conv_parall=0;
Parallel_Fiber_Image=zeros(size(Fibers_image,1)+Conv_mask_half_window*2,size(Fibers_image,2)+Conv_mask_half_window*2);
for kkk=1:numel(Orientations_mask_list_parall)

    Orientations_mask=Orientations_mask_list_parall(kkk);

    % % % CREATE ROTATED MASK
    Conv_mask_rot = imrotate(Conv_mask_base, Orientations_mask);

    Conv_mask=Conv_mask_rot(round(size(Conv_mask_rot,1)/2)-Conv_mask_half_window:round(size(Conv_mask_rot,1)/2)+Conv_mask_half_window,...
                            round(size(Conv_mask_rot,2)/2)-Conv_mask_half_window:round(size(Conv_mask_rot,2)/2)+Conv_mask_half_window);

    
    % if kkk<31
    % figure(998)
    % subplot(5,6, kkk)
    % imshow(Conv_mask)
    % end

    % % % CONVOLVE IMAGE WITH MASK
    Convolved=conv2(Fibers_image,Conv_mask);

    Conv_parall=Conv_parall+sum(Convolved/sum(Conv_mask,'all')>Polarization_threshold,'all');
     
    Parallel_Fiber=(Convolved/sum(Conv_mask,'all'))>Polarization_threshold;
    Parallel_Fiber_Image= Parallel_Fiber_Image | Parallel_Fiber;
  
    if Plot_YN
        figure(555)
        subplot(1,2,1)
        imshow(Fibers_image)
        hold on
        plot([x1,x2], [y1,y2])

        subplot(1,2,2)
        imagesc(Convolved/sum(Conv_mask,'all')>Polarization_threshold)
        colorbar
        %     pause()
        pause(0.1)
    end
end

% CYCLE ON PERPENDICULAR ORIENTATIONS
Orientations_mask_list_perp=((Dir_angle-Orientations_points):2:(Dir_angle+Orientations_points));
Conv_perp=0;
Perpendicular_Fiber_Image=zeros(size(Fibers_image,1)+Conv_mask_half_window*2,size(Fibers_image,2)+Conv_mask_half_window*2);
for kkk=1:numel(Orientations_mask_list_perp)

    Orientations_mask=Orientations_mask_list_perp(kkk);
    
    % % % CREATE ROTATED MASK
    Conv_mask_rot = imrotate(Conv_mask_base, Orientations_mask);

    Conv_mask=Conv_mask_rot(round(size(Conv_mask_rot,1)/2)-Conv_mask_half_window:round(size(Conv_mask_rot,1)/2)+Conv_mask_half_window,...
                            round(size(Conv_mask_rot,2)/2)-Conv_mask_half_window:round(size(Conv_mask_rot,2)/2)+Conv_mask_half_window);
   

 
 % if kkk<31
 %    figure(999)
 %    subplot(5,6, kkk)
 %    imshow(Conv_mask)
 %    end
    



    % % % CONVOLVE IMAGE WITH MASK
    Convolved=conv2(Fibers_image,Conv_mask);

  

    Perpendicular_Fiber=(Convolved/sum(Conv_mask,'all'))>Polarization_threshold;
    Perpendicular_Fiber_Image= Perpendicular_Fiber_Image | Perpendicular_Fiber;

    Conv_perp=Conv_perp+sum(Convolved/sum(Conv_mask,'all')>Polarization_threshold,'all');

    if Plot_YN
        figure(555)
        subplot(1,2,1)
        imshow(Fibers_image)
        hold on
        plot([x1,x2], [y1,y2])

        subplot(1,2,2)
        imagesc(Convolved/sum(Conv_mask,'all')>Polarization_threshold)
        colorbar
        %     pause()
        pause(0.1)
    end
end

% % % COMPUTE POLARIZATION RATIO
Polarization_perp_parall=Conv_perp/Conv_parall;

imgSize=size(Fibers_image);
finalSize=size(Perpendicular_Fiber_Image,1);   
padImg=zeros(finalSize);

padImg(finalSize/2+(1:imgSize(1))-floor(imgSize(1)/2),...
       finalSize/2+(1:imgSize(2))-floor(imgSize(2)/2))=Fibers_image;

Oblique_Fiber_Image=padImg & ~(Perpendicular_Fiber_Image | Parallel_Fiber_Image);

% figure()
% imshow(Im_G)
figure()
imshow(Perpendicular_Fiber_Image)
% title('Perpendicular')
% subplot(1,3,2)
figure
imshow(Parallel_Fiber_Image)
% title('Parallel')
% subplot(1,3,3)
% imshow(Oblique_Fiber_Image)
% title('oblique')
% pause()

Im_G=Active_image(:,:,2);

Im_G_padded(finalSize/2+(1:imgSize(1))-floor(imgSize(1)/2),...
       finalSize/2+(1:imgSize(2))-floor(imgSize(2)/2))=Im_G;

% % % PREPARE NICE IMAGE
for jjj=1:size(Im_G_padded,1)
    for kkk=1:size(Im_G_padded,2)
        if Perpendicular_Fiber_Image(jjj,kkk)
            NICE_IMAGE(jjj,kkk,1)=255;
            NICE_IMAGE(jjj,kkk,2)=0;
            NICE_IMAGE(jjj,kkk,3)=255;

            Mask_perp(jjj,kkk)=true;
            Mask_para(jjj,kkk)=false;

        elseif Parallel_Fiber_Image(jjj,kkk)
            NICE_IMAGE(jjj,kkk,1)=255;
            NICE_IMAGE(jjj,kkk,2)=255;
            NICE_IMAGE(jjj,kkk,3)=0;

            Mask_perp(jjj,kkk)=false;
            Mask_para(jjj,kkk)=true;

        else
            NICE_IMAGE(jjj,kkk,1)=Im_G_padded(jjj,kkk);
            NICE_IMAGE(jjj,kkk,2)=Im_G_padded(jjj,kkk);
            NICE_IMAGE(jjj,kkk,3)=Im_G_padded(jjj,kkk);

            Mask_perp(jjj,kkk)=false;
            Mask_para(jjj,kkk)=false;

        end
    end
end
% figure(665)
% imshow(Im_G_padded)
figure(667)
imshow(NICE_IMAGE)

figure()
outpict = labeloverlay(imadjust(Im_G_padded),Mask_perp,'colormap',[0.8 0 0.8],'transparency',0);
outpict = labeloverlay(outpict,Mask_para,'colormap',[1 1 0],'transparency',0);
imshow(outpict,'border','tight')


end

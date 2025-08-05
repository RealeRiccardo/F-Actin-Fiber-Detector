function [N_fibers, Fibers_area, Fibers_length, Polarization, F_N_overlap, Fibers_image]=...
    Detect_fibers(Active_Image, CH, GOOD_Fiber_Th, nuclei_bin, Plot_YN)

Im_G_old=Active_Image(:,:,CH);

% Im_G(Im_G==255)=0;
Im_G=imadjust(Im_G_old); % ADDED FOR HF

if Plot_YN
    figure(990)
    imshow(Im_G)
    figure(889)
    imshow(Im_G_old)
end

% % % ENHANCE FIBERS
Im_G_fiber = fibermetric(Im_G, 6,'ObjectPolarity','bright', 'StructureSensitivity',1);  % STANDARD
% Im_G_fiber = fibermetric(Im_G, 6,'ObjectPolarity','bright', 'StructureSensitivity',2.55);
Cell_borders=edge(Im_G,"Canny", 0.45);

% figure()
% histogram(reshape(Im_G, 1,numel(Im_G)))
% Im_bin=imbinarize(Im_G,"adaptive","Sensitivity",0.5);
% Thresh=40;
% Im_thresh=zeros(size(Im_G));
% Im_thresh(Im_G>Thresh)=1;
% Im_thresh=imfill(Im_bin,'holes');

% figure()
% imshow(Im_bin)


if Plot_YN
    figure(991)
    imshow(Im_G_fiber)
    % title('Green channel: Fiber enhancement')
end

% % % BINARIZE
fibers_bin=imbinarize(Im_G_fiber,0.5); %STANDARD
% fibers_bin=imbinarize(Im_G_fiber,0.7);

if Plot_YN
    figure(992)
    imshow(fibers_bin)
    % title('Green channel: Binarized image')
end

% % % FIND FIBERS
Regions=regionprops(fibers_bin,'MajorAxisLength', 'Eccentricity', 'PixelIdxList', 'PixelList', 'Area');

N_regions=numel(Regions);
N_fibers=0;
Fibers_image=false(size(Im_G));
fibers_rgb=zeros(size(Im_G));

for iii=1:N_regions
    % % % CHECK IF REGION QUALIFIES AS FIBER
    if Regions(iii).MajorAxisLength>GOOD_Fiber_Th.LengthMin && ...
            Regions(iii).MajorAxisLength<GOOD_Fiber_Th.LengthMax && ...
            Regions(iii).Eccentricity>GOOD_Fiber_Th.Ecc
        N_fibers=N_fibers+1;
        Fibers(N_fibers).Length=Regions(iii).MajorAxisLength;
        Fibers(N_fibers).Ecc=Regions(iii).Eccentricity;
        Fibers(N_fibers).Area=Regions(iii).Area;
        Fibers_image(Regions(iii).PixelIdxList)=true;

        % % % FIGURES
        if Plot_YN
            thisFibers_image=false(size(Im_G));
            thisFibers_image(Regions(iii).PixelIdxList)=true;
            colors=[255*rand(),255*rand(),255*rand()];
            for jjj=1:size(Fibers_image,1)
                for kkk=1:size(Fibers_image,2)
                    if thisFibers_image(jjj,kkk)
                        fibers_rgb(jjj,kkk,1)=colors(1);
                        fibers_rgb(jjj,kkk,2)=colors(2);
                        fibers_rgb(jjj,kkk,3)=colors(3);
                    end
                end
            end
        end
    end
end

figure(993)
imshow(Fibers_image)
% title('Green channel: Fibers identification')

% % % COMPUTE FIBER/NUCLEI OVERLAP
F_N_overlap=sum(Fibers_image & nuclei_bin, 'all')/sum(nuclei_bin, 'all');

% % % COMPUTE FIBER POLARIZATION
Polarization=0;
% [Conv_score, Polarization]=Detect_orientation(Fibers_image);

% % % COMPUTE FIBER AREA AND LENGTH
Fibers_area=sum(extractfield(Fibers,'Area'));
Fibers_length=sum(extractfield(Fibers,'Length'));

if Plot_YN
    figure(111)
    histogram(extractfield(Fibers,'Length'),50,'BinLimits', [0,250])
    % histogram(extractfield(Fibers,'Length'),50,'BinLimits', [0,1000])
    xlabel('Fiber length [pixels]')
    ylabel('Count')
end

% % Borders_area=sum(Cell_borders,'all');
% % Fibers_area=Fibers_area-Borders_area;

% FIGURES
if Plot_YN

    for jjj=1:size(Im_G,1)
        for kkk=1:size(Im_G,2)
            % if Cell_borders(jjj,kkk)
            %     NICE_IMAGE(jjj,kkk,1)=0;
            %     NICE_IMAGE(jjj,kkk,2)=255;
            %     NICE_IMAGE(jjj,kkk,3)=0;
            % elseif Fibers_image(jjj,kkk)
            if Fibers_image(jjj,kkk)
                NICE_IMAGE(jjj,kkk,1)=255;
                NICE_IMAGE(jjj,kkk,2)=0;
                NICE_IMAGE(jjj,kkk,3)=0;
            else
                NICE_IMAGE(jjj,kkk,1)=Im_G(jjj,kkk);
                NICE_IMAGE(jjj,kkk,2)=Im_G(jjj,kkk);
                NICE_IMAGE(jjj,kkk,3)=Im_G(jjj,kkk);
            end

        end
    end


    pixPerUm = 260/ 69.4;
    unit = sprintf('%sm', '\mu'); % micrometer

    % % % DETAIL IMAGES
    % % % f=figure(888);
    % % % hAx = axes(f);
    % % % % imshow(NICE_IMAGE  )
    % % % imshow(NICE_IMAGE(375:585,175:365, :)  )
    % % % hScalebar = scalebar(hAx, 'x', scalebarLength, unit, 'Location', 'southeast', ...
    % % %     'ConversionFactor', pixPerUm,'Color', 'w', 'LineWidth',2  );
    % % %
    % % % f=figure(889)
    % % % hAx = axes(f);
    % % % imshow(Im_G(375:585,175:365, :)  )
    % % % pixPerUm = 260/ 69.4;
    % % % scalebarLength = 10;  % scalebar will be this micrometer long
    % % % unit = sprintf('%sm', '\mu'); % micrometer
    % % % hScalebar = scalebar(hAx, 'x', scalebarLength, unit, 'Location', 'southeast', ...
    % % %     'ConversionFactor', pixPerUm,'Color', 'w', 'LineWidth',2  );

    f=figure(665);
    scalebarLength=70;
    hAx = axes(f);
    imshow(Im_G)
    % hScalebar = scalebar(hAx, 'x', scalebarLength, unit, 'Location', 'southeast', ...
    %     'ConversionFactor', pixPerUm,'Color', 'w', 'LineWidth',2  );

    f=figure(666);
    scalebarLength=70;
    hAx = axes(f);
    imshow(NICE_IMAGE)
    % hScalebar = scalebar(hAx, 'x', scalebarLength, unit, 'Location', 'southeast', ...
    %     'ConversionFactor', pixPerUm,'Color', 'w', 'LineWidth',2  );

    drawnow
end





end
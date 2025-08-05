function [N_fibers, Fibers_area, Fibers_length, Polarization, F_N_overlap, Fibers_image]=...
    Detect_fibers_ROI(Active_Image, CH, GOOD_Fiber_Th, nuclei_bin, ROI, Nuclei_image, Plot_YN)

Im_G=imadjust(Active_Image(:,:,CH));

% % % ENHANCE FIBERS
Im_G_fiber = fibermetric(Im_G, 6,'ObjectPolarity','bright', 'StructureSensitivity',0.2);

figure()
imshow(Im_G_fiber)

% % % BINARIZE
fibers_bin=imbinarize(Im_G_fiber,0.5);

figure()
imshow(fibers_bin)

% % % FIND FIBERS
Regions=regionprops(fibers_bin,'MajorAxisLength', 'Eccentricity', 'PixelIdxList', 'PixelList', 'Area', 'Centroid');

N_regions=numel(Regions);
N_fibers=0;
Fibers_image=false(size(Im_G));
fibers_rgb=zeros(size(Im_G));

for iii=1:N_regions
    % % % CHECK IF REGION QUALIFIES AS FIBER
    if Regions(iii).MajorAxisLength>GOOD_Fiber_Th.LengthMin && ...
       Regions(iii).MajorAxisLength<GOOD_Fiber_Th.LengthMax && ...
       Regions(iii).Eccentricity>GOOD_Fiber_Th.Ecc && ...
       inpolygon(Regions(iii).Centroid(1), Regions(iii).Centroid(2),ROI.Area.Position(:,1),ROI.Area.Position(:,2))

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

figure()
imshow(Fibers_image)

% % FIGURES
if Plot_YN
    for jjj=1:size(Fibers_image,1)
        for kkk=1:size(Fibers_image,2)
            if Fibers_image(jjj,kkk) && nuclei_bin(jjj,kkk)
                F_N_overlap_image(jjj,kkk,1)=1;
                F_N_overlap_image(jjj,kkk,2)=0;
                F_N_overlap_image(jjj,kkk,3)=0;
            elseif ~Fibers_image(jjj,kkk) && nuclei_bin(jjj,kkk)
                F_N_overlap_image(jjj,kkk,1)=0;
                F_N_overlap_image(jjj,kkk,2)=1;
                F_N_overlap_image(jjj,kkk,3)=0;
            end
        end
    end
    figure()
    imshow(F_N_overlap_image)
end
 
% % % COMPUTE FIBER/NUCLEI OVERLAP
F_N_overlap=sum(Fibers_image & nuclei_bin, 'all')/sum(nuclei_bin, 'all');

% % % COMPUTE FIBER POLARIZATION
Polarization=0;
% [Conv_score, Polarization]=Detect_orientation(Fibers_image);

% % % COMPUTE FIBER AREA AND LENGTH
Fibers_area=sum(extractfield(Fibers,'Area'));
Fibers_length=sum(extractfield(Fibers,'Length'));

% NICE_IMAGE(1:size(Fibers_image, 1))=0;
%     , size(Fibers_image, 2), 3);
% % % PREPARE NICE IMAGE
for jjj=1:size(Im_G,1)
    for kkk=1:size(Im_G,2)
        if    Fibers_image(jjj,kkk)
            NICE_IMAGE(jjj,kkk,1)=uint8(255);
            NICE_IMAGE(jjj,kkk,2)=uint8(0);
            NICE_IMAGE(jjj,kkk,3)=uint8(0);
            Mask_attempt(jjj,kkk)=true;
        % elseif Nuclei_image(jjj,kkk)
        %     NICE_IMAGE(jjj,kkk,1)=uint8(0);
        %     NICE_IMAGE(jjj,kkk,2)=uint8(200);
        %     NICE_IMAGE(jjj,kkk,3)=uint8(200);
        else
            NICE_IMAGE(jjj,kkk,1)=uint8(Im_G(jjj,kkk));
            NICE_IMAGE(jjj,kkk,2)=uint8(Im_G(jjj,kkk));
            NICE_IMAGE(jjj,kkk,3)=uint8(Im_G(jjj,kkk));
                        Mask_attempt(jjj,kkk)=false;
        end
    end
end

figure(665)
imshow(Im_G)
figure()
outpict = labeloverlay(imadjust(Im_G),Mask_attempt,'colormap',[1 0 0],'transparency',0);
imshow(outpict,'border','tight')

figure(666)
imshow(NICE_IMAGE)
% pause()

% FIGURES
if Plot_YN

    %         figure()
    %         subplot(1,2,1)
    %         imagesc(Im_G)
    %         title('Original image')
    %         subplot(1,3,2)
    %         imagesc(Im_G_fiber)
    %         title('Fiber enhancement')
    %         subplot(1,3,3)
    %         imagesc(fibers_bin)
    %         title('Fiber Identification')

    figure()
    subplot(1,2,1)
    imagesc(Im_G)
    title('Original image')
    %     subplot(1,3,2)
    %     imagesc(fibers_bin)
    %     title('Regions Identified')
    subplot(1,2,2)
    imagesc(uint8(fibers_rgb))
    title('Fibers')

    %     figure()
    %     histogram2( extractfield(Regions,'MajorAxisLength'),  extractfield(Regions,'Eccentricity'),  100, 'XBinLimits', [2,100], 'YBinLimits', [0.4,1],...
    %         'DisplayStyle','tile', 'ShowEmptyBins','off')
    %     xlabel('Fiber length')
    %     ylabel('Fiber eccentricity')
    % %
    %     figure()
    %     subplot(1,3,1)
    %     imagesc(Im_G)
    %     xlim([100,220])
    %     ylim([50,160])
    %     title('Original image')
    %
    %     subplot(1,3,2)
    %     imagesc(Im_G_fiber)
    %     xlim([100,220])
    %     ylim([50,160])
    %     title('Fiber enhancement')
    %     subplot(1,3,3)
    %     imagesc(fibers_bin)
    %     xlim([100,220])
    %     ylim([50,160])
    %     title('Fiber Identification')

    drawnow
end


end
function [N_cells, Nuclei_Area_Total, nuclei_bin, Nuclei_image] =Detect_nuclei_ROI(Active_Image, CH, Nuclei_binarization_type, ROI, Plot_YN)

Im_U=Active_Image(:,:,CH);

% % % BINARIZE
switch Nuclei_binarization_type
    case 'ADAPTIVE'
        nuclei_bin=imbinarize(Im_U, 'adaptive', 'Sensitivity',0.1);
    case 'GLOBAL'
        nuclei_bin=imbinarize(Im_U, 'global');
end

% figure()
% imshow(nuclei_bin)

% % % FIND NUCLEI
nuclei=regionprops(nuclei_bin,'Area', 'Centroid', 'PixelList');

% % % ELIMINATE NUCLEI WITH AREA TOO SMALL
Nuclei_Area_Total=0;
nuclei_centers=[];
Pixel_list=[];
for iii=1:numel(nuclei)
    nuclei_areas(iii)=nuclei(iii).Area;
    nuclei_in_ROI(iii)=inpolygon(nuclei(iii).Centroid(1), nuclei(iii).Centroid(2),ROI.Area.Position(:,1),ROI.Area.Position(:,2));
    if nuclei_areas(iii)>200 && nuclei_in_ROI(iii)
        nuclei_centers(iii,:)=nuclei(iii).Centroid;
        Pixel_list=[Pixel_list;  nuclei(iii).PixelList]; 
        Nuclei_Area_Total=Nuclei_Area_Total+nuclei(iii).Area;
    end
end
N_cells=sum(nuclei_areas>200 & nuclei_in_ROI,'all');

Nuclei_image=false(size(Im_U));
for jjj=1:size(Pixel_list,1)
    Nuclei_image(Pixel_list(jjj,2), Pixel_list(jjj,1))=true;
end
% figure()
% imshow(Nuclei_image)
% pause()

% % % FIGURES
if Plot_YN
    figure()
    subplot(1,2,1)
    imshow(Im_U)
    title('Original Image')
    subplot(1,2,2)
    imshow(nuclei_bin)
    hold on
    plot(nuclei_centers(:,1),nuclei_centers(:,2),'r*')
    hold off
    title('Nuclei identification')
end

end


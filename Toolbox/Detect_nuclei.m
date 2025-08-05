function [N_cells, Nuclei_Area_Total, nuclei_bin] =Detect_nuclei(Active_Image, CH, Nuclei_binarization_type, Plot_YN)

Im_U=Active_Image(:,:,CH);

% % % BINARIZE
switch Nuclei_binarization_type
    case 'ADAPTIVE'
        nuclei_bin=imbinarize(Im_U, 'adaptive', 'Sensitivity',0.05);
    case 'GLOBAL'
        nuclei_bin=imbinarize(Im_U, 'global');
end



% % % FIND NUCLEI
nuclei=regionprops(nuclei_bin,'Area', 'Centroid');

% % % ELIMINATE NUCLE WITH AREA TOO SMALL
Nuclei_Area_Total=0;
nuclei_centers=[];
for iii=1:numel(nuclei)
    nuclei_areas(iii)=nuclei(iii).Area;
    if nuclei_areas(iii)>200
        nuclei_centers(iii,:)=nuclei(iii).Centroid;
        Nuclei_Area_Total=Nuclei_Area_Total+nuclei(iii).Area;
    end
end
N_cells=sum(nuclei_areas>200,'all');

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


    figure()
    imshow(nuclei_bin)
%     title('Blue channel: Binarized image')
    figure()
    imshow(nuclei_bin)
    hold on
    plot(nuclei_centers(:,1),nuclei_centers(:,2),'r*')
    hold off
%     title('Blue channel: Nuclei identification')

end

end


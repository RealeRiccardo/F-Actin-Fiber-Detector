function [Areas, MajorAxisLength, Eccentricity]=Detect_cilia(Active_Image, CH, Plot_YN)

Im_U=Active_Image(:,:,CH);

Im_U_th=false(size(Im_U));
Im_U_th(Im_U>=90)=true;



regions=regionprops(Im_U_th,'Area', 'MajorAxisLength','PixelIdxList', 'Eccentricity');

Areas_all=extractfield(regions,'Area');
MajorAxisLength_all=extractfield(regions,'MajorAxisLength');
Eccentricity_all=extractfield(regions,'Eccentricity');

GOOD=Areas_all>20;

image_tot=false(size(Im_U));
for iii=1:numel(regions)
    if GOOD(iii)
        image_tot(regions(iii).PixelIdxList)=true;
    end
end

MajorAxisLength=MajorAxisLength_all(GOOD);
Eccentricity=Eccentricity_all(GOOD);
Areas=Areas_all(GOOD);

% figure()
% subplot(1,3,1)
% imagesc(Im_U)
% subplot(1,3,2)
% imagesc(Im_U_th)
% subplot(1,3,3)
% imagesc(image_tot)

% 
% figure()
% histogram(EquivDiameter(GOOD),200, 'BinLimits', [0,50])
% pause()

end
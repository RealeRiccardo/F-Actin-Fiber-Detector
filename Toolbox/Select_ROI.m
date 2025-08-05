function [ROI]=Select_ROI(foldername, filename_list, file_extension, EXP)

filesavename=['Partial_results\' EXP.TYPE '_' num2str(EXP.NUM) '_ROI.mat'];

if ~exist(filesavename)
    for iii=1:numel(filename_list)

        filename=[foldername filename_list{iii} file_extension];
        Load_Image=Load_image(filename, 0);

        figure()
        imshow(Load_Image)
        hold on

        disp('Please select ROI')
        ROI(iii).Area = drawpolygon;

%         tic
%         for jjj=1:size(Load_Image,1)
%             for kkk=1:size(Load_Image,2)
%                 ROI(iii).Mask(kkk,jjj)=inpolygon(jjj,kkk,ROI(iii).Area.Position(:,1),ROI(iii).Area.Position(:,2));
%             end
%         end
%         disp('time 2x for=')
%         toc
        
        ROI(iii).Mask=poly2mask(ROI(iii).Area.Position(:,1), ROI(iii).Area.Position(:,2), size(Load_Image,1), size(Load_Image,2));
                
        
        disp('Please select ROI external boundary')
        ROI(iii).Directrix = drawpolyline('Color','r');

    end

    save(filesavename, 'ROI')
else
    disp('Loading external boundary region')
    load(filesavename)
end


end
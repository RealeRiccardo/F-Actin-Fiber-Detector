clear
close all
clc
FNT_SZ=14;

addpath('Toolbox\')

% VALUES USED TYPICALLY
% % % GOOD_Fiber_Th.LengthMin =50;
% % % GOOD_Fiber_Th.LengthMax =10000;
% % % GOOD_Fiber_Th.Ecc       =0.2;

% VALUES USED ONLY FOR GNB MICE
GOOD_Fiber_Th.LengthMin =35;
GOOD_Fiber_Th.LengthMax =1000000;
GOOD_Fiber_Th.Ecc       =0.2;

EXP.TYPE='GNB_MOUSE'; % RPE/HF/CB
EXP.NUM =1;  % CB:1,2,3

Plot_YN=[0, 0, 01, 0, 1]; % [1] LoadImage, [2] DetectNuclei, [3] DetectFibers, [4] DetectFiberOrientation,  [5] Image+ROI


% % % LOAD LIST OF FILES TO ANALYZE
[foldername, filename_list, file_extension, group_list]=Load_file_list_fibers(EXP);

% % % SELECT ACTIVE REGION
[ROI]=Select_ROI(foldername, filename_list, file_extension, EXP);

% for jjj=1:numel(filename_list)
for jjj=2

    % % %  LOAD IMAGE
    filename=[foldername filename_list{jjj} file_extension];
    Load_Image=Load_image(filename, Plot_YN(1));
    Active_Image= Load_Image;

    % % %  VISUALIZE ROI
    if Plot_YN(5)
        figure()
        subplot(1,2,1)
        imshow(Active_Image)
        hold on
        drawpolygon('Position',ROI(jjj).Area.Position)
        plot([ROI(jjj).Directrix.Position(1,1), ROI(jjj).Directrix.Position(2,1)],...
             [ROI(jjj).Directrix.Position(1,2), ROI(jjj).Directrix.Position(2,2)],...
             'r--', 'LineWidth',2)
       subplot(1,2,2) 
       imshow(Active_Image.*uint8(ROI(jjj).Mask))
       

       figure()
        imshow(Active_Image)
        hold on
        drawpolygon('Position',ROI(jjj).Area.Position)
        plot([ROI(jjj).Directrix.Position(1,1), ROI(jjj).Directrix.Position(2,1)],...
             [ROI(jjj).Directrix.Position(1,2), ROI(jjj).Directrix.Position(2,2)],...
             'r--', 'LineWidth',2)
        pause()
    end

    % % %  DETECT NUCLEI
    Nuclei_binarization_type='GLOBAL'; % GLOBAL or ADAPTIVE
    [N_cells(jjj), Nuclei_Area_Total(jjj), nuclei_bin, Nuclei_image]=Detect_nuclei_ROI(Active_Image, 3, Nuclei_binarization_type,   ROI(jjj), Plot_YN(2));    

    % % %  DETECT FIBERS
    [N_fibers(jjj), Fibers_area(jjj), Fibers_length(jjj), Polarization(jjj), F_N_overlap(jjj), Fibers_image{jjj}]...
                            =Detect_fibers_ROI(Active_Image, 2, GOOD_Fiber_Th, nuclei_bin, ROI(jjj), Nuclei_image, Plot_YN(3));
   
    % % %  DETECT FIBER ORIENTATION
    Polarization_perp_parall(jjj)=Detect_parall_perp_fibers(Fibers_image{jjj}, ROI(jjj), Active_Image, Plot_YN(4));



%     [Conv_score]=Detect_orientation(Fibers_image{jjj});
%     Conv_norm(jjj)=max(Conv_score)/Fibers_area(jjj);
% 
    % % % COMPUTE PROPERTIES
    Area_fibers_area_cells(jjj)=Fibers_area(jjj)/Nuclei_Area_Total(jjj);

    if  sum(Plot_YN)>=1
        pause()
        close all
    end


end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
%  RESULTS
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% FIBER POLARIZATION
figure()
bar(Polarization_perp_parall)
ylabel('Fiber polarization (perp/parall)')
set(gca,'xticklabel',filename_list)
fontsize(gca, FNT_SZ, "points")

% avg_Polarization_perp_parall(1) =mean(Polarization_perp_parall(1:6));
% std_Polarization_perp_parall(1) =std(Polarization_perp_parall( 1:6));
% SEM_Polarization_perp_parall(1) =std(Polarization_perp_parall( 1:6))/sqrt(6);
% avg_Polarization_perp_parall(2) =mean(Polarization_perp_parall(7:12));
% std_Polarization_perp_parall(2) =std(Polarization_perp_parall( 7:12));
% SEM_Polarization_perp_parall(2) =std(Polarization_perp_parall( 7:12))/sqrt(6);
avg_Polarization_perp_parall(1) =mean(Polarization_perp_parall(1:5));
std_Polarization_perp_parall(1) =std(Polarization_perp_parall( 1:5));
SEM_Polarization_perp_parall(1) =std(Polarization_perp_parall( 1:5))/sqrt(4);
% avg_Polarization_perp_parall(2) =mean(Polarization_perp_parall(6:10));
% std_Polarization_perp_parall(2) =std(Polarization_perp_parall( 6:10));
% SEM_Polarization_perp_parall(2) =std(Polarization_perp_parall( 6:10))/sqrt(4);

figure()
bar(avg_Polarization_perp_parall)
ylabel('Fiber polarization (perp/parall)')
set(gca,'xticklabel',group_list)
fontsize(gca, FNT_SZ, "points")
hold on
er1 = errorbar(1:numel(group_list),avg_Polarization_perp_parall,std_Polarization_perp_parall,std_Polarization_perp_parall,'LineWidth',1);
er1.Color = [0 0 0];
er1.LineStyle = 'none';
er2 = errorbar(1:numel(group_list),avg_Polarization_perp_parall,SEM_Polarization_perp_parall,SEM_Polarization_perp_parall,'LineWidth',3);
er2.Color = [1 0 0];
er2.LineStyle = 'none';
legend('Sample Mean', 'Standard Deviation' ,  'Standard Error of Mean' , 'Location','NW')

% [h,p1]=ttest2(Polarization_perp_parall(1:6), Polarization_perp_parall(7:12),  'tail', 'both' )
% [h,p1]=ttest2(Polarization_perp_parall(1:5), Polarization_perp_parall(7:10),  'tail', 'both' )


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% FIBER AREA
figure()
bar(Area_fibers_area_cells)
ylabel('^{Total fibers area in ROI}/_{Total nuclei area in ROI}')
set(gca,'xticklabel',filename_list)
fontsize(gca, FNT_SZ, "points")
ylim([0 0.45])

% avg_Area_fibers_cells(1) =mean(Area_fibers_area_cells(1:6));
% std_Area_fibers_cells(1) =std(Area_fibers_area_cells( 1:6));
% SEM_Area_fibers_cells(1) =std(Area_fibers_area_cells( 1:6))/sqrt(5);
% avg_Area_fibers_cells(2) =mean(Area_fibers_area_cells(7:13));
% std_Area_fibers_cells(2) =std(Area_fibers_area_cells( 7:13));
% SEM_Area_fibers_cells(2) =std(Area_fibers_area_cells( 7:13))/sqrt(6);
avg_Area_fibers_cells(1) =mean(Area_fibers_area_cells(1:5));
std_Area_fibers_cells(1) =std(Area_fibers_area_cells( 1:5));
SEM_Area_fibers_cells(1) =std(Area_fibers_area_cells( 1:5))/sqrt(4);
% avg_Area_fibers_cells(2) =mean(Area_fibers_area_cells(6:10));
% std_Area_fibers_cells(2) =std(Area_fibers_area_cells( 6:10));
% SEM_Area_fibers_cells(2) =std(Area_fibers_area_cells( 6:10))/sqrt(4);

figure()
bar(avg_Area_fibers_cells)
ylabel('^{Total fibers area in ROI}/_{Total nuclei area in ROI}')
set(gca,'xticklabel',group_list)
fontsize(gca, FNT_SZ, "points")
ylim([0 0.45])
hold on
er1 = errorbar(1:numel(group_list),avg_Area_fibers_cells,std_Area_fibers_cells,std_Area_fibers_cells,'LineWidth',1);
er1.Color = [0 0 0];
er1.LineStyle = 'none';
er2 = errorbar(1:numel(group_list),avg_Area_fibers_cells,SEM_Area_fibers_cells,SEM_Area_fibers_cells,'LineWidth',3);
er2.Color = [1 0 0];
er2.LineStyle = 'none';
legend('Sample Mean', 'Standard Deviation' ,  'Standard Error of Mean' , 'Location','NW')

% [h,p2]=ttest2(Area_fibers_area_cells(1:6), Area_fibers_area_cells(7:12),  'tail', 'both' )
% [h,p2]=ttest2(Area_fibers_area_cells(1:5), Area_fibers_area_cells(6:10),  'tail', 'both' )

Type(1:6)=0;
Type(7:13)=1;

save(['Partial_results\' EXP.TYPE '_' num2str(EXP.NUM) '.mat'], 'Polarization_perp_parall', 'Area_fibers_area_cells','Type')


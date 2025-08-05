clear
close all
clc
FNT_SZ=14;

addpath('Toolbox\')

% % % RPE
GOOD_Fiber_Th.LengthMin =50; % STANDARD
% GOOD_Fiber_Th.LengthMin =200;
GOOD_Fiber_Th.LengthMax =10000;
GOOD_Fiber_Th.Ecc       =0.9;

EXP.TYPE='GNB'; % RPE/HF/HF_OLD/GNB/JASPL/Rad50i/MIRIN/Mre11i
EXP.NUM =2;  % RPE:1,2,3,4,5,6   HF_OLD:1,2,3 HF:4,5,6,7,8,9  GNB:1,2  JASPL:1,2,3    Mre11i:1,2,3,4   Rad50i:1,2     MIRIN:1,2 
EXP.N_COND=4;

Plot_YN=[0,0,0]; % [1] LoadImage, [2] DetectNuclei, [3] DetectFibers
image_save_YN=1;

% % % LOAD LIST OF FILES TO ANALYZE
[foldername, filename_list, file_extension, group_list]=Load_file_list_fibers(EXP);
EXP.N_REPLICATES=numel(filename_list)/EXP.N_COND;

% for jjj=9
for jjj=1:numel(filename_list)

    % % %  LOAD IMAGE
    filename=[foldername filename_list{jjj} file_extension]
    Load_Image=Load_image(filename, Plot_YN(1));

    % % %  REMOVE REGION WITH SCALEBAR
    Active_Image=Load_Image(1:929,:,:);

    % % %  DETECT NUCLEI
    Nuclei_binarization_type='ADAPTIVE'; % GLOBAL
    [N_cells(jjj), Nuclei_Area_Total(jjj), nuclei_bin]=Detect_nuclei(Active_Image, 3, Nuclei_binarization_type, Plot_YN(2));

    % % %  DETECT FIBERS
    [N_fibers(jjj), Fibers_area(jjj), Fibers_length(jjj), Polarization(jjj), F_N_overlap(jjj), Fibers_image]...
                            =Detect_fibers(Active_Image, 2, GOOD_Fiber_Th, nuclei_bin, Plot_YN(3));

    if image_save_YN
        imwrite(Fibers_image, ['Images\'   EXP.TYPE '_' num2str(EXP.NUM) '_' filename_list{jjj} '.png']);
    end
 
    % % %  COMPUTE TOTAL INTENSITY
    [Total_Intensity(jjj), Perc_sat_pixel(jjj)]=Compute_total_intensity(Active_Image, 2);
  
    % % % COMPUTE PROPERTIES
%     Area_fibers_cell(jjj)=Fibers_area(jjj)/Nuclei_Area_Total(jjj);
    Area_fibers_cells(jjj)=Fibers_area(jjj)/N_cells(jjj); % STANDARD TO USEEEEEEEEEEEEE

    if  sum(Plot_YN)>=1
        pause()
        close all
    end

end


% % % % CONVERSION TO um2
pix2um=0.267; % [um]
area_pix=pix2um^2; % [um2]
Area_fibers_cells_um=Area_fibers_cells*area_pix;



figure()
bar(filename_list,Area_fibers_cells)
% set(gca,'xticklabel',filename_list)
xtickangle(90)
ylabel('^{Total fibers area}/_{Nuclei number}')
fontsize(gca, FNT_SZ, "points")


for n_pop=1:numel(group_list)
    avg_Area_fibers_cells(n_pop) =mean(Area_fibers_cells( (n_pop-1)*EXP.N_REPLICATES+1:(n_pop-1)*EXP.N_REPLICATES+EXP.N_REPLICATES ));
    std_Area_fibers_cells(n_pop) =std(Area_fibers_cells( (n_pop-1)*EXP.N_REPLICATES+1:(n_pop-1)*EXP.N_REPLICATES+EXP.N_REPLICATES ));
end


figure()
bar(group_list,avg_Area_fibers_cells)
% set(gca,'xticklabel',group_list)
ylabel('^{Total fibers area}/_{Nuclei number}')
% set(gca,'xticklabel',group_list)
fontsize(gca, FNT_SZ, "points")
hold on
er = errorbar(1:numel(group_list),avg_Area_fibers_cells,std_Area_fibers_cells,std_Area_fibers_cells,'LineWidth',1);
er.Color = [0 0 0];
er.LineStyle = 'none';
% ylim([0, 4000])

save(['Partial_results\' EXP.TYPE '_' num2str(EXP.NUM) '.mat'], 'Area_fibers_cells', 'Area_fibers_cells_um')

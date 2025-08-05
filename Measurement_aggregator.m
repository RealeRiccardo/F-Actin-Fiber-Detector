clear
close all
clc
FNT_SZ=14;
addpath('Toolbox\')


EXP.TYPE='JASPL'; % RPE/HF/JASPL
EXP.NUM_LIST =1:3  % RPE:1,2,3,4,5,6   HF:5,6,7    JASPL:1,2,3

EXP.NUM=1;
[~, ~, ~, group_list]=Load_file_list_fibers(EXP);


DISCARD=zeros(4,EXP.NUM_LIST(end)*5);
% DISCARD(1,9)=true;
% DISCARD(1,18)=true;
% DISCARD(3,11)=true;
% DISCARD(3,12)=true;
% DISCARD(3,13)=true; % REPETITION WITH #4
% DISCARD(4,18)=true;


for jjj=EXP.NUM_LIST
    
    load(['Partial_results\' EXP.TYPE '_' num2str(jjj) '.mat'], 'Area_fibers_cells', 'Area_fibers_cells_um');

    % Area_all(1,(jjj-1)*3+1:(jjj-1)*3+3)= Area_fibers_cells(1:3);
    % Area_all(2,(jjj-1)*3+1:(jjj-1)*3+3)= Area_fibers_cells(4:6);
    % Area_all(3,(jjj-1)*3+1:(jjj-1)*3+3)= Area_fibers_cells(7:9);
    % Area_all(4,(jjj-1)*3+1:(jjj-1)*3+3)= Area_fibers_cells(10:12);

    % Area_all(1,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells(1:5);
    % Area_all(2,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells(6:10);
    % Area_all(3,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells(11:15);
    % Area_all(4,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells(16:20);
    Area_all(1,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells_um(1:5);
    Area_all(2,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells_um(6:10);
    Area_all(3,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells_um(11:15);
    Area_all(4,(jjj-1)*5+1:(jjj-1)*5+5)= Area_fibers_cells_um(16:20);

    % load(['Partial_results\' EXP.TYPE '_' num2str(EXP.NUM) '_TOTint.mat'], 'Total_Intensity_cell', 'Perc_sat_pixel')
    % 
    % Total_Intensity_cell_all(1,(jjj-1)*3+1:(jjj-1)*3+3)= Total_Intensity_cell(1:3);
    % Total_Intensity_cell_all(2,(jjj-1)*3+1:(jjj-1)*3+3)= Total_Intensity_cell(4:6);
    % Total_Intensity_cell_all(3,(jjj-1)*3+1:(jjj-1)*3+3)= Total_Intensity_cell(7:9);
    % Total_Intensity_cell_all(4,(jjj-1)*3+1:(jjj-1)*3+3)= Total_Intensity_cell(10:12);
    % 
    % Perc_sat_pixel_all(1,(jjj-1)*3+1:(jjj-1)*3+3)= Perc_sat_pixel(1:3);
    % Perc_sat_pixel_all(2,(jjj-1)*3+1:(jjj-1)*3+3)= Perc_sat_pixel(4:6);
    % Perc_sat_pixel_all(3,(jjj-1)*3+1:(jjj-1)*3+3)= Perc_sat_pixel(7:9);
    % Perc_sat_pixel_all(4,(jjj-1)*3+1:(jjj-1)*3+3)= Perc_sat_pixel(10:12);

end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % TEST SIGNIFICANCE
% % %  2-tailed t-test
[h,p5]=ttest2(Area_all(4, ~DISCARD(4,:)), Area_all(3, ~DISCARD(3,:)), 'Tail', 'both')
[h,p6]=ttest2(Area_all(4, ~DISCARD(4,:)), Area_all(2, ~DISCARD(2,:)), 'Tail', 'both')
[h,p7]=ttest2(Area_all(1, ~DISCARD(1,:)), Area_all(2, ~DISCARD(2,:)), 'Tail', 'both')
[h,p8]=ttest2(Area_all(1, ~DISCARD(1,:)), Area_all(3, ~DISCARD(3,:)), 'Tail', 'both')

for jjj=1:4
    area_mean(jjj) = mean(Area_all(jjj, ~DISCARD(jjj,:)));
    area_std(jjj)  = std(Area_all(jjj, ~DISCARD(jjj,:)));
    area_SEM(jjj)  = std(Area_all(jjj, ~DISCARD(jjj,:)))/    sqrt(size(Area_all,2)-sum(DISCARD(jjj,:)));

    % TOTint_mean(jjj) = mean(Total_Intensity_cell_all(jjj, ~DISCARD(jjj,:)));
    % TOTint_std(jjj)  = std(Total_Intensity_cell_all(jjj, ~DISCARD(jjj,:)));
    % TOTint_SEM(jjj)  = std(Total_Intensity_cell_all(jjj, ~DISCARD(jjj,:)))/    sqrt(size(Total_Intensity_cell_all,2)-sum(DISCARD(jjj,:)));
    % 
    % Perc_sat_pixel_mean(jjj) = mean(Perc_sat_pixel_all(jjj, ~DISCARD(jjj,:)));
    % Perc_sat_pixel_std(jjj)  = std(Perc_sat_pixel_all(jjj, ~DISCARD(jjj,:)));

end


figure()
bar(area_mean)
set(gca,'xticklabel',group_list)
fontsize(gca, FNT_SZ, "points")
hold on
er = errorbar(1:numel(group_list),area_mean,area_std,area_std,'LineWidth',1);
er.Color = [0 0 0];
er.LineStyle = 'none';
legend(er,'STD')
ylabel('Mean cell fiber area [{\mum^2}]')
  

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % FIGURES
pix2um=0.267; % [um]
area_pix=pix2um^2; % [um2]

figure()
bar(area_mean*area_pix)
set(gca,'xticklabel',group_list)
fontsize(gca, FNT_SZ, "points")
hold on
er = errorbar(1:numel(group_list),area_mean*area_pix,area_std*area_pix,area_std*area_pix,'LineWidth',1);
er.Color = [0 0 0];
er.LineStyle = 'none';
legend(er,'STD')
ylabel('Mean cell fiber area [{\mum^2}]')
  
figure()
bar(area_mean*area_pix)
ylabel('^{Total fibers area}/_{Nuclei number}')
set(gca,'xticklabel',group_list)
fontsize(gca, FNT_SZ, "points")
hold on
er = errorbar(1:numel(group_list),area_mean*area_pix,area_SEM*area_pix,area_SEM*area_pix,'LineWidth',1);
er.Color = [0 0 0];
er.LineStyle = 'none';
legend(er,'SEM')
ylabel('Mean cell fiber area [{\mum^2}]')





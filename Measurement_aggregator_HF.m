clear
close all
clc
FNT_SZ=14;
addpath('Toolbox\')

pix2um=0.267; % [um]
area_pix=pix2um^2; % [um2]


EXP.TYPE='GNB'; % RPE/GNB/HF/ Rad50i/MIRIN/Mre11i
EXP.NUM_LIST =1:2;  % RPE:1,2,3,4,5,6  HF:5,6,7  Rad50i:1,2  MIRIN:1,2   Mre11i:1,2,3,4
EXP.N_REPLICATES=[6, 6, 6, 6, 8, 8, 6, 6, 6];
EXP.NUM=1;
[~, ~, ~, group_list]=Load_file_list_fibers(EXP);
EXP.N_COND=numel(group_list);

EXPcont=0;

% for jjj=EXP.NUM_LIST
% 
%     EXPcont=EXPcont+1;
% 
%     load(['Partial_results\' EXP.TYPE '_' num2str(jjj) '.mat'], 'Area_fibers_cells');
% 
%     Area_all(1,(EXPcont-1)*EXP.N_REPLICATES(jjj)+1:(EXPcont-1)*EXP.N_REPLICATES(jjj)+EXP.N_REPLICATES(jjj))= Area_fibers_cells(1:EXP.N_REPLICATES(jjj));
%     Area_all(2,(EXPcont-1)*EXP.N_REPLICATES(jjj)+1:(EXPcont-1)*EXP.N_REPLICATES(jjj)+EXP.N_REPLICATES(jjj))= Area_fibers_cells(EXP.N_REPLICATES(jjj)+1:EXP.N_REPLICATES(jjj)*2);
% 
% end

Area_all_1=[];
Area_all_2=[];

for jjj=EXP.NUM_LIST
   
    EXPcont=EXPcont+1;

    load(['Partial_results\' EXP.TYPE '_' num2str(jjj) '.mat'], 'Area_fibers_cells');

    Area_all_1= [Area_all_1 , Area_fibers_cells(1:EXP.N_REPLICATES(jjj))];
    Area_all_2= [Area_all_2 , Area_fibers_cells(EXP.N_REPLICATES(jjj)+1:EXP.N_REPLICATES(jjj)*2)];

end
Area_all=[Area_all_1; Area_all_2];
Area_all_um=Area_all*area_pix;

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % TEST SIGNIFICANCE
% % %  2-tailed t-test
[h,p5]=ttest2(Area_all(2, :), Area_all(1, :), 'Tail', 'both')


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % AVERAGES AND STDS
for kkk=1:EXP.N_COND
    area_mean(kkk) = mean(Area_all(kkk, :));
    area_std(kkk)  = std( Area_all(kkk, :));
    area_SEM(kkk)  = std( Area_all(kkk, :))/    sqrt(size(Area_all,2));
    % 
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % FIGURES
pix2um=0.267; % [um]
area_pix=pix2um^2; % [um2]

area_mean_flipped=fliplr(area_mean);
area_std_flipped=fliplr(area_std);

figure()
bar(area_mean_flipped*area_pix, 'FaceColor',[0, 0.9, 0.3])
set(gca,'xticklabel',fliplr(group_list))
fontsize(gca, FNT_SZ, "points")
hold on
er = errorbar(1:numel(group_list),area_mean_flipped*area_pix,area_std_flipped*area_pix,area_std_flipped*area_pix,'LineWidth',1);
er.Color = [0 0 0];
er.LineStyle = 'none';
% legend(er,'STD')
% ylim([0, 20000])
ylabel('Mean cell fiber area [{\mum^2}]')
  
% figure()
% bar(area_mean*area_pix)
% ylabel('^{Total fibers area}/_{Nuclei number}')
% set(gca,'xticklabel',group_list)
% fontsize(gca, FNT_SZ, "points")
% hold on
% er = errorbar(1:numel(group_list),area_mean*area_pix,area_SEM*area_pix,area_SEM*area_pix,'LineWidth',1);
% er.Color = [0 0 0];
% er.LineStyle = 'none';
% % ylim([0, 20000])
% legend(er,'SEM')
% ylabel('Mean cell fiber area [{\mum^2}]')




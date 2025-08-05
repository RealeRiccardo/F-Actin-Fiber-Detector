clear
close all
clc
FNT_SZ=14;

addpath('Toolbox\')

EXP.TYPE='HF'; % RPE/HF
EXP.NUM =5;  % RPE:1,2,3,4,5,6   HF:4,5,,6  

% % % LOAD LIST OF FILES TO ANALYZE
[foldername, filename_list, file_extension, group_list]=Load_file_list_fibers(EXP);

for jjj=1:numel(filename_list)

    % % %  LOAD IMAGE
    filename=[foldername filename_list{jjj} file_extension]
    Load_Image=Load_image(filename, 0);

    % % %  REMOVE REGION WITH SCALEBAR
    Active_Image=Load_Image(1:929,:,2);

    
    save(['Partial_results\' EXP.TYPE '_' num2str(EXP.NUM) '_' num2str(jjj) '.mat'], 'Cells_mask')

end


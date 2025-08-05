function [foldername, filename_list, file_extension, group_list]=Load_file_list_cilia(EXP)

file_extension='.tif';
foldername=['..\DATA\' EXP.TYPE];

for iii=1:10 
    filename_list{iii}=['DMSO_' num2str(iii,'%03d')] ;
end
for iii=11:20 
    filename_list{iii}=['Mirin_' num2str(iii-10,'%03d')] ;
end

group_list{1}='DMSO';
group_list{2}='Mirin';

end
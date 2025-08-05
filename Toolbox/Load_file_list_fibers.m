function [foldername, filename_list, file_extension, group_list]=Load_file_list_fibers(EXP)

file_extension='.tif';

foldername=['..\DATA\' EXP.TYPE '_' num2str(EXP.NUM) '\'];

switch EXP.TYPE
    case '4PAPER'
        if EXP.NUM==1
            filename_list{1}='NBNI_CD';
            filename_list{2}='NBNI_DMSO';
            filename_list{3}='NOTI_CD';
            filename_list{4}='NOTI_DMSO';

            group_list{1}='Nbni CD';
            group_list{2}='Nbni DMSO';
            group_list{3}='Noti CD';
            group_list{4}='Noti DMSO';
        else
            filename_list{1}='NBNI_JASP';
            filename_list{2}='NBNI_DMSO';
            filename_list{3}='NOTI_JASP';
            filename_list{4}='NOTI_DMSO';

            group_list{1}='Nbni JASP';
            group_list{2}='Nbni DMSO';
            group_list{3}='Noti JASP';
            group_list{4}='Noti DMSO';
        end
    case 'GNB'
        filename_list{1}='CD_1';
        filename_list{2}='CD_2';
        filename_list{3}='CD_3';
        filename_list{4}='CD_4';
        filename_list{5}='CD_5';
        filename_list{6}='CD_6';
        filename_list{7}='DMSO_1';
        filename_list{8}='DMSO_2';
        filename_list{9}='DMSO_3';
        filename_list{10}='DMSO_4';
        filename_list{11}='DMSO_5';
        filename_list{12}='DMSO_6';

        group_list{1}='CD';
        group_list{2}='DMSO';

    case 'GNB_MOUSE'
        filename_list{1}='WT_1';
        filename_list{2}='WT_2';
        filename_list{3}='WT_3';
        filename_list{4}='WT_4';
        filename_list{5}='WT_5';

        group_list{1}='WT';

    case 'MIRIN'
        filename_list{1}='MIRIN_1';
        filename_list{2}='MIRIN_2';
        filename_list{3}='MIRIN_3';
        filename_list{4}='MIRIN_4';
        filename_list{5}='MIRIN_5';
        filename_list{6}='MIRIN_6';
        filename_list{7}='DMSO_1';
        filename_list{8}='DMSO_2';
        filename_list{9}='DMSO_3';
        filename_list{10}='DMSO_4';
        filename_list{11}='DMSO_5';
        filename_list{12}='DMSO_6';

        group_list{1}='MIRIN';
        group_list{2}='DMSO';

    case 'Mre11i'
        filename_list{1}='Mre11i_1';
        filename_list{2}='Mre11i_2';
        filename_list{3}='Mre11i_3';
        filename_list{4}='Mre11i_4';
        filename_list{5}='Mre11i_5';
        filename_list{6}='Mre11i_6';
        filename_list{7}='Noti_1';
        filename_list{8}='Noti_2';
        filename_list{9}='Noti_3';
        filename_list{10}='Noti_4';
        filename_list{11}='Noti_5';
        filename_list{12}='Noti_6';

        group_list{1}='Mre11i';
        group_list{2}='Noti';

    case 'Rad50i'
        filename_list{1}='Rad50i_1';
        filename_list{2}='Rad50i_2';
        filename_list{3}='Rad50i_3';
        filename_list{4}='Rad50i_4';
        filename_list{5}='Rad50i_5';
        filename_list{6}='Rad50i_6';
        filename_list{7}='Noti_1';
        filename_list{8}='Noti_2';
        filename_list{9}='Noti_3';
        filename_list{10}='Noti_4';
        filename_list{11}='Noti_5';
        filename_list{12}='Noti_6';

        group_list{1}='Rad50i';
        group_list{2}='Noti';

    case 'RPE'
        filename_list{1}='Nbni_CD_1';
        filename_list{2}='Nbni_CD_2';
        filename_list{3}='Nbni_CD_3';
        filename_list{4}='Nbni_DMSO_1';
        filename_list{5}='Nbni_DMSO_2';
        filename_list{6}='Nbni_DMSO_3';
        filename_list{7}='Noti_CD_1';
        filename_list{8}='Noti_CD_2';
        filename_list{9}='Noti_CD_3';
        filename_list{10}='Noti_DMSO_1';
        filename_list{11}='Noti_DMSO_2';
        filename_list{12}='Noti_DMSO_3';

        group_list{1}='Nbni CD';
        group_list{2}='Nbni DMSO';
        group_list{3}='Noti CD';
        group_list{4}='Noti DMSO';

    case 'JASPL'
        filename_list{1}='Nbni_JASPL_1';
        filename_list{2}='Nbni_JASPL_2';
        filename_list{3}='Nbni_JASPL_3';
        filename_list{4}='Nbni_JASPL_4';
        filename_list{5}='Nbni_JASPL_5';
        filename_list{6}='Nbni_DMSO_1';
        filename_list{7}='Nbni_DMSO_2';
        filename_list{8}='Nbni_DMSO_3';
        filename_list{9}='Nbni_DMSO_4';
        filename_list{10}='Nbni_DMSO_5';
        filename_list{11}='Noti_JASPL_1';
        filename_list{12}='Noti_JASPL_2';
        filename_list{13}='Noti_JASPL_3';
        filename_list{14}='Noti_JASPL_4';
        filename_list{15}='Noti_JASPL_5';
        filename_list{16}='Noti_DMSO_1';
        filename_list{17}='Noti_DMSO_2';
        filename_list{18}='Noti_DMSO_3';
        filename_list{19}='Noti_DMSO_4';
        filename_list{20}='Noti_DMSO_5';

        group_list{1}='Nbni JASPL';
        group_list{2}='Nbni DMSO';
        group_list{3}='Noti JASPL';
        group_list{4}='Noti DMSO';

    case 'HF'
        if EXP.NUM==4 || EXP.NUM==5 || EXP.NUM==6
            filename_list{1}='WT_1';
            filename_list{2}='WT_2';
            filename_list{3}='WT_3';
            filename_list{4}='WT_4';
            filename_list{5}='WT_5';
            filename_list{6}='WT_6';
            filename_list{7}='WT_7';
            filename_list{8}='WT_8';
            filename_list{9}='NBS_1';
            filename_list{10}='NBS_2';
            filename_list{11}='NBS_3';
            filename_list{12}='NBS_4';
            filename_list{13}='NBS_5';
            filename_list{14}='NBS_6';
            filename_list{15}='NBS_7';
            filename_list{16}='NBS_8';
        else
            filename_list{1}='WT_1';
            filename_list{2}='WT_2';
            filename_list{3}='WT_3';
            filename_list{4}='WT_4';
            filename_list{5}='WT_5';
            filename_list{6}='WT_6';
            filename_list{7}='NBS_1';
            filename_list{8}='NBS_2';
            filename_list{9}='NBS_3';
            filename_list{10}='NBS_4';
            filename_list{11}='NBS_5';
            filename_list{12}='NBS_6';
        end

        group_list{1}='WT';
        group_list{2}='NBS';

    case 'HF_OLD'
        filename_list{1}='WT_1';
        filename_list{2}='WT_2';
        filename_list{3}='WT_3';
        filename_list{4}='NBS_1';
        filename_list{5}='NBS_2';
        filename_list{6}='NBS_3';
        group_list{1}='WT';
        group_list{2}='NBS';

    case 'CB'
        if EXP.NUM==1
            filename_list{1}='KO_001';
            filename_list{2}='KO_002';
            filename_list{3}='KO_003';
            filename_list{4}='KO_004';
            filename_list{5}='KO_005';
            filename_list{6}='KO_006';
            filename_list{7}='WT_001';
            filename_list{8}='WT_002';
            filename_list{9}='WT_003';
            filename_list{10}='WT_004';
            filename_list{11}='WT_005';
            filename_list{12}='WT_006';
            filename_list{13}='WT_007';
        elseif EXP.NUM==2
            filename_list{1}='KO_001';
            filename_list{2}='KO_002';
            filename_list{3}='KO_003';
            filename_list{4}='KO_004';
            filename_list{5}='KO_005';
            filename_list{6}='KO_006';
            filename_list{7}='WT_001';
            filename_list{8}='WT_002';
            filename_list{9}='WT_003';
            filename_list{10}='WT_004';
            filename_list{11}='WT_005';
            filename_list{12}='WT_006';
        elseif EXP.NUM==3
            filename_list{1}='KO_001';
            filename_list{2}='KO_002';
            filename_list{3}='KO_003';
            filename_list{4}='KO_004';
            filename_list{5}='KO_005';
            filename_list{6}='WT_001';
            filename_list{7}='WT_002';
            filename_list{8}='WT_003';
            filename_list{9}='WT_004';
            filename_list{10}='WT_005';
        end

        group_list{1}='KO';
        group_list{2}='WT';
end


end
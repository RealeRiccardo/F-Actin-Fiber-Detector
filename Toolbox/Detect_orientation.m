function [Conv_score]=Detect_orientation(Fibers_image)


Conv_mask_half_window=5;
Orientations_step=5;
Orientations_mask_list=0:Orientations_step:180;
Conv_mask_base=false(201,201);
Conv_mask_base(:,99:101)=true;

for kkk=1:numel(Orientations_mask_list)

    Orientations_mask=Orientations_mask_list(kkk);

    Conv_mask_rot = imrotate(Conv_mask_base, Orientations_mask);

    Conv_mask=Conv_mask_rot(round(size(Conv_mask_rot,1)/2)-Conv_mask_half_window:round(size(Conv_mask_rot,1)/2)+Conv_mask_half_window,...
                            round(size(Conv_mask_rot,2)/2)-Conv_mask_half_window:round(size(Conv_mask_rot,2)/2)+Conv_mask_half_window);

    Convolved=conv2(Fibers_image,Conv_mask);

    Conv_score(kkk)=sum(Convolved/sum(Conv_mask,'all')>0.8,'all');

%     figure(555)
%     subplot(1,2,1)
%     imshow(Fibers_image)
%     subplot(1,2,2)
%     imagesc(Convolved/sum(Conv_mask,'all')>0.8)
%     colorbar
% %     pause()
%     pause(0.1)

end

% [~,max_ind]=max(Conv_score);
% % mean_ind=ceil(mean(Conv_score/max(Conv_score,[],"all").*Orientations_mask_list));
% 
% ind_dif=max_ind-90/Orientations_step;
% for kkk=1:numel(Conv_score)
%         new_ind=kkk-ind_dif;
%         if new_ind<1
%             new_ind=numel(Conv_score)+new_ind;
%         end       
%         Conv_score_shifted(new_ind)=Conv_score(kkk);
% end
% 
% fit_results = fit(Orientations_mask_list',Conv_score_shifted','gauss1');
% 
% % Polarization=std(Conv_score)/sum(Fibers_image,'all');
% Polarization=fit_results.c1;


figure()
plot(Orientations_mask_list,Conv_score);
% pause()
drawnow

end

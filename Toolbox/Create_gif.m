function Create_gif(foldername, filename_save, Image_stack )

for iii = 1 : size(Image_stack,3)
    temp_im(:,:,1)=Image_stack(:,:,iii);
    temp_im(:,:,2)=temp_im(:,:,1);
    temp_im(:,:,3)=temp_im(:,:,1);
    [A,map] = rgb2ind(temp_im,256);
    if iii == 1
        imwrite(A,map,[foldername filename_save '.gif'],"gif","LoopCount",Inf,     "DelayTime",0.3);
    else
        imwrite(A,map,[foldername filename_save '.gif'],"gif","WriteMode","append","DelayTime",0.3);
    end
end

end
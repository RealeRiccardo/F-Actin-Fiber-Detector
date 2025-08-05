function  [Total_Intensity, Perc_sat_pixel]=Compute_total_intensity(Active_Image, CH)

Im_G=Active_Image(:,:,CH);

Total_Intensity=sum(sum(Im_G));

Perc_sat_pixel=sum(sum(Im_G==255))/numel(Im_G)*100;

end

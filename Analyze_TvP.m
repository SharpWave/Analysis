function [ output_args ] = Analyze_TvP(matfile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load(matfile);

% load motion-ADJUSTED FT and ICFT - replicate the truncation procedures in
% CalculatePlacefields
[~,~,~,FT,~,~,~,fStart] = AlignImagingToTracking(0.1,FT);
[~,~,~,ICFT,~,~,~,fStart] = AlignImagingToTracking(0.1,ICFT);




for i = 1:length(ICimage)
    ICpixels{i} = find(ICimage{i});
end

for i = 1:length(NeuronImage)
    cidx = ClosestT(i);
    FractionOverlap(i) = length(intersect(NeuronPixels{i},ICpixels{cidx}))./length(NeuronPixels{i});
end

for i = 1:length(NeuronImage)
    cidx = ClosestT(i);
    
    tEpochs = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    Num_T_Transients(i) = size(tEpochs,1);
    
    iEpochs = NP_FindSupraThresholdEpochs(ICFT(i,:),eps);
    Num_ClosestI_Transients(i) = size(iEpochs,1);
    
    Num_Matching_Transients(i) = 0;
    for j = 1:Num_T_Transients(i)
      if (sum(ICFT(cidx,tEpochs(j,1):tEpochs(j,2))) > 0)
         Num_Matching_Transients(i) = Num_Matching_Transients(i) + 1;
      end
    end
        
    Fraction_T_Matched(i) = Num_Matching_Transients(i)./Num_T_Transients(i);
    Fraction_ClosestI_Matched(i) = Num_Matching_Transients(i)./Num_ClosestI_Transients(i);
end

keyboard;

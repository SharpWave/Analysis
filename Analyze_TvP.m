function [ output_args ] = Analyze_TvP(matfile)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load(matfile);

% load motion-ADJUSTED FT and ICFT - replicate the truncation procedures in
% CalculatePlacefields
%[~,~,~,FT,~,~,~,fStart] = AlignImagingToTracking(0.1,FT);
%[~,~,~,ICFT,~,~,~,fStart] = AlignImagingToTracking(0.1,ICFT);

GoodFT = find(sum(FT') > 0);
GoodICFT = find(sum(ICFT') > 0);


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
    
    iEpochs = NP_FindSupraThresholdEpochs(ICFT(cidx,:),eps);
    Num_I_Transients(i) = size(iEpochs,1);

    Num_Matching_Transients(i) = 0;
    for j = 1:Num_T_Transients(i)
      if (sum(ICFT(cidx,tEpochs(j,1):tEpochs(j,2))) > 0)
         Num_Matching_Transients(i) = Num_Matching_Transients(i) + 1;
      end
    end
        
    Fraction_T_Matched(i) = Num_Matching_Transients(i)./Num_T_Transients(i);
    T_Score(i) = Num_Matching_Transients(i)./min(Num_T_Transients(i),Num_I_Transients(i));
end

% now, divide Tenaspis neurons into 3ish groups:
% 1: Has closely matching IC shared with no other ROI
% 2: Has a closely matching IC that is shared with another neuron
% 3: Has a poorly matching IC
% 4: Has no matching IC

CloseDist = 4; % Minimum centroid distance to be considered a close match
MinOverlap = 0.8; % Minimum fraction of ROI pixels in common with IC to be considered a close match

for i = 1:length(NeuronImage)
   cidx = ClosestT(i);
   
   matches = find(ClosestT == cidx);
   UniqueIC(i) = 1;
   % check if closest is unique
   if (length(matches) > 1)
       % check if any of the shared are close
       for j = 1:length(matches)
           if ((matches(j) ~= i)  && (mindist(matches(j)) < CloseDist))
             UniqueIC(i) = 0;
           end
       end
   end
   
   if (FractionOverlap(i) == 0)
       NoMatch(i) = 1;
   else
       NoMatch(i) = 0;
   end
   
   % Check for a good match
   if (mindist(i) < CloseDist) && (FractionOverlap(i) > MinOverlap)
       CloseMatch(i) = 1;
   else
       CloseMatch(i) = 0;
   end
   
   if (CloseMatch(i) && UniqueIC(i))
       ROIgroup(i) = 1;
       continue;
   end
   
   if (CloseMatch(i) && ~UniqueIC(i))
       ROIgroup(i) = 2;
       continue;
   end
   
   if (~NoMatch(i))
       ROIgroup(i) = 3;
       continue;
   end
   
   ROIgroup(i) = 4;
end
       
   
   

save TvP_analysis.mat;



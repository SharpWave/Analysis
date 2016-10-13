function [] = TenaspisVsPCAICA()

load FinalOutput.mat;
load ICoutput.mat;
load MeanT.mat;
load MeanI.mat;

PM_ten = load('PlaceMaps.mat');
PFS_ten = load('PFstats.mat');
PM_IC = load('PlaceMapsIC.mat');
PFS_IC = load('PFstatsIC.mat');

for i = 1:length(NeuronImage)
    Tprops{i} = regionprops(NeuronImage{i});
    Tcent(i,1:2) = Tprops{i}.Centroid;
    Tarea(i) = Tprops{i}.Area;
end

for i = 1:length(ICprops)
    Icent(i,1:2) = ICprops{i}.Centroid;
    Iarea(i) = ICprops{i}.Area
end

% compute all pairwise distances between neuron centroids
CluDist = pdist([Tcent;Icent],'euclidean');
CluDist = squareform(CluDist);

for i = 1:length(NeuronImage)
    for j = 1:length(ICprops)
        Cdist(i,j) = CluDist(i,j+length(NeuronImage));
    end
end
NumFrames = size(FT,2);


for i = 1:length(NeuronImage)
    [mindist(i),ClosestT(i)] = min(Cdist(i,:));
    MeanDiff{i} = MeanT{i}-MeanI{ClosestT(i)};
    outT{i} = bwboundaries(NeuronImage{i});
    outI{i} = bwboundaries(ICimage{ClosestT(i)});
    
    T_MutInf(i) = PM_ten.SpatialI(i);
    IC_MutInf(i) = PM_IC.SpatialI(ClosestT(i));
    
    T_pval(i) = PM_ten.pval(i);
    IC_pval(i) = PM_IC.pval(ClosestT(i));
    
    if (~isempty(PFS_ten.PFcentroid{i,PFS_ten.MaxPF(i)}))
        PFTcent(i,:) = PFS_ten.PFcentroid{i,PFS_ten.MaxPF(i)};
    else
        PFTcent(i,:) = [NaN,NaN];
    end
    
    if (~isempty(PFS_IC.PFcentroid{ClosestT(i),PFS_IC.MaxPF(ClosestT(i))}))
        PFICcent(i,:) = PFS_IC.PFcentroid{ClosestT(i),PFS_IC.MaxPF(ClosestT(i))};
    else
        PFICcent(i,:) = [NaN,NaN];
    end
    
    if (~isempty(PFS_ten.PFcentroid{i,PFS_ten.MaxPF(i)}))
        PFTarea(i) = length(PFS_ten.PFpixels{i,PFS_ten.MaxPF(i)});
    else
        PFTarea(i) = NaN;
    end
    
    if (~isempty(PFS_IC.PFcentroid{ClosestT(i),PFS_IC.MaxPF(ClosestT(i))}))
        PFICarea(i) = length(PFS_IC.PFpixels{ClosestT(i),PFS_IC.MaxPF(ClosestT(i))});
    else
        PFICarea(i) = NaN;
    end
    
end


PFDist = pdist([PFTcent;PFICcent],'euclidean');
PFDist = squareform(PFDist);

for i = 1:length(NeuronImage)
    
    min_PFdist(i) = PFDist(i,length(NeuronImage)+i);

end

GoodFT = find(sum(FT') > 0);
GoodICFT = find(sum(ICFT') > 0);


for i = 1:length(ICimage)
    ICpixels{i} = find(ICimage{i});
end

for i = 1:length(NeuronImage)
    cidx = ClosestT(i);
    FractionOverlap(i) = length(intersect(NeuronPixels{i},ICpixels{cidx}))./min(length(NeuronPixels{i}),length(ICpixels{cidx}));
end

for i = 1:length(NeuronImage)
    cidx = ClosestT(i);
    
    tEpochs = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    Num_T_Transients(i) = size(tEpochs,1);
    T_TranDur{i} = tEpochs(:,2)-tEpochs(:,1)+1;
    
    iEpochs = NP_FindSupraThresholdEpochs(ICFT(cidx,:),eps);
    Num_Closest_I_Transients(i) = size(iEpochs,1);
    
    
    temp = zeros(1,size(ICFT,2));
    for j = 1:Num_Closest_I_Transients(i)
        temp(iEpochs(j,1):iEpochs(j,2)) = 1;
    end
    
    Num_Matching_Transients(i) = 0;
    for j = 1:Num_T_Transients(i)
        if (sum(temp(tEpochs(j,1):tEpochs(j,2))) > 0)
            Num_Matching_Transients(i) = Num_Matching_Transients(i) + 1;
        end
    end
    
    Fraction_T_Matched(i) = Num_Matching_Transients(i)./Num_T_Transients(i);
    T_Score(i) = Num_Matching_Transients(i)./min(Num_T_Transients(i),Num_Closest_I_Transients(i));
    
    T_PFPixels = PFS_ten.PFpixels{i,PFS_ten.MaxPF(i)};
    I_PFPixels = PFS_IC.PFpixels{cidx,PFS_IC.MaxPF(cidx)};
    if (~isempty(T_PFPixels))
        PFoverlap(i) = length(intersect(T_PFPixels,I_PFPixels))/length(T_PFPixels);
    else
        PFoverlap(i) = 0;
    end
    
end

for i = 1:length(ICimage)
    iEpochs = NP_FindSupraThresholdEpochs(ICFT(i,:),eps);
    Num_I_Transients(i) = size(iEpochs,1);
    I_TranDur{i} = iEpochs(:,2)-iEpochs(:,1)+1;
end

% now, divide Tenaspis neurons into 3ish groups:
% 1: Has closely matching IC shared with no other ROI
% 2: Has a closely matching IC that is shared with another neuron
% 3: Has no matching IC

CloseDist = 6; % Minimum centroid distance to be considered a close match
MinOverlap = 0.67; % Minimum fraction of ROI pixels in common with IC to be considered a close match

for i = 1:length(NeuronImage)
    
    if (FractionOverlap(i) > MinOverlap)
        PixelMatch(i) = 1;
    else
        PixelMatch(i) = 0;
    end
    
    if (mindist(i) < CloseDist)
        CenterMatch(i) = 1;
    else
        CenterMatch(i) = 0;
    end
end

for i = 1:length(NeuronImage)
    
    cidx = ClosestT(i);
    
    matches = find(ClosestT == cidx);
    UniqueMatch(i) = 1;
    % check if closest is unique
    if (length(matches) > 1)
        % check if any of the shared are close
        for j = 1:length(matches)
            if ((matches(j) ~= i)  && CenterMatch(matches(j)) && PixelMatch(matches(j)) )
                UniqueMatch(i) = 0;
            end
        end
    end
    
    % Check for a good match
    if (CenterMatch(i) && PixelMatch(i) && UniqueMatch(i))
        % Good, unique match
        ROIgroup(i) = 1;
        continue;
    end
    
    if (CenterMatch(i) && PixelMatch(i) && ~UniqueMatch(i))
        % Good match, not unique
        ROIgroup(i) = 2;
        continue;
    end
    % otherwise
    ROIgroup(i) = 3;
end

% Determine whether ICs were matched at all by Tenaspis
for i = 1:length(ICimage)
  if(ismember(i,ClosestT))
      MatchedIC(i) = 1;
  else
      MatchedIC(i) = 0;
  end
end



T_TransientsPerMinute = Num_T_Transients./size(FT,2)*20*60;
Closest_I_TransientsPerMinute = Num_Closest_I_Transients./size(FT,2)*20*60;
I_TransientsPerMinute = Num_I_Transients./size(FT,2)*20*60;

save TvP_analysis.mat;

end

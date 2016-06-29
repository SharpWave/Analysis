function [] = TenaspisVsPCAICA(moviefile)

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
end

for i = 1:length(ICprops)
    Icent(i,1:2) = ICprops{i}.Centroid;
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
    
end


PFDist = pdist([PFTcent;PFICcent],'euclidean');
PFDist = squareform(PFDist);

for i = 1:length(NeuronImage)
    
    min_PFdist(i) = PFDist(i,length(NeuronImage)+i);

end

save TvP.mat;

end

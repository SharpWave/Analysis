function [] = TenaspisVsPCAICA(moviefile)

load FinalOutput.mat;
load ICoutput.mat;

indata{1} = FT;
indata{2} = ICFT;

outdata = MakeTrigAvg(indata);
MeanT = outdata{1};
MeanI = outdata{2};

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
end

for i = 1:length(NeuronImage)
    outT{i} = bwboundaries(NeuronImage{i});
    outI{i} = bwboundaries(ICimage{ClosestT(i)});
end

save TvP.mat;

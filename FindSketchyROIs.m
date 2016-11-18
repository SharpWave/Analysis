function [sketchydudes,overs] = FindSketchyROIs()

load('FinalOutput.mat','NeuronPixelIdxList','NumNeurons','PSAbool');
NumFrames = Get_T_Params('NumFrames');

ROIoverlap = false(NumNeurons,NumNeurons);
ROIpct = zeros(NumNeurons,NumNeurons);
SimThresh = 0.95;
OverThresh = 0.5;

disp('calculating ROI activity similarity');
BinSim = zeros(NumNeurons,NumNeurons,'single');
p = ProgressBar(NumNeurons);
for i = 1:NumNeurons
    for j = 1:NumNeurons
        exhits = round(sum(PSAbool(i,:))*sum(PSAbool(j,:))/NumFrames);
        if (sum(PSAbool(i,:) & PSAbool(j,:)) > exhits)
            BinSim(i,j) = (sum(PSAbool(i,:) & PSAbool(j,:))-exhits)/(min(sum(PSAbool(i,:)),sum(PSAbool(j,:)))-exhits);
        else
            if (exhits > 0)
                BinSim(i,j) = (sum(PSAbool(i,:) & PSAbool(j,:))-exhits)/(exhits);
            else
                BinSim(i,j) = 0;
            end
        end
        if (i == j)
            BinSim(i,j) = 0;
        end
    end
    p.progress;
end
p.stop;

sketchydudes = [];
overs = [];

for i = 1:NumNeurons
    for j = i+1:NumNeurons
        if(~isempty(intersect(NeuronPixelIdxList{i},NeuronPixelIdxList{j})));
            ROIoverlap(i,j) = true;
            ROIoverlap(j,i) = true;
            ROIpct(i,j) = length(intersect(NeuronPixelIdxList{i},NeuronPixelIdxList{j}))/min(length(NeuronPixelIdxList{i}),length(NeuronPixelIdxList{j}));
            ROIpct(j,i) = ROIpct(i,j);
        end
    end
end

for i = 1:NumNeurons
    NeighborSim = BinSim(i,ROIoverlap(i,:));
    Neighbors = find(ROIoverlap(i,:));
    farsims = sort(BinSim(i,ROIoverlap(i,:) == 0));
    normrank = [];
    overlap = [];
    for j = 1:length(NeighborSim)
      idx = findclosest(NeighborSim(j),farsims);
      normrank(j) = idx/length(farsims);
      overlap(j) = ROIpct(i,Neighbors(j));
    end
    
    if any(normrank > SimThresh)
        sketchydudes = [sketchydudes,i];
    end
    
    if any(overlap > OverThresh)
        overs = [overs,i];
    end
end

save BinSim.mat BinSim

end


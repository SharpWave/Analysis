function [ output_args ] = PreBrowseOverlaps( input_args )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
FindSketchyROIs;
load ('FinalOutput.mat','PSAbool','NeuronPixelIdxList','NumNeurons','NeuronImage');
[MinPSALen,ROICircleWindowRadius,Xdim,Ydim] = Get_T_Params('MinPSALen','ROICircleWindowRadius','Xdim','Ydim');
PSApeaks = false(size(PSAbool));

[actlist,BinCent,CircMask] = deal(cell(1,NumNeurons));

for i = 1:NumNeurons
    actlist{i} = NP_FindSupraThresholdEpochs(PSAbool(i,:),eps);
    for j = 1:size(actlist{i},1)
        PSApeaks(i,actlist{i}(j,2)-MinPSALen+1:actlist{i}(j,2)) = true;
    end
    props = regionprops(NeuronImage{i},'Centroid');
    BinCent{i} = props.Centroid;
    CircMask{i} = MakeCircMask(Xdim,Ydim,ROICircleWindowRadius,BinCent{i}(1),BinCent{i}(2));    
end

[BigFinalPixelAvg] = PixelSetMovieAvg(PSApeaks,CircMask);
save BigFinalPixelAvg.mat BigFinalPixelAvg PSApeaks CircMask;

end


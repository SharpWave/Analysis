function [ output_args ] = PlotAllMeanT( input_args )
% let's see where all the ROIS are. fun!
load MeanT.mat;
load FinalOutput.mat;

AllN = zeros(size(NeuronImage{1}));
NumN = zeros(size(NeuronImage{1}));

for i = 1:length(NeuronImage)
  AllN(NeuronPixels{i}) = AllN(NeuronPixels{i}) + MeanT{i}(NeuronPixels{i});
  NumN(NeuronPixels{i}) = NumN(NeuronPixels{i}) + 1;
end

figure;imagesc(AllN./NumN);colormap gray;caxis([0 0.1]);
set(gcf,'Position',[414    49   888   948]);axis image;colorbar



end


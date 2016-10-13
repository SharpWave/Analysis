function [ output_args ] = BrowseT2()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
load ('ProcOut.mat','FT','NeuronImage','NeuronPixels');
oNI = NeuronImage;
oNP = NeuronPixels;

load ROIavg.mat;

load T2output.mat;
load TrigAvg;

for i = 1:1250
    a(1) = subplot(1,2,1);
    temp = NeuronImage{i};
    temp(NeuronPixels{i}) = ROIavg{ROIidx(i)};
    
    imagesc(temp),axis image;colorbar;
    b = bwboundaries(NeuronImage{i});
    
    hold on;
    plot(b{1}(:,2),b{1}(:,1),'-r');hold off;
    try caxis([0.01 max(TrigAvg{i}(NeuronPixels{i}))]);end;
    
    a(2) = subplot(1,2,2);
    imagesc(TrigAvg{i}),axis image;colorbar;
       
    hold on;
    plot(b{1}(:,2),b{1}(:,1),'-r');hold off;
    try caxis([0.01 max(TrigAvg{i}(NeuronPixels{i}))]);end;
    linkaxes(a);
    pause;
end

end


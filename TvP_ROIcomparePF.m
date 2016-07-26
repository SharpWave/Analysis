function [ output_args ] = TvP_ROIcompare(NeuronIDs)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

load MeanT.mat;
load MeanI.mat;
load('TvP_analysis.mat','outT','Tcent','Icent','ClosestT','ROIgroup');
load('FinalOutput.mat','NeuronImage','NeuronPixels');
load('ICoutput.mat','ICimage');
load PlaceMaps.mat;

HW = 20;
colors{1} = [0 0.7 0]; % good match: darkish green
colors{2} = 'b'; %conflict
colors{3} = 'r'; % badd

% Make IC outlines
for i = 1:length(MeanI)
    outI{i} = bwboundaries(ICimage{i});
     
end

UnusedIC = setdiff(1:length(ICimage),ClosestT(find(ROIgroup ~= 3)));
UsedIC = setdiff(1:length(ICimage),UnusedIC);

figure;
RunOK = RunOccMap > 0;
h = fspecial('disk',2);
RunOK = (imfilter(RunOK,h) > 0);
RunOKC(:,:,1) = RunOK;
RunOKC(:,:,2) = RunOK;
RunOKC(:,:,3) = RunOK;

for i = 1:length(NeuronIDs)
    subplot(2,length(NeuronIDs),i);
    idx = NeuronIDs(i);
    imagesc(MeanT{idx});hold on;caxis([0 max(MeanT{idx}(NeuronPixels{idx}))]);%colorbar
    for j = 1:length(MeanT)
        plot(outT{j}{1}(:,2),outT{j}{1}(:,1),'Color',colors{ROIgroup(j)},'LineWidth',1);
    end
    for j = 1:length(UsedIC)
        plot(outI{UsedIC(j)}{1}(:,2),outI{UsedIC(j)}{1}(:,1),'Color','k','LineWidth',1);
    end
    for j = 1:length(UnusedIC)
        plot(outI{UnusedIC(j)}{1}(:,2),outI{UnusedIC(j)}{1}(:,1),'Color',[0.5 0.5 0.5],'LineWidth',1);
    end
    if (ROIgroup(idx) ~= 3)
    plot(outI{ClosestT(idx)}{1}(:,2),outI{ClosestT(idx)}{1}(:,1),'Color','k','LineWidth',2.5);
    end
    plot(outT{idx}{1}(:,2),outT{idx}{1}(:,1),'Color','k','LineWidth',2.75);
    plot(outT{idx}{1}(:,2),outT{idx}{1}(:,1),'Color',colors{ROIgroup(idx)},'LineWidth',2.5);
    axis([Tcent(idx,1)-HW Tcent(idx,1)+HW Tcent(idx,2)-HW Tcent(idx,2)+HW]);
    axis off;
    title(num2str(max(MeanT{idx}(NeuronPixels{idx})),2));%colormap gray;
    subplot(2,length(NeuronIDs),i+length(NeuronIDs));
    c = imagesc(TMap_gauss{idx});axis image;hold on;%plot(Ybin(isrunning),Xbin(isrunning),'-r');
    c = image(RunOKC);
    c.AlphaData = single(~RunOK)
    title(num2str(max(TMap_gauss{idx}(:)),2));
end
set(gcf,'Position',[8   705   975   120]);   

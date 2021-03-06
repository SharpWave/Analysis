function [ output_args ] = TvP_ROIcompare(NeuronIDs)
%UNTITLED15 Summary of this function goes here
%   Detailed explanation goes here

load MeanT.mat;
load MeanI.mat;
load('TvP_analysis.mat','outT','Tcent','Icent','ClosestT','ROIgroup');
%load('FinalOutput.mat','NeuronImage','NeuronPixels');
load('ICoutput.mat','ICimage');

HW = 20;
colors{1} = [0 0.7 0]; % good match: darkish green
colors{2} = 'b'; %conflict
colors{3} = 'r'; % badd

% Make IC outlines
for i = 1:length(MeanI)
    outI{i} = bwboundaries(ICimage{i});
    ICpixels{i} = find(ICimage{i});
end

UnusedIC = setdiff(1:length(ICimage),ClosestT(find(ROIgroup ~= 3)));
UsedIC = setdiff(1:length(ICimage),UnusedIC);

figure;
for i = 1:length(NeuronIDs)
    subplot(1,length(NeuronIDs),i);
    idx = NeuronIDs(i);
    imagesc(MeanI{idx});hold on;caxis([0 max(MeanI{idx}(ICpixels{idx}))]);%colorbar
    for j = 1:length(MeanT)
        plot(outT{j}{1}(:,2),outT{j}{1}(:,1),'Color',colors{ROIgroup(j)},'LineWidth',1);
    end
    for j = 1:length(UsedIC)
        plot(outI{UsedIC(j)}{1}(:,2),outI{UsedIC(j)}{1}(:,1),'Color','k','LineWidth',1);
    end
    for j = 1:length(UnusedIC)
        plot(outI{UnusedIC(j)}{1}(:,2),outI{UnusedIC(j)}{1}(:,1),'Color',[0.5 0.5 0.5],'LineWidth',1);
    end

    %plot(outI{idx}{1}(:,2),outI{idx}{1}(:,1),'Color','k','LineWidth',2.75);
    plot(outI{idx}{1}(:,2),outI{idx}{1}(:,1),'Color',[0.5 0.5 0.5],'LineWidth',2.5);
    axis([Icent(idx,1)-HW Icent(idx,1)+HW Icent(idx,2)-HW Icent(idx,2)+HW]);
    axis off;
    title(num2str(max(MeanI{idx}(ICpixels{idx})),2));%colormap gray;
end
set(gcf,'Position',[8   705   975   120]);   

function [ output_args ] = Browse_TvP_PF(ToBrowse)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load ('TvP_analysis.mat','MeanT','MeanI','outT','outI','Tcent','Icent','ClosestT','NeuronPixels','ICpixels');

load('PlaceMapsIC.mat','SpatialI','FT','TMap_gauss','pval');

ICSpatialI = SpatialI;
ICFT = FT;
ICTMap = TMap_gauss;
ICpval = pval;

load('PlaceMaps.mat','SpatialI','FT','TMap_gauss','pval','RunOccMap');

RunOK = RunOccMap > 0;
h = fspecial('disk',3);
RunOK = (imfilter(RunOK,h) > 0);
RunOKC(:,:,1) = RunOK;
RunOKC(:,:,2) = RunOK;
RunOKC(:,:,3) = RunOK;
% transients
for i = 1:size(FT,1)
    temp = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    nCaTr(i) = size(temp,1);
end

for i = 1:size(ICFT,1)
    temp = NP_FindSupraThresholdEpochs(ICFT(i,:),eps);
    ICnCaTr(i) = size(temp,1);
end

if(~exist('ToBrowse','var'))
    ToBrowse = 1:length(MeanT)
end


for j=1:length(ToBrowse)
    i = ToBrowse(j)
    idx = ClosestT(i);
    figure(1);set(gcf,'Position',[680 59 874 919])
    
    subplot(2,2,1);imagesc(MeanT{i});axis equal;axis tight;
    hold on;
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r','LineWidth',2);
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k','LineWidth',2);
    caxis([0 max(MeanT{i}(NeuronPixels{i}))]);
    %title(['Ten #',int2str(i),' f = ',int2str(nAFT(i))],'FontSize',8);
  
   axis image;axis off;
    set(gca,'XLim',[Tcent(i,1)-20 Tcent(i,1)+20]);
    set(gca,'YLim',[Tcent(i,2)-20 Tcent(i,2)+20]);
    
    
    
    
    subplot(2,2,2);imagesc(MeanI{idx});axis equal;axis tight;%set(gca,'CLim',CLim');
    hold on;caxis([0 0.1])
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r','LineWidth',2);
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k','LineWidth',2);
    %title(['PCA #',int2str(idx),' f = ',int2str(nAFI(idx))],'FontSize',8);
    axis image;axis off;
    caxis([0 max(MeanI{idx}(ICpixels{idx}))]);
    set(gca,'XLim',[Tcent(i,1)-20 Tcent(i,1)+20]);
    set(gca,'YLim',[Tcent(i,2)-20 Tcent(i,2)+20]);
    
    subplot(2,2,3);
    c = imagesc(TMap_gauss{i});axis image;hold on;%plot(Ybin(isrunning),Xbin(isrunning),'-r');
    c = image(RunOKC);
    c.AlphaData = single(~RunOK)
    title(['I=',num2str(SpatialI(i)),' #tr=',int2str(nCaTr(i)),' p=',num2str(pval(i))]);
    axis image;axis off;
    try
    caxis([0 max(TMap_gauss{i}(:))]);
    end
    
    subplot(2,2,4);
        c = imagesc(ICTMap{idx});axis image;hold on;%plot(Ybin(isrunning),Xbin(isrunning),'-r');
    c = image(RunOKC);
    c.AlphaData = single(~RunOK)
    title(['I=',num2str(ICSpatialI(idx)),' #tr=',int2str(ICnCaTr(idx)),' p=',num2str(ICpval(idx))]);
    axis image;axis off;
    try
    caxis([0 max(ICTMap{idx}(:))]);
    end
    set(gcf,'Position',[608   450   225   364]);
    pause;
end

keyboard;

end


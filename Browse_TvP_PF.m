function [ output_args ] = Browse_TvP_PF()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load ('TvP_analysis.mat','MeanT','MeanI','outT','outI','Tcent','Icent','ClosestT');

load('PlaceMapsIC.mat','SpatialI','FT','TMap_gauss','pval');

ICSpatialI = SpatialI;
ICFT = FT;
ICTMap = TMap_gauss;
ICpval = pval;

load('PlaceMaps.mat','SpatialI','FT','TMap_gauss','pval');

% transients
for i = 1:size(FT,1)
    temp = NP_FindSupraThresholdEpochs(FT(i,:),eps);
    nCaTr(i) = size(temp,1);
end

for i = 1:size(ICFT,1)
    temp = NP_FindSupraThresholdEpochs(ICFT(i,:),eps);
    ICnCaTr(i) = size(temp,1);
end



for i = 1:length(MeanT)
    idx = ClosestT(i);
    figure(1);set(gcf,'Position',[680 59 874 919])
    
    subplot(2,2,1);imagesc(MeanT{i});axis equal;axis tight;
    hold on;
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
    %title(['Ten #',int2str(i),' f = ',int2str(nAFT(i))],'FontSize',8);
   caxis([0 0.1])
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]);
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);
    
    
    
    
    subplot(2,2,2);imagesc(MeanI{idx});axis equal;axis tight;%set(gca,'CLim',CLim');
    hold on;caxis([0 0.1])
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
    %title(['PCA #',int2str(idx),' f = ',int2str(nAFI(idx))],'FontSize',8);
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]);
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);
    
    subplot(2,2,3);imagesc(TMap_gauss{i});axis equal;
    title(['I=',num2str(SpatialI(i)),' #tr=',int2str(nCaTr(i)),' p=',num2str(pval(i))]);
    
    subplot(2,2,4);imagesc(ICTMap{idx});axis equal;
    title(['I=',num2str(ICSpatialI(idx)),' #tr=',int2str(ICnCaTr(idx)),' p=',num2str(ICpval(idx))]);
    pause;
end

keyboard;

end


function [ output_args ] = Browse_TvP()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
load TvP_analysis.mat;
load NormTraces.mat;

for i = 1:length(NeuronImage)
    ROIgroup(i)
    figure;set(gcf,'Position',[66         279        1686         699])
    subplot(3,3,1);imagesc(MeanT{i});axis equal;axis tight;
    hold on;
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
    title(['Tenaspis Neuron #',int2str(i),' frames = ',int2str(nAFT(i))],'FontSize',8);
    CLim = get(gca,'CLim');
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]);
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);
    idx = ClosestT(i);
    %caxis([0 0.1]);
    
    subplot(3,3,2);imagesc(MeanI{idx});axis equal;axis tight;set(gca,'CLim',CLim');
    hold on;
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
    title(['PCAICA Neuron #',int2str(idx),' frames = ',int2str(nAFI(idx))],'FontSize',8);
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]);
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);
    %caxis([0 0.1]);
    subplot(3,3,3);imagesc(MeanDiff{i});hold on;axis equal;axis tight;
    plot(outT{i}{1}(:,2),outT{i}{1}(:,1),'-r');
    plot(outI{i}{1}(:,2),outI{i}{1}(:,1),'-k');
    set(gca,'XLim',[Tcent(i,1)-40 Tcent(i,1)+40]);
    set(gca,'YLim',[Tcent(i,2)-40 Tcent(i,2)+40]);caxis([-0.1 0.1]);
    
    title('Ten. - PCAICA','FontSize',8);
    
    s(1) = subplot(3,3,4:6);
    
    temp = ICtrace(idx,:);
    temp = convtrim(temp,ones(1,10)./10);
    plot(t,zscore(temp),'-k','DisplayName','IC trace','LineWidth',1);axis tight;hold on;
    plot(t,zscore(trace(ROIidx(i),:)),'-r','LineWidth',1.5,'DisplayName','Raw T.trace');hold on;
    gscore = max(trace(ROIidx(i),:))./std(trace(ROIidx(i),:));
    %set(gca,'YLim',[-3 15]);
    title(num2str(gscore));
    
    s(2) = subplot(3,3,7:9);
    
    
    plot(t,FT(i,:),'-r','LineWidth',5,'DisplayName','T. activity');hold on;
    plot(t,ICFT(idx,:),'-k','LineWidth',3,'DisplayName','ICA activity');axis tight;
    linkaxes(s,'x');
    pause;close;
end

keyboard;

end


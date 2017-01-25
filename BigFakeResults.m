function [ output_args ] = BigFakeResults( input_args )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
close all;
% make list of directories
basedir = 'J:\PostSubTesting\Fake\pAct_point001\';
seeds = 1:10;
sizes = [150,200,300,400];
ICnums = [59,173,581,1229]

% iterate and load results
for i = 1:length(sizes)
    for j = 1:length(seeds)
        wdir = [basedir,'Fake',int2str(sizes(i)),'-',int2str(seeds(j))]
        cd(wdir)
        % load stuff here
        %MakeICoutput4(ICnums(i));
        %MakeFakeMovie(j,sizes(i));
        %outs(i,j) = FakeDataResults;
        outs(i,j) = load('FakeDataResults.mat','PicaPartner','TnspsPartner','TnspsROIFalsePos','TnspsROIFalseNeg','PicaROIFalsePos',...
            'PicaROIFalseNeg','TnspsN','PicaN','FakeN','PicaFalseNegRate','TnspsFalseNegRate','TnspsFalsePosRate','PicaFalsePosRate',...
            'NumTnspsTransients','NumPicaTransients','NumFakeTransients');
    end
end



cd('C:\Users\Dave\Desktop\Revision\MatlabDumpingGround')
save outs.mat

load outs.mat;

% ugh, unpack the variables from the struct
for i = 1:length(sizes)
    for j = 1:length(seeds)
        TnspsROIFalsePos(i,j) = outs(i,j).TnspsROIFalsePos;
        TnspsROIFalseNeg(i,j) = outs(i,j).TnspsROIFalseNeg;
        PicaROIFalsePos(i,j) = outs(i,j).PicaROIFalsePos;
        PicaROIFalseNeg(i,j) = outs(i,j).PicaROIFalseNeg;
        
        TnspsN(i,j) = outs(i,j).TnspsN;
        PicaN(i,j) = outs(i,j).PicaN;
        FakeN(i,j) = outs(i,j).FakeN;
        
        PicaFalseNegRate{i,j} = outs(i,j).PicaFalseNegRate;
        TnspsFalseNegRate{i,j} = outs(i,j).TnspsFalseNegRate;
        PicaFalsePosRate{i,j} = outs(i,j).PicaFalsePosRate;
        TnspsFalsePosRate{i,j} = outs(i,j).TnspsFalsePosRate;
        
        NumTnspsTransients{i,j} = outs(i,j).NumTnspsTransients;
        NumPicaTransients{i,j} = outs(i,j).NumPicaTransients;
        NumFakeTransients{i,j} = outs(i,j).NumFakeTransients;
        
        PicaPartner{i,j} = outs(i,j).PicaPartner;
        TnspsPartner{i,j} = outs(i,j).TnspsPartner;
    end
end



% tally results and plot

%% figure 1: size estimates
figure(1);hold on;
plot(sizes.^2,mean((PicaN./FakeN)'*100-100),'r');
errorbar(sizes.^2,mean((PicaN./FakeN)'*100-100),std((PicaN./FakeN)'*100),'r','LineWidth',2);

plot(sizes.^2,mean((TnspsN./FakeN)'*100-100),'b');

errorbar(sizes.^2,mean((TnspsN./FakeN)'*100-100),std((TnspsN./FakeN)'*100),'b','LineWidth',2);

set(gca,'Box','off');
%set(gca,'Ylim',[0 1.1]);
set(gca,'XTick',sizes.^2);
xtl{1} = '150 x 150';
xtl{2} = '200 x 200';
xtl{3} = '300 x 300';
xtl{4} = '400 x 400';
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('movie size (# of pixels)');
ylabel('ROI detection error %');
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf,'ROI_count_accuracy','tif');

%% figure 2: activity estimates for fake ROIs with partners
figure(2);hold on;

for i = 1:length(sizes)
    for j = 1:length(seeds)
        GoodPicaROI{i,j} = PicaPartner{i,j}(PicaPartner{i,j} > 0);
        GoodTnspsROI{i,j} = TnspsPartner{i,j}(TnspsPartner{i,j} > 0);
        %keyboard;
        PicaActivityAccuracy{i,j} = abs(NumPicaTransients{i,j}(GoodPicaROI{i,j})-NumFakeTransients{i,j}(GoodPicaROI{i,j}))./NumFakeTransients{i,j}(GoodPicaROI{i,j});
        TnspsActivityAccuracy{i,j} = abs(NumTnspsTransients{i,j}(GoodTnspsROI{i,j})-NumFakeTransients{i,j}(GoodTnspsROI{i,j}))./NumFakeTransients{i,j}(GoodTnspsROI{i,j});
        
        PAA(i,j) = mean(PicaActivityAccuracy{i,j})*100;
        TAA(i,j) = mean(TnspsActivityAccuracy{i,j})*100;
        
        PicaFalsePos(i,j) = mean(PicaFalsePosRate{i,j}(GoodPicaROI{i,j}));
        PicaFalseNeg(i,j) = mean(PicaFalseNegRate{i,j}(GoodPicaROI{i,j}));
        
        TnspsFalsePos(i,j) = mean(TnspsFalsePosRate{i,j}(GoodTnspsROI{i,j}));
        TnspsFalseNeg(i,j) = mean(TnspsFalseNegRate{i,j}(GoodTnspsROI{i,j}));
    end
end

plot(sizes.^2,mean(PAA'),'r');errorbar(sizes.^2,mean(PAA'),std(PAA'),'r','LineWidth',2)
plot(sizes.^2,mean(TAA'),'b');errorbar(sizes.^2,mean(TAA'),std(TAA'),'b','LineWidth',2)
set(gca,'Box','off');
set(gca,'Ylim',[0 40]);
set(gca,'XTick',sizes.^2);
xtl{1} = '150 x 150';
xtl{2} = '200 x 200';
xtl{3} = '300 x 300';
xtl{4} = '400 x 400';
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('movie size (# of pixels)');
ylabel('# of transients detected: mean percent error)');
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf,'transient_count_accuracy','tif');

%% figure 3 same shits but for false positives and negatives
figure(3);hold on;


plot(sizes.^2,mean(PicaFalseNeg'),'r');errorbar(sizes.^2,mean(PicaFalseNeg'),std(PicaFalseNeg'),'r','LineWidth',2);
plot(sizes.^2,mean(TnspsFalseNeg'),'b');errorbar(sizes.^2,mean(TnspsFalseNeg'),std(TnspsFalseNeg'),'b','LineWidth',2);
set(gca,'Box','off');
set(gca,'Ylim',[0 1]);
set(gca,'YLim',[0 0.2])
set(gca,'XTick',sizes.^2);
xlabel('movie size (# of pixels)');
ylabel('false negative rate');

xtl{1} = '150 x 150';
xtl{2} = '200 x 200';
xtl{3} = '300 x 300';
xtl{4} = '400 x 400';
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');
saveas(gcf,'false_negs','tif');

%% figure 3 same shits but for false positives and negatives
figure(4);hold on;


plot(sizes.^2,mean(PicaFalsePos'),'r');errorbar(sizes.^2,mean(PicaFalsePos'),std(PicaFalsePos'),'r','LineWidth',2);
plot(sizes.^2,mean(TnspsFalsePos'),'b');errorbar(sizes.^2,mean(TnspsFalsePos'),std(TnspsFalsePos'),'b','LineWidth',2);
set(gca,'Box','off');
set(gca,'Ylim',[0 1]);
set(gca,'YLim',[0 0.2])
set(gca,'XTick',sizes.^2);
xlabel('movie size (# of pixels)');
ylabel('false positive rate');

xtl{1} = '150 x 150';
xtl{2} = '200 x 200';
xtl{3} = '300 x 300';
xtl{4} = '400 x 400';
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');

saveas(gcf,'false_pos','tif');


keyboard;



% plot(x,mean(Tnsps'),'bo','MarkerFaceColor','b','MarkerSize',2);hold on;errorbar(x,mean(Tnsps'),std(Tnsps'),'b','LineWidth',1);
% plot(x,mean(Pica'),'rs','MarkerFaceColor','r','MarkerSize',2);hold on;errorbar(x,mean(Pica'),std(Pica'),'r','LineWidth',1);
% %set(gca,'Xlim',[150 400]);
% set(gca,'Ylim',[0 180]);
% set(gca,'XTick',x);
% xtl{1} = '150 x 150';
% xtl{2} = '200 x 200';
% xtl{3} = '300 x 300';
%
% %set(gca,'XTickLabel',xtl);

% xlabel('movie size (pixels)');
% ylabel('run time (minutes)');
% set(gca,'Box','off');


end


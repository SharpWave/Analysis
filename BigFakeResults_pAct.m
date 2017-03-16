function [ output_args ] = BigFakeResults( input_args )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
close all;
% make list of directories
basedir{1} = 'J:\PostSubTesting\Fake\pAct_point0005\';
basedir{2} = 'J:\PostSubTesting\Fake\pAct_point001\';
basedir{3} = 'J:\PostSubTesting\Fake\pAct_point0015\';
seeds = 1:10;
sizes = [0.01,0.02,0.03];
ICnums = [581,581,581]

% iterate and load results
for i = 1:length(sizes)
    for j = 1:length(seeds)
        wdir = [basedir{i},'Fake',int2str(300),'-',int2str(seeds(j))]
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
save outs_pAct.mat

load outs_pAct.mat;

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
plot(sizes,mean((PicaN./FakeN)'*100-100),'r');
errorbar(sizes,mean((PicaN./FakeN)'*100-100),std((PicaN./FakeN)'*100),'r','LineWidth',2);

plot(sizes,mean((TnspsN./FakeN)'*100-100),'b');

errorbar(sizes,mean((TnspsN./FakeN)'*100-100),std((TnspsN./FakeN)'*100),'b','LineWidth',2);

set(gca,'Box','off');
%set(gca,'Ylim',[0 1.1]);
set(gca,'XTick',sizes);

xtl{1} = '0.01';
xtl{2} = '0.02';
xtl{3} = '0.03';
set(gca,'XLim',[0 0.04]);
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('activity rate (transients per sec)');
ylabel('ROI detection error %');
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');


%% figure 2: activity estimates for fake ROIs with partners
figure(2);hold on;

for i = 1:length(sizes)
    for j = 1:length(seeds)
        GoodPicaROI{i,j} = PicaPartner{i,j}(PicaPartner{i,j} > 0); % list of PCA/ICA indices that had partners
        GoodTnspsROI{i,j} = TnspsPartner{i,j}(TnspsPartner{i,j} > 0); % list of Tenaspis indices that had partners
        GoodFakeROIp{i,j} = find(PicaPartner{i,j} > 0);
        GoodFakeROIt{i,j} = find(TnspsPartner{i,j} > 0);
        
        PicaActivityAccuracy{i,j} = abs(NumPicaTransients{i,j}(GoodPicaROI{i,j})-NumFakeTransients{i,j}(GoodFakeROIp{i,j}))./NumFakeTransients{i,j}(GoodFakeROIp{i,j});
        TnspsActivityAccuracy{i,j} = abs(NumTnspsTransients{i,j}(GoodTnspsROI{i,j})-NumFakeTransients{i,j}(GoodFakeROIt{i,j}))./NumFakeTransients{i,j}(GoodFakeROIt{i,j});
        
        PAA(i,j) = mean(PicaActivityAccuracy{i,j})*100;
        TAA(i,j) = mean(TnspsActivityAccuracy{i,j})*100;
        
        PicaFalsePos(i,j) = mean(PicaFalsePosRate{i,j}(GoodFakeROIp{i,j}));
        PicaFalseNeg(i,j) = mean(PicaFalseNegRate{i,j}(GoodFakeROIp{i,j}));
        
        TnspsFalsePos(i,j) = mean(TnspsFalsePosRate{i,j}(GoodFakeROIt{i,j}));
        TnspsFalseNeg(i,j) = mean(TnspsFalseNegRate{i,j}(GoodFakeROIt{i,j}));
    end
end

plot(sizes,mean(PAA'),'r');errorbar(sizes,mean(PAA'),std(PAA'),'r','LineWidth',2)
plot(sizes,mean(TAA'),'b');errorbar(sizes,mean(TAA'),std(TAA'),'b','LineWidth',2)
set(gca,'Box','off');
set(gca,'Ylim',[0 40]);
set(gca,'XTick',sizes);

xtl{1} = '0.01';
xtl{2} = '0.02';
xtl{3} = '0.03';
set(gca,'XLim',[0 0.04]);
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('activity rate (transients per sec)');
ylabel('# of transients detected: mean percent error)');
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');


%% figure 3 same shits but for false positives and negatives
figure(3);hold on;


plot(sizes,mean(PicaFalseNeg'),'r');errorbar(sizes,mean(PicaFalseNeg'),std(PicaFalseNeg'),'r','LineWidth',2);
plot(sizes,mean(TnspsFalseNeg'),'b');errorbar(sizes,mean(TnspsFalseNeg'),std(TnspsFalseNeg'),'b','LineWidth',2);
set(gca,'Box','off');
set(gca,'Ylim',[0 1]);
set(gca,'YLim',[0 0.2])
set(gca,'XTick',sizes);
xlabel('activity rate (transients per sec)');
ylabel('false negatives per transient');

xtl{1} = '0.01';
xtl{2} = '0.02';
xtl{3} = '0.03';
set(gca,'XLim',[0 0.04]);
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');


%% figure 3 same shits but for false positives and negatives
figure(4);hold on;


plot(sizes,mean(PicaFalsePos'),'r');errorbar(sizes,mean(PicaFalsePos'),std(PicaFalsePos'),'r','LineWidth',2);
plot(sizes,mean(TnspsFalsePos'),'b');errorbar(sizes,mean(TnspsFalsePos'),std(TnspsFalsePos'),'b','LineWidth',2);
set(gca,'Box','off');
set(gca,'Ylim',[0 1]);
set(gca,'YLim',[0 0.2])
set(gca,'XLim',[0 0.04]);
set(gca,'XTick',sizes);
xlabel('activity rate (transients per sec)');
ylabel('false positives per transient');

xtl{1} = '0.01';
xtl{2} = '0.02';
xtl{3} = '0.03';

set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
set(gcf,'Position',[814   388   533   461]);
set(gcf, 'PaperPositionMode', 'auto');

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


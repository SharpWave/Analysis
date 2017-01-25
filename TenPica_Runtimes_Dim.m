function [ output_args ] = TenPica_Runtimes_Dim()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

close all;

Pica(1,1:10) = [562,555,552,557,559,572,531,535,533,531];    

Pica(2,1:10) = [1434,1494,1466,1475,1471,1497,1609,1435,1473,1497];

Pica(3,1:10) = [8689,9215,9173,9141,7324,8224,9097,9123,9558,8350];

Pica(4,1:10) = [35536,38137,38217,37443,37278,37788,38512,34171,34463,40610];

Pica = Pica/60;

NumSeeds = 10;

basedir{1} = 'J:\PostSubTesting\Fake\pAct_point001';
basedir{2} = 'J:\PostSubTesting\Fake\pAct_point001';
basedir{3} = 'J:\PostSubTesting\Fake\pAct_point001';
basedir{4} = 'J:\PostSubTesting\Fake\pAct_point001';

ndim = [150,200,300,400];

for i = 1:length(basedir)
    cd(basedir{i});
    for j = 1:NumSeeds
      cd(['Fake',int2str(ndim(i)),'-',int2str(j)]);
      load ttime.mat;
      Tnsps(i,j) = ttime;
      cd ..
    end
end

Tnsps = Tnsps/60;

x = ndim.^2;

h(1) = plot(x,mean(Tnsps'),'bo','MarkerFaceColor','b','MarkerSize',2);hold on;
errorbar(x,mean(Tnsps'),std(Tnsps'),'b','LineWidth',1);
h(2) = plot(x,mean(Pica'),'rs','MarkerFaceColor','r','MarkerSize',2);
hold on;errorbar(x,mean(Pica'),std(Pica'),'r','LineWidth',1);
%set(gca,'Xlim',[150 400]);
%set(gca,'Ylim',[0 180]);
set(gca,'XTick',x);
xtl{1} = '150 x 150';
xtl{2} = '200 x 200';
xtl{3} = '300 x 300';
xtl{4} = '400 x 400';

set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('movie size (pixels)');
ylabel('run time (minutes)');
set(gca,'Box','off');
keyboard;

end


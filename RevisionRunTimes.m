function [ output_args ] = RevisionTimeComps( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

close all;

Tnsps150 = [799,443,767,782,813];
Pica150 = [562,555,552,557,559];
    
Tnsps200 = [1151,1087,1051,1047,1039];
Pica200 = [1434,1494,1466,1475,1471];

Tnsps300 = [3172,3705,3556,3015,3670];
Pica300 = [8689,9215,9173,9141,7324];

Tnsps = [Tnsps150;Tnsps200;Tnsps300]/60;
Pica = [Pica150;Pica200;Pica300]/60;
x = [150,200,300].^2;

plot(x,mean(Tnsps'),'bo','MarkerFaceColor','b','MarkerSize',2);hold on;errorbar(x,mean(Tnsps'),std(Tnsps'),'b','LineWidth',1);
plot(x,mean(Pica'),'rs','MarkerFaceColor','r','MarkerSize',2);hold on;errorbar(x,mean(Pica'),std(Pica'),'r','LineWidth',1);
%set(gca,'Xlim',[150 400]);
set(gca,'Ylim',[0 180]);
set(gca,'XTick',x);
xtl{1} = '150 x 150';
xtl{2} = '200 x 200';
xtl{3} = '300 x 300';

%set(gca,'XTickLabel',xtl);
set(gca,'XTickLabelRotation',45);
xlabel('movie size (pixels)');
ylabel('run time (minutes)');
set(gca,'Box','off');
keyboard;

end


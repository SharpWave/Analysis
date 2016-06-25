function [ output_args ] = TenaspisPaperPlots()

% All plots generated for the paper should be here
close all;

cd('C:\MasterData');
load TvP_Group.mat;

CurrFig = 1;
NumAnimals = length(dr);

% ROIgroup analysis %%%%%%%%%%%%%%%%%%%%%%%
% How well do Tenaspis ROIs and PCA/ICA ROIs match?

% Color scheme:
ROIcolors{1} = [0 0.7 0]; % good match: darkish green
ROIcolors{2} = 'b'; %conflict
ROIcolors{3} = 'm'; % baddish match
ROIcolors{4} = 'r'; % bad match
NumROIcolors = length(ROIcolors);

f(CurrFig) = figure(CurrFig);
for i = 1:NumROIcolors
    g = find(All_ROIgroup == i);
    plot(All_mindist(g),All_FractionOverlap(g),'o','Color',ROIcolors{i},'MarkerFaceColor',ROIcolors{i});hold on;
end
axis tight;
set(gca,'Box','off');

% ROI group histogram %%%%%%%%%%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);

for i = 1:NumAnimals
    for j = 1:4
        ROIgroupmat(i,j) = length(intersect(find(All_Animal == i),find(All_ROIgroup == j)));
    end
end

axes1 = axes;
hold(axes1,'on');

% Create multiple lines using matrix input to bar
bar1 = bar(ROIgroupmat);
set(bar1(1),'DisplayName','close match','FaceColor',ROIcolors{1});
set(bar1(2),'DisplayName','contested close match','FaceColor',ROIcolors{2});
set(bar1(3),'DisplayName','partial match','FaceColor',ROIcolors{3});
set(bar1(4),'DisplayName','no match','FaceColor',ROIcolors{4});
keyboard;

% Create ylabel
ylabel({'# of Tenaspis ROIs'});

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XTick',[1 2 3 4 5],'XTickLabel',...
    {'mouse 1','mouse 2','mouse 3','mouse 4','mouse 5'});
% Create legend
legend1 = legend(axes1,'show');
set(gca,'Box','off');

set(legend1,...
    'Position',[0.333513303788171 0.640649261546239 0.103347032544757 0.189542483660131]);

end


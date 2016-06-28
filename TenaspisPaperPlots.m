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
ROIcolors{3} = 'r'; % badd match
NumROIcolors = length(ROIcolors);



% ROI group histogram %%%%%%%%%%%%%%%%%%%%%%%%
f(CurrFig) = figure(CurrFig);
set(gcf,'Position',[653   121   549   295]);
for i = 1:NumAnimals
    for j = 1:3
        ROIgroupmat(i,j) = length(intersect(find(All_Animal == i),find(All_ROIgroup == j)));
    end
end

axes1 = axes;
hold(axes1,'on');

% Create multiple lines using matrix input to bar
bar1 = bar(ROIgroupmat);
set(bar1(1),'DisplayName','unique IC match','FaceColor',ROIcolors{1});
set(bar1(2),'DisplayName','shared IC match','FaceColor',ROIcolors{2});
set(bar1(3),'DisplayName','no IC match','FaceColor',ROIcolors{3});


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
    'Position',[0.29502288804999 0.590322464160617 0.264116570760643 0.269857095380526]);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcium Transient rate comparison histogram
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));
% Create histogram
a = find(All_ROIgroup == 1);
% Create histogram
histogram(All_T_TransientsPerMinute(a),'DisplayName','Tenaspis ROIs','Parent',axes1,...
    'FaceColor',[0 0.7 0],...
    'BinLimits',[0 7],...
    'BinWidth',0.25);hold on;
histogram(All_Closest_I_TransientsPerMinute(a),'DisplayName','PCA/ICA ROIs','Parent',axes1,...
    'FaceColor',[1 1 1],...
    'BinLimits',[0 7],...
    'BinWidth',0.25);
% Create xlabel
xlabel({'calcium events per minute'});
ylabel('# of ROIs');
set(gca,'Box','off')
legend(axes1,'show');
axis(axes1,'tight');
display('paired t-test for events per minute:');
[h,p] = ttest(All_T_TransientsPerMinute(a),All_Closest_I_TransientsPerMinute(a)),

%%%%%%%%%%%
% Calcium transient agreement
% %%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));
% Create histogram
a = find(All_ROIgroup == 1);
b = intersect(a,find(All_T_TransientsPerMinute > 1));
b = intersect(b,find(All_Closest_I_TransientsPerMinute > 1));

% Create histogram
histogram(All_T_Score(a),'Parent',axes1,...
    'FaceColor',[0 0.7 0],...
    'BinLimits',[0 1],...
    'DisplayName','All ROIs',...
    'BinWidth',0.05,'Normalization','probability');hold on;
    histogram(All_T_Score(b),'Parent',axes1,...
    'FaceColor',[0 0.3 0],...
    'BinLimits',[0 1],...
    'DisplayName','highly active ROIs',...
    'BinWidth',0.05,'Normalization','probability');hold on;
    
set(gca,'Box','off');
xlabel('temporal match score');
ylabel('fraction of ROIs');
legend1 = legend(axes1,'show');
set(legend1,...
    'Position',[0.434928638683859 0.744632771594376 0.385390420929911 0.12881355608924]);


end


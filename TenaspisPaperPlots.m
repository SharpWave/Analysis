function [ output_args ] = TenaspisPaperPlots()

% All plots generated for the paper should be here
close all;

cd('C:\MasterData');
load TvP_Group.mat;
load runtimes.mat;

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
set(legend1,'Box','off');
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
    'BinLimits',[0 4],...
    'BinWidth',0.25);hold on;
histogram(All_Closest_I_TransientsPerMinute(a),'DisplayName','PCA/ICA ROIs','Parent',axes1,...
    'FaceColor',[1 1 1],...
    'BinLimits',[0 4],...
    'BinWidth',0.25);
% Create xlabel
xlabel({'calcium events per minute'});
ylabel('# of ROIs');
set(gca,'Box','off')
l1 = legend(axes1,'show');
set(l1,'Box','off');
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
display('temporal scores # of ROI pairs EPM > 1')
length(b),

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
set(legend1,'Box','off');
set(legend1,...
    'Position',[0.434928638683859 0.744632771594376 0.385390420929911 0.12881355608924]);

%%%%%%%%%%%
% Calcium transient rate comparison
% %%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));
% Create histogram
a = find(All_ROIgroup == 1);
b = find(All_ROIgroup == 3);

% Create histogram
histogram(All_T_TransientsPerMinute(a),'Parent',axes1,...
    'FaceColor',[0 0.7 0],...
    'BinLimits',[0 4],...
    'DisplayName','unique IC match',...
    'BinWidth',0.25,'Normalization','probability');hold on;
    histogram(All_T_TransientsPerMinute(b),'Parent',axes1,...
    'FaceColor',[1 0 0],...
    'BinLimits',[0 4],...
    'DisplayName','no IC match',...
    'BinWidth',0.25,'Normalization','probability');hold on;
    
set(gca,'Box','off');
xlabel('calcium events per minute');
ylabel('fraction of ROIs');
legend1 = legend(axes1,'show');
set(legend1,'Box','off');
set(legend1,...
    'Position',[0.434928638683859 0.744632771594376 0.385390420929911 0.12881355608924]);

%%%%%%%%%%%
% Calcium transient rate comparison
% %%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));
% Create histogram

a = find(All_ROIgroup == 1);
a = intersect(a,find(All_T_pval > 0.95));
a = intersect(a,find(All_IC_pval > 0.95));
% Create histogram


histogram(log10(All_min_PFdist(a)),25,'Parent',axes1,...
    'FaceColor',[0 0.7 0],...    
    'DisplayName','unique IC match');hold on;axis tight;
display('median PF distance');
median(All_min_PFdist(a)),
display('fraction PF under 5 cm');
length(find(All_min_PFdist(a) < 10))/length(a),
display('total place fields');
length(a),
    
set(gca,'Box','off');
xlabel('log10 place field peak error (cm)');
ylabel('number of ROIs');

%%%%%%%%%%%
% Place Field Spatial Info Correlation
% %%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));
% Create histogram

a = find(All_ROIgroup == 1);
a = intersect(a,find(All_T_pval > 0.95));
a = intersect(a,find(All_IC_pval > 0.95));
a = intersect(a,find(All_Num_T_Transients >= 4));
a = intersect(a,find(All_Num_Closest_I_Transients >= 4));
% Create histogram


plot1 = plot(All_IC_MutInf(a)/20,All_T_MutInf(a)/20,'o','Parent',axes1,...
    'MarkerFaceColor',[0 0.7 0],...
    'Color',[0 0 0],...
    'DisplayName','unique IC match');hold on;axis tight;

    
set(gca,'Box','off');
xlabel('PCA/ICA spatial information (bits/event)');
ylabel('Tenaspis spatial information (bits/event)');
axis(axes1,'equal');
axis([0 0.3 0 0.3]);
% Find x values for plotting the fit based on xlim
axesLimits1 = xlim(axes1);
xplot1 = linspace(axesLimits1(1), axesLimits1(2));


fitResults1 = polyfit(All_IC_MutInf(a)/20, All_T_MutInf(a)/20, 1);
% Evaluate polynomial
yplot1 = polyval(fitResults1, xplot1);
% Plot the fit
fitLine1 = plot(xplot1,yplot1,'DisplayName','   linear','Tag','linear',...
    'Parent',axes1,...
    'LineWidth',3,...
    'Color',[1 0 0]);

% Set new line in proper position
setLineOrder(axes1, fitLine1, plot1);



% Set the remaining axes properties
set(axes1,'DataAspectRatio',[1 1 1],'PlotBoxAspectRatio',...
    [1.24797484486329 1 10.9291412775768]);

display('Tenaspis vs PCA/ICA well matched significant PF spatial info');
[r,p] = corr(All_T_MutInf(a)',All_IC_MutInf(a)')
% Create textbox
annotation(f(CurrFig),'textbox',...
    [0.239294710327456 0.810169491525424 0.204030226700252 0.0837457627118645],...
    'String',['r = ',num2str(r)],...
    'LineStyle','none');

%%%%%%%%%%%
% Place Field Area Correlation
% %%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));
% Create histogram

a = find(All_ROIgroup == 1);
a = intersect(a,find(All_T_pval > 0.95));
a = intersect(a,find(All_IC_pval > 0.95));
a = intersect(a,find(All_Num_T_Transients >= 4));
a = intersect(a,find(All_Num_Closest_I_Transients >= 4));
% Create histogram


plot1 = plot(All_PFTarea(a)/4,All_PFICarea(a)/4,'o','Parent',axes1,...
    'MarkerFaceColor',[0 0.7 0],...
    'Color',[0 0 0],...
    'DisplayName','unique IC match');hold on;axis tight;

    
set(gca,'Box','off');
xlabel('PCA/ICA place field area (cm sq)');
ylabel('Tenaspis place field area (cm sq)');
axis(axes1,'equal');
axis equal;
axis([0 250 0 200])
% Find x values for plotting the fit based on xlim
axesLimits1 = xlim(axes1);
xplot1 = linspace(axesLimits1(1), axesLimits1(2));


fitResults1 = polyfit(All_PFTarea(a)/4,All_PFICarea(a)/4, 1);
% Evaluate polynomial
yplot1 = polyval(fitResults1, xplot1);
% Plot the fit
fitLine1 = plot(xplot1,yplot1,'DisplayName','   linear','Tag','linear',...
    'Parent',axes1,...
    'LineWidth',3,...
    'Color',[1 0 0]);

% Set new line in proper position
setLineOrder(axes1, fitLine1, plot1);







display('Tenaspis vs PCA/ICA well matched significant PF area');
[r,p] = corr(All_PFTarea(a)',All_PFICarea(a)')
% Create textbox
annotation(f(CurrFig),'textbox',...
    [0.239294710327456 0.810169491525424 0.204030226700252 0.0837457627118645],...
    'String',['r = ',num2str(r)],...
    'LineStyle','none');

%%%%%%%%%%%
% Transient rate correlation
% %%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));
% Create histogram

a = find(All_ROIgroup == 1);

% Create histogram


plot1 = histogram2(All_Closest_I_TransientsPerMinute(a),All_T_TransientsPerMinute(a),'Parent',axes1,...
    'DisplayStyle','tile');hold on;axis tight;

    
set(gca,'Box','off');grid off;
xlabel({'PCA/ICA calcium event rate','(events/minute)'});
ylabel({'Tenaspis calcium event rate','(events/minute)'});
axis(axes1,'equal');
axis equal;axis([0 5 0 5]);
%axis([0 250 0 200])
% Find x values for plotting the fit based on xlim
axesLimits1 = xlim(axes1);
xplot1 = linspace(axesLimits1(1), axesLimits1(2));


fitResults1 = polyfit(All_Closest_I_TransientsPerMinute(a),All_T_TransientsPerMinute(a), 1);
% Evaluate polynomial
yplot1 = polyval(fitResults1, xplot1);
% Plot the fit
fitLine1 = plot(xplot1,yplot1,'DisplayName','   linear','Tag','linear',...
    'Parent',axes1,...
    'LineWidth',3,...
    'Color',[1 0 0]);

% Set new line in proper position
setLineOrder(axes1, fitLine1, plot1);
colorbar






display('Tenaspis vs PCA/ICA well matched event rate correlation');
[r,p] = corr(All_Closest_I_TransientsPerMinute(a)',All_T_TransientsPerMinute(a)')
% Create textbox
annotation(f(CurrFig),'textbox',...
    [0.541561712846346 0.288135593220339 0.204030226700252 0.0837457627118646],...
    'String',['r = ',num2str(r,2)],...
    'LineStyle','none');

%%%%%%%%%%%
% Place Field Area Correlation
% %%%%%%%%%%%%%%%%
CurrFig = CurrFig + 1;
f(CurrFig) = figure(CurrFig);
set(f(CurrFig),'Position',[1     1   397   295]);
% Create axes
axes1 = axes('Parent',f(CurrFig));

plot1 = plot(runtimes(:,2)/(24*3600),runtimes(:,1)/(3600),'o','Parent',axes1,...
    'MarkerFaceColor',[0 0 0],...
    'Color',[0 0 0],...
    'DisplayName','unique IC match');hold on;axis tight;
axis([0 1.4 0 4.5])    
set(gca,'Box','off');
xlabel('PCA/ICA run time (days)');
ylabel('Tenaspis run time (hours)');


display('Tenaspis vs PCA/ICA well matched significant PF area');
[r,p] = corr(runtimes(:,2)/(3600),runtimes(:,1)/(24*60*60))

cd('J:\Tenaspis2Test\GCaMP6f_45');
load('TvP_analysis.mat','ROIgroup');
a = find(ROIgroup == 1)
TvP_ROIcompare(a([80 162 240 321 400 481 567]));
a = find(ROIgroup == 3)
TvP_ROIcompare(a((1:7)*20))
a = find(ROIgroup == 2)
TvP_ROIcompare(a((1:7)*9))
keyboard;
end

%-------------------------------------------------------------------------%
function setLineOrder(axesh1, newLine1, associatedLine1)
%SETLINEORDER(AXESH1,NEWLINE1,ASSOCIATEDLINE1)
%  Set line order
%  AXESH1:  axes
%  NEWLINE1:  new line
%  ASSOCIATEDLINE1:  associated line

% Get the axes children
hChildren = get(axesh1,'Children');
% Remove the new line
hChildren(hChildren==newLine1) = [];
% Get the index to the associatedLine
lineIndex = find(hChildren==associatedLine1);
% Reorder lines so the new line appears with associated data
hNewChildren = [hChildren(1:lineIndex-1);newLine1;hChildren(lineIndex:end)];
% Set the children:
set(axesh1,'Children',hNewChildren);


end


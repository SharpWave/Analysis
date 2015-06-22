function [ output_args ] = PlotAllPF()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cd('C:\MasterData');
load MasterDirectory;
cd(MD(1).Location);
load Reg_NeuronIDs.mat;

nmap = Reg_NeuronIDs(1).all_session_map(:,2:end);

NumNeurons = size(nmap,1);
NumSessions = size(nmap,2);

for i = 1:length(MD)
    cd(MD(i).Location);
    load ProcOut;
    NT{i} = NumTransients/NumFrames*20*60;
end

isactive = zeros(size(nmap));
ratemat = zeros(size(nmap));

for i = 1:size(nmap,1)
    % determine first sess
    NumSessActive(i) = 0;
    ActiveSess{i} = [];
    ActiveSessIdx{i} = [];
    TRates{i} = [];
    for j = 1:NumSessions
        if (~isnan(nmap{i,j}) & ~isempty(nmap{i,j}))
            NumSessActive(i) = NumSessActive(i) + 1;
            ActiveSess{i} = [ActiveSess{i},j];
            ActiveSessIdx{i} = [ActiveSessIdx{i},nmap{i,j}];
            isactive(i,j) = 1;
            ratemat(i,j) = NT{j}(nmap{i,j});
        end
    end

    for j = 1:NumSessActive(i)
        %cd(MD(ActiveSess{i}(j)).Location);
        %load PlaceMaps;
        %PFbrowse('D1Movie.h5',ActiveSessIdx{i}(j));
        %load ProcOut.mat;
        i,j,
        TRates{i} = [TRates{i},NT{ActiveSess{i}(j)}(ActiveSessIdx{i}(j))];
    end
    %pause;
    %close all;


end
figure;hist(NumSessActive,0:max(NumSessActive));xlabel('Number of sessions active');ylabel('Number of neurons');

for i = 1:size(nmap,1)
mt(i) = mean(TRates{i});
end

plot(NumSessActive,mt,'*');

keyboard

function [ output_args ] = BigFakeResults( input_args )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

% make list of directories
basedir = 'J:\PostSubTesting\Fake\';
seeds = 1:5;
sizes = [150,200,300];
ICnums = [59,173,581]

% iterate and load results
for i = 1:length(sizes)
    for j = 1:length(seeds)
        wdir = [basedir,'Fake',int2str(sizes(i)),'-',int2str(seeds(j))];
        cd(wdir);
        % load stuff here
        MakeICoutput4(ICnums(i))
    end
end

% tally results and plot

end


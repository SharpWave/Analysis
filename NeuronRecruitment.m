function [t,NumCellsRecruited,CellsActive] = NeuronRecruitment(animal_id,sess_date,sess_num)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
ChangeDirectory(animal_id,sess_date,sess_num);
load ProcOut;

t = (1:NumFrames)/20/60;

AllN = [];

for i = 1:1:NumFrames
    AN = find(FT(:,i) == 1);
    AllN = union(AllN,AN);
    NumCellsRecruited(i) = length(AllN);
    CellsActive(i) = length(AN);

end


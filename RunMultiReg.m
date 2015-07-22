function [ output_args ] = RunMultiReg(sess_nums)
% run multi_image_reg on a bunch of sessions

cd C:\MasterData
load MasterDirectory

for i = 1:length(sess_nums)
    DataIn(i) = MD(sess_nums(i));
    


end

multi_image_reg(DataIn(1),DataIn(2:23),0)


cd('C:\MasterData');
load MasterDirectory.mat;

for i = 1:length(MD)

    cd(MD(i).Location);

    ExtractTracesBlob('D1Movie.h5','Obj_1 - ICsm.h5');

    
end
cd('C:\MasterData');
load MasterDirectory.mat;

for i = 1:length(MD)
    %Tenaspis('Obj_1 - ICsm.h5','animal_id',MD(i).Animal,'sess_date',MD(i).Date,'sess_num',MD(i).Session,'no_movie_process',1);
    cd(MD(i).Location);
    CalculatePlacefields(MD(i).Room);
    PFstats;
    ExtractTracesProc('D1Movie.h5','Obj_1 - ICsm.h5');
  
    
end
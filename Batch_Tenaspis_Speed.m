function [] = Batch_Tenaspis_Speed()

dr{1} = 'J:\Tenaspis2Test\GCaMP6f_30';
dr{2} = 'J:\Tenaspis2Test\GCaMP6f_31';
dr{3} = 'J:\Tenaspis2Test\GCaMP6f_44';
dr{4} = 'J:\Tenaspis2Test\GCaMP6f_45';
dr{5} = 'J:\Tenaspis2Test\GCaMP6f_48';

for i = 1:5
    cd(dr{i});
    tic
    MakeHighpassDFF('Obj_1 - ICsm.h5','SLPDF_temp.h5');
    Tenaspis2singlesession();
    runtime(i) = toc;
    save Batch_Tenaspis_Speed.mat;
end
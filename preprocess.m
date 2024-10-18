EEG.etc.eeglabvers = '2021.0';
data_path = '';% the path of the raw data
save_path = '';% the path of the processed data

cd(data_path);
rawfile = dir('*.cnt');
rawname =  {rawfile.name};

%% step 1
for i=1:length(rawname)
setname = [num2str(i),'.set'];
importname = [data_path,num2str(i),'_convert.cdt.cnt'];
EEG = pop_loadcnt(importname , 'dataformat', 'auto', 'memmapfile', '');
EEG = eeg_checkset( EEG );
EEG=pop_chanedit(EEG, 'lookup','');% you may fill in the gap in ''
EEG = pop_select( EEG, 'channel',{'Fp1','Fpz','Fp2','AF3','AF4','F7','F5','F3','F1','Fz','F2','F4','F6','F8','FC5','FC3','FC1','FCz','FC2','FC4','FC6','T7','C5','C3','C1','Cz','C2','C4','C6','T8','TP7','CP5','CP3','CP1','CPz','CP2','CP4','CP6','TP8','M1','M2','P7','P5','P3','P1','Pz','P2','P4','P6','P8','PO7','PO3','POz','PO4','PO8','O1','Oz','O2'});
EEG = pop_eegfiltnew(EEG, 'locutoff',0.5,'plotfreqz',0);
EEG = pop_eegfiltnew(EEG, 'hicutoff',40,'plotfreqz',0);
EEG = pop_epoch( EEG, {}, [-0.25  2.5], 'newname', 'CNT file resampled epochs', 'epochinfo', 'yes');% you may fill in the gap in {}
EEG = pop_rmbase( EEG, [-250  0],[]);
EEG = pop_saveset(EEG, 'filename', setname, 'filepath', save_path);
end

%% step 2
set_name = '';% you may fill in the gap in ''
set_path = '';% you may fill in the gap in ''
save_path = '';% you may fill in the gap in ''
EEG = pop_loadset('filename', set_name, 'filepath', set_path);
pop_eegplot( EEG, 1, 1, 1);
EEG = pop_interp(EEG, [], 'spherical');% you may fill in the gap in [] if necessary
EEG = pop_saveset(EEG, 'filename', set_name, 'filepath', save_path);

%% step 3
data_path = '';% you may fill in the gap in ''
save_path = '';% you may fill in the gap in ''
Subj = [1:8];
for i = Subj
setname = [num2str(i),'.set'];
EEG = pop_loadset('filename', setname, 'filepath', data_path);
EEG = pop_reref( EEG, [] );
EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'interrupt','on');
%EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1,'pca', ,'interrupt','on');% you may fill in the gap in , ,
EEG = pop_saveset(EEG, 'filename', setname, 'filepath', save_path);
end

%% step 4
set_pamnth = '';% you may fill in the gap in ''
save_path = '';% you may fill in the gap in ''
Subj = [1:8];
for i=Subj
    set_name = strcat(num2str(i),'.set');
    EEG = pop_loadset('filename',set_name,'filepath',set_path);
    EEG = pop_iclabel(EEG, 'default');
    EEG = pop_icflag(EEG, [NaN NaN;0.9 1;0.9 1;0.9 1;0.9 1;0.9 1;NaN NaN]); 
    EEG = pop_subcomp( EEG, [], 0);
    EEG = eeg_checkset( EEG );
    EEG = pop_saveset( EEG, 'filename',set_name, 'filepath',save_path); 
end



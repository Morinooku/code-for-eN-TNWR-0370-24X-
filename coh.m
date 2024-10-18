%% coherence
% compute coherence
clear;
ft_defaults
cd('');% change the directory
load('')% load the EEG data (.mat)
load('')% load the EEG data of comparison group (.mat)
data1 = eeglab2fieldtrip(EEG1{1,1},'preprocessing');
data2 = eeglab2fieldtrip(EEG2{1,1},'preprocessing');

cfg =[];
cfg.method = 'mtmfft';
cfg.taper = 'hanning' ;
cfg.keeptrials = 'yes';
cfg.output= 'fourier';
cfg.foilim= [14 30];% beta band
cfg.pad = 'nextpow2';
cfg.tapsmofrq = 1;
freq_1 = ft_freqanalysis(cfg, data1);
freq_2 = ft_freqanalysis(cfg, data2);
cfg =[];
cfg.method= 'coh';
coh_1 = ft_connectivityanalysis(cfg, freq_1);
coh_2 = ft_connectivityanalysis(cfg, freq_2);

% display results
cfg = [];
cfg. parameter = 'cohspctrm';
cfg.zlim= [0 1] ;% the limitation of y axis
cfg.channel = ;% choose the channel
figure;
ft_connectivityplot(cfg, coh_pre,coh_post);


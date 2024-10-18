%% Directed Coherence
% Compute Directed Coherence
clear;
ft_defaults
cd('');% change the directory
load('')% load the EEG data (.mat)
load('')% load the EEG data of comparison group (.mat)
data1 = eeglab2fieldtrip(EEG1{1,1},'preprocessing');
data2 = eeglab2fieldtrip(EEG2{1,1},'preprocessing');

cfg = [];
cfg.method = 'mtmfft';
cfg.taper = 'hanning';
cfg.output = 'fourier';
cfg.foilim = [14 30]; % beta band
cfg.pad = 'nextpow2';
cfg.tapsmofrq = 1;
cfg.keeptrials = 'yes';
freq_1 = ft_freqanalysis(cfg, data1);
freq_2 = ft_freqanalysis(cfg, data2);
cfg = [];
cfg.method = 'mvar';
cfg.order = 10; % You may need to adjust this value
mvar_1 = ft_mvaranalysis(cfg, freq_1);
mvar_2 = ft_mvaranalysis(cfg, freq_2);

cfg = [];
cfg.method = 'pdc';
pdc_1 = ft_connectivityanalysis(cfg, mvar_1);
pdc_2 = ft_connectivityanalysis(cfg, mvar_2);

% Display results
cfg = [];
cfg.parameter = 'pdc';
cfg.zlim = [0 1]; % the limitation of y axis
cfg.channel = ; % choose the channel
figure;
ft_connectivityplot(cfg, pdc_1, pdc_2);

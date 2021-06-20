function analyzeFP_sleep
paths={'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla3',...
    'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla1',...
    'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla4',...
    'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla6',...
    'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\acc1',...
    'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\acc5'}; %these are all ACCp paths
gcampWake=zeros(size(paths));
gcampNrem=zeros(size(paths));
gcampRem=zeros(size(paths));

for iter=1:length(paths)
fullPath=paths{iter}; % enter the path of the block for analysis

eeg=load([fullPath,'\eeg']);eeg=eeg.eeg;
emg=load([fullPath,'\EMG']);emg=emg.emg;
scoring=load([fullPath '\SleepScore']);scoring=scoring.SleepScore;
normalizedGcamp=load([fullPath '\ZnormalizedGcamp']);normalizedGcamp=normalizedGcamp.normalizedGcamp;
% normalizedUv=load([fullPath '\ZnormalizedUv']);
% normalizedUv=normalizedUv.normalizedUv;

gcampWake(iter)=mean(normalizedGcamp(scoring=='W'));
gcampNrem(iter)=mean(normalizedGcamp(scoring=='N'));
gcampRem(iter)=mean(normalizedGcamp(scoring=='R'));
end

%%
f1= figure;
colors={[0.20,0.47,0.35],[0.64,0.08,0.18],[0.10,0.30,0.60];'REM','wake','NREM'};
barMat = [mean(gcampRem);mean(gcampWake);mean(gcampNrem)];
for loc=1:length(barMat)
    bar(loc,barMat(loc),'FaceColor',colors{1,loc});
    hold on
end
plot([1,2,3],[gcampRem;gcampWake;gcampNrem],'--ok')
set(gca, 'xtick' , 1:length(barMat));
set(gca, 'xticklabel' , {'REM','wake','NREM'});
ylabel('\Deltaf/f (STD)');

stats=friedman([gcampRem;gcampWake;gcampNrem]');
end

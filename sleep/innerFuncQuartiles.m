function [data,dffBdff,thetaBdff,SWBdff,powBdff]=innerFuncQuartiles(fullPath,channel,state)
% cut normalized_gcamp and eeg into 4 sec increments.
% each increment gets: average dff,power spectrum, average theta power,
% average SW power.
% correlation between sleep depth and ACC activation for each mouse

S=1000;

load([fullPath '\ZnormalizedGcamp.mat']);
Eeg = load([fullPath, '\eeg.mat']);
eeg = Eeg.eeg(channel,:);
scoring=load([fullPath '\SleepScore.mat']);

logical_score=(scoring.SleepScore==state); % Choosing the wanted state
beg=[1 find(diff(logical_score)>0)];
fin=[find(diff(logical_score)<0) numel(logical_score)];
if numel(beg)>numel(fin), beg=beg(2:end);end
window=4*S;
count=0;
for ii=1:length(beg)    % Finding the places to begin and end windows
    if fin(ii)-beg(ii)<window
        continue
    elseif fin(ii)-beg(ii)==window
        count=count+1;
        BEG(count)=beg(ii);FIN(count)=fin(ii);
    elseif fin(ii)-beg(ii)>window
        ind=0;
        while ind+window-1<=fin(ii)-beg(ii)
            count=count+1;
            BEG(count)=beg(ii)+ind;
            FIN(count)=beg(ii)+ind+window-1;
            ind=ind+window;
        end
    end
end

for iter=1:length(BEG)
    gcamp_seg=normalizedGcamp(BEG(iter):FIN(iter));
    eeg_seg=eeg(BEG(iter):FIN(iter));
    dff(iter)= mean(gcamp_seg);
    [F,pow(iter,:)]=myFFT(eeg_seg,S);
    pow(iter,:)=pow(iter,:)./sum(pow(iter,:));  % Normalize to sum to 1
    theta(iter) = (sum(pow(iter,F>=6 & F<=9))) * 100;
    SW(iter)=(sum(pow(iter,F<=4))) * 100;
end
data.dff=dff;
data.alpha=theta;
data.freq=F;
data.pow=pow;
data.SW=SW;

%% go from activation to SW and theta:
% divide dff data to quarters, align powers accordingly and average
[~,F]=sort(dff);
f1=F(1:round(numel(F)/4));
f2=F(round(numel(F)/4)+1:round(numel(F)*2/4));
f3=F(round(numel(F)*2/4)+1:round(numel(F)*3/4));
f4=F(round(numel(F)*3/4)+1:numel(F));

thetaBdff=[mean(theta(f1)),mean(theta(f2)),mean(theta(f3)),mean(theta(f4))];
SWBdff=[mean(SW(f1)),mean(SW(f2)),mean(SW(f3)),mean(SW(f4))];
dffBdff=[mean(dff(f1)),mean(dff(f2)),mean(dff(f3)),mean(dff(f4))];
%% go from ACC to power spectrum:
% divide dff data to quarters, align power accordingly and average

powBdff=[mean(pow(f1,:));mean(pow(f2,:));mean(pow(f3,:));mean(pow(f4,:))];

end
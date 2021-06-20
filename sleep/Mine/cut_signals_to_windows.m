function data=cut_signals_to_windows(fullPath,channel,state)
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


end
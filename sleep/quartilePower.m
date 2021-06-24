%%% CONNECTION BETWEEN GCAMP ACTIVATION AND POWER SPECTRUM
function quartilePower()
%% enter relevant data
paths={'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla3',...
        'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla1',...
        'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla4',...
        'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\cla6',...
        'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\acc1',...
        'C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\ACCp\acc5'};
order={'claustrum3','claustrum1','claustrum4','claustrum6','acc1','acc5'};  %these are ACC mice specifically. make sure the order is the same order as paths entered.
state='R';  %choose from {'W','N','R'}

%%

channels=load('C:\Users\owner\Google Drive\University\ElscLab\Code\Sleep Matlab\Open Source\sleep\claustrumEEGch.mat');     %notice path

data=cell(1,length(order));
thetaBdff=zeros(length(order),4);
SWBdff=zeros(length(order),4);
dffBdff=zeros(length(order),4);
powBdff=zeros(4,2000,6);

for iter=1:length(order)
    ID=order{iter};
    channel=channels.claustrumEEGch{'frontal',ID};
    fullPath=paths{iter};
    [data{1,iter},dffBdff(iter,:),thetaBdff(iter,:),SWBdff(iter,:),...
        powBdff(:,:,iter)]=innerFuncQuartiles(fullPath,channel,state);
end
 

%% LME
for it=1:6
    numEl=length(data{1,it}.dff);
    Q1=1:floor(numEl*1/4); Q2=(Q1(end)+1):floor(numEl*2/4); 
    Q3=(Q2(end)+1):floor(numEl*3/4); Q4=(Q3(end)+1):numEl;
    FREQ_t=data{1,it}.freq>=6 & data{1,it}.freq<=9;
    thetaBrand(it,1)=mean(mean(data{1,it}.pow(Q1,FREQ_t)));
    thetaBrand(it,2)=mean(mean(data{1,it}.pow(Q2,FREQ_t)));
    thetaBrand(it,3)=mean(mean(data{1,it}.pow(Q3,FREQ_t)));
    thetaBrand(it,4)=mean(mean(data{1,it}.pow(Q4,FREQ_t)));
    
    FREQ_sw=data{1,it}.freq<=4;
    swBrand(it,1)=mean(mean(data{1,it}.pow(Q1,FREQ_sw)));
    swBrand(it,2)=mean(mean(data{1,it}.pow(Q2,FREQ_sw)));
    swBrand(it,3)=mean(mean(data{1,it}.pow(Q3,FREQ_sw)));
    swBrand(it,4)=mean(mean(data{1,it}.pow(Q4,FREQ_sw)));
    
    FREQ_hi=data{1,it}.freq>9;
    hiBrand(it,1)=mean(mean(data{1,it}.pow(Q1,FREQ_hi)));
    hiBrand(it,2)=mean(mean(data{1,it}.pow(Q2,FREQ_hi)));
    hiBrand(it,3)=mean(mean(data{1,it}.pow(Q3,FREQ_hi)));
    hiBrand(it,4)=mean(mean(data{1,it}.pow(Q4,FREQ_hi)));
end
tbl=table(reshape(thetaBdff,numel(thetaBdff),1),reshape(SWBdff,numel(SWBdff),1),...
    [1,1,1,1,1,1,2,2,2,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4]',reshape(dffBdff,numel(dffBdff),1),...
    [1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6,1,2,3,4,5,6]',reshape(thetaBrand,numel(thetaBrand),1),...
    reshape(swBrand,numel(swBrand),1),reshape(hiBrand,numel(hiBrand),1),...
    'VariableNames',{'ThetaPower','SWPower','quartile','activity','mice','randTheta','randSW','randHi'});
tbl.quartile = ordinal(tbl.quartile);
tbl.mice = nominal(tbl.mice);
tbl.sw2t=tbl.SWPower./tbl.ThetaPower;

lmesw2t = fitlme(tbl,'sw2t~quartile+(1|mice)');
lmeAnova=anova(lmesw2t);
%% plots
s2t=SWBdff./thetaBdff;
dffF=figure;set(dffF,'outerposition',[2,42,958,954]);
plot(s2t','--ok');hold on;
plot([1 2 3 4],mean(s2t),'-k');
xlim([0.75 4.25])
ylabel('Slow to Theta Ratio');
set(gca, 'xticklabel' , {'quartile 1','quartile 2','quartile 3','quartile 4'});
xlabel('Activity Level')
box off
set(gca, 'xtick', [1,2,3,4]);
set(gca, 'fontsize',22);

quart1_pow=mean(powBdff(1,:,:),3).*100;
quart2_pow=mean(powBdff(2,:,:),3).*100;
quart3_pow=mean(powBdff(3,:,:),3).*100;
quart4_pow=mean(powBdff(4,:,:),3).*100;
quart1_sem=std(powBdff(1,:,:).*100,[],3)./sqrt(numel(order));
quart2_sem=std(powBdff(2,:,:).*100,[],3)./sqrt(numel(order));
quart3_sem=std(powBdff(3,:,:).*100,[],3)./sqrt(numel(order));
quart4_sem=std(powBdff(4,:,:).*100,[],3)./sqrt(numel(order));

powF1=figure;set(powF1,'outerposition',[2,42,958,954]);
plot(data{1,1}.freq,squeeze(quart1_pow),'b');
hold on
plot(data{1,1}.freq,squeeze(quart2_pow),'c');
plot(data{1,1}.freq,squeeze(quart3_pow),'g');
plot(data{1,1}.freq,squeeze(quart4_pow),'y');
legend('quartile1','quartile2','quartile3','quartile4')
ylabel('Relative Power (%)');
xlabel('Frequency (Hz)')
title('average')
xlim([3 12])
set(gca,'fontsize',22);
box off
end


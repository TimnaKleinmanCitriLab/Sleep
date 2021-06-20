function analyze_sleep_bbn
paths={'C:\claustrumSleep openSource\SEA\ACCp\acc1\rec1','C:\claustrumSleep openSource\SEA\ACCp\acc1\rec2',...
    'C:\claustrumSleep openSource\SEA\ACCp\acc5\rec1','C:\claustrumSleep openSource\SEA\ACCp\acc5\rec2',...
    'C:\claustrumSleep openSource\SEA\ACCp\cla1\rec1','C:\claustrumSleep openSource\SEA\ACCp\cla1\rec2',...
    'C:\claustrumSleep openSource\SEA\ACCp\cla3\rec1','C:\claustrumSleep openSource\SEA\ACCp\cla3\rec2',...
    'C:\claustrumSleep openSource\SEA\ACCp\cla4\rec1','C:\claustrumSleep openSource\SEA\ACCp\cla4\rec2',...
    'C:\claustrumSleep openSource\SEA\ACCp\cla6'};

time=-5:1/1000:15;
baselineTimes=[find(time==-2),find(time==0) ];
baseline_no=zeros(size(paths));
baseline_yes=zeros(size(paths));

for iter=1:length(paths)
    fullPath=paths{1,iter};
    N_no=load([fullPath '\FPbyBBNm_NREM__NO__AWAKENING__-1']);
    N_yesL=load([fullPath '\FPbyBBNm_NREMlongAwakening-1' ]);
    baseline_no(iter)=mean(mean(N_no.FPbyBBN.gcamp(:,baselineTimes(1):baselineTimes(2)),2));
    baseline_yes(iter)=mean(mean(N_yesL.FPbyBBN.gcamp(:,baselineTimes(1):baselineTimes(2)),2));
end

f=figure;
bar([mean(baseline_no) mean(baseline_yes)],'EdgeColor','k','FaceColor',[0.7 0.7 0.7]);
hold on
plot([1 2],[baseline_no;baseline_yes],'--ok');
set(gca, 'xticklabel' , {'Maintained Sleep', 'Awakening'});
ylabel('Baseline Activation \Deltaf/f');

[p,h]=signrank(baseline_no,baseline_yes);
end
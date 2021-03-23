subplot = @(m,n,p)subtightplot(m,n,p,[0.05 0.05], [0.05 0.05], [0.05 0.05]);

global plottingcolor
plottingcolor = 'r';

subplot(2,3,1);
plot(bayes0.ObjectiveMinimumTrace)
hold on

ob_std = movstd(bayes0.ObjectiveTrace, 100);
inBetween = [[smooth(bayes0.ObjectiveTrace,100)+ob_std].',...
    [flipud(smooth(bayes0.ObjectiveTrace,100)-ob_std)].'];
fill([1:length(ob_std), fliplr(1:length(ob_std))], inBetween,...
    [0.7 0.7 0.7], 'EdgeColor', 'None', 'FaceAlpha', 0.4);

plot(smooth(bayes0.ObjectiveTrace,100));
xlim([0 700]); ylim([0 500]);
title('0^o: Task ii');
box off

subplot(2,3,2);
plot(bayes90.ObjectiveMinimumTrace)
hold on

ob_std = movstd(bayes90.ObjectiveTrace, 100);
inBetween = [[smooth(bayes90.ObjectiveTrace,100)+ob_std].',...
    [flipud(smooth(bayes90.ObjectiveTrace,100)-ob_std)].'];
fill([1:length(ob_std), fliplr(1:length(ob_std))], inBetween,...
    [0.7 0.7 0.7], 'EdgeColor', 'None', 'FaceAlpha', 0.4);

plot(smooth(bayes90.ObjectiveTrace,100));
xlim([0 700]); ylim([0 500]);
title('90^o: Task iv');
box off
set(gca,'YTick', []);

subplot(2,3,3);
plot(bayes180.ObjectiveMinimumTrace)
hold on

ob_std = movstd(bayes180.ObjectiveTrace, 100);
inBetween = [[smooth(bayes180.ObjectiveTrace,100)+ob_std].',...
    [flipud(smooth(bayes180.ObjectiveTrace,100)-ob_std)].'];
fill([1:length(ob_std), fliplr(1:length(ob_std))], inBetween,...
    [0.7 0.7 0.7], 'EdgeColor', 'None', 'FaceAlpha', 0.4);

plot(smooth(bayes180.ObjectiveTrace,100));
xlim([0 700]); ylim([0 500]);
title('180^o: Task v');

box off
set(gca,'YTick', []);

subplot(2,3,4);
stringbase = 'C:\Users\dshar\Downloads\atest';
VisualiseBayesian


subplot(2,3,5);
stringbase = 'C:\Users\dshar\Downloads\atest';
VisualiseBayesian

subplot(2,3,6);
stringbase = 'C:\Users\dshar\Downloads\Bayes180_3_test';
VisualiseBayesian

%sgtitle('Bayesian Optimisations');
set(gcf, 'Color', 'w');
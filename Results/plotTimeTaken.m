% Circle times for all tasks
% N.B. ONLY SUCCESSFUL COMPLETIONS OF THE TASKS ARE PLOTTED HERE
% I.E. THOSE WHICH MAKE IT THROUGH IV & V'S BIFURCATION POINT 

%% angles

times0 = [8.6891; 8.6367; 8.9153; 9.0223; 9.1064];
times90 = [18.5663; 19.4364; 18.4006; 17.9603; 17.6735];
%times180 = [49.4989; 59.4412; 38.7110; 45.6754; 120.0000];
times180 = [49.4989; 59.4412; 38.7110; 45.6754];

timesii = [];
for i = 1:10
    timesii = [timesii; Circle20.Paths(2, i).timevec(end)];
end
timesiv = [];
for i = [1 7 10]
    timesiv = [timesiv; Circle20.Paths(4, i).timevec(end)];
end
timesv = [];
for i = [1 4 6 8 10]
    timesv = [timesv; Circle20.Paths(5, i).timevec(end)];
end

figure();
%subplot(1,2,1);
plot(nan,nan, 'color', 1/255*[117 112 179], 'LineWidth', 2);
hold on
plot(nan,nan, 'color', 1/255*[217 95 2], 'LineWidth', 2);
erroradd(times0, times90, times180, 1/255*[117 112 179]);
erroradd(timesii, timesiv, timesv, 1/255*[217 95 2]);
box off
set(gca, 'LineWidth', 2, 'FontSize', 15);
%set(gcf, 'Position', [489   469   776   390]);
xlabel('\theta_{target} (^o)');
ylabel('Completion Time (s)')
legend({'BO';'DDPG (ii, iv, v)'})
%title('Changing \theta_{target}')

set(gcf, 'Position', 1000*[0.1210    0.5082    0.586    0.3508]);

%% circles
figure();
plot(nan,nan, 'color', 1/255*[217 95 2], 'LineWidth', 2);
hold on
plot(nan,nan, 'color', 1/255*[117 112 179], 'LineWidth', 2);

for task = 1:2
    rad8 = zeros(5,1);
    rad46 = zeros(5,1);
    rad72 = zeros(5,1);
    rad20 = zeros(10,1);
    for i = 1:5
        rad8(i) = Circle8.Paths(task,i).timevec(end);
        rad46(i) = Circle46.Paths(task,i).timevec(end);
        rad72(i) = Circle72.Paths(task,i).timevec(end);
    end
    for i = 1:10
        rad20(i) = Circle20.Paths(task,i).timevec(end);
    end


    %subplot(1,2,2);
    if task == 1
        erroradd2(rad8, rad20, rad46, rad72, 1/255*[217 95 2]);
    else
        erroradd2(rad8, rad20, rad46, rad72, 1/255*[117 112 179]);
    end
end
box off
set(gca, 'FontSize', 15, 'LineWidth', 2);
%set(gcf, 'Position', [489   469   776   390]);
xlabel('Circle Diameter (mm)')
ylabel('Completion Time (s)');
legend({'DDPG: Task i'; 'DDPG: Task ii'})
%title('Changing d_{object}')

set(gcf, 'Position', 1000*[0.707    0.5082    0.586    0.3508]);

%% Circle times for all tasks
figure();

task1 = zeros(4,5);
task2 = zeros(4,5);
task3 = zeros(4,5);
task4 = zeros(4,5);
task5 = zeros(4,5);

for i = 1:5
    task1(:,i) = [Circle8.Paths(1,i).timevec(end); Circle20.Paths(1,i).timevec(end);...
        Circle46.Paths(1,i).timevec(end); Circle72.Paths(1,i).timevec(end)];
    task2(:,i) = [Circle8.Paths(2,i).timevec(end); Circle20.Paths(2,i).timevec(end);...
        Circle46.Paths(2,i).timevec(end); Circle72.Paths(2,i).timevec(end)];
    task3(:,i) = [Circle8.Paths(3,i).timevec(end); Circle20.Paths(3,i).timevec(end);...
        Circle46.Paths(3,i).timevec(end); Circle72.Paths(3,i).timevec(end)];
    task4(:,i) = [Circle8.Paths(4,i).timevec(end); Circle20.Paths(4,i).timevec(end);...
        Circle46.Paths(4,i).timevec(end); Circle72.Paths(4,i).timevec(end)];
    task5(:,i) = [Circle8.Paths(5,i).timevec(end); Circle20.Paths(5,i).timevec(end);...
        Circle46.Paths(5,i).timevec(end); Circle72.Paths(5,i).timevec(end)];
end

radii = [8; 20; 46; 72];

plot(radii, meannew(task1.'))
hold on
plot(radii, meannew(task2.'))
plot(radii, meannew(task3.'))
plot(radii, meannew(task4.'))
plot(radii, meannew(task5.'))

legend({'Task i'; 'Task ii'; 'Task iii'; 'Task iv'; 'Task v'})
xlabel('Circle Radius (mm)');
ylabel('Completion Time (s)');

%% functions

function erroradd(times0, times90, times180, col)
    [neg0, pos0] = negposerror(times0);
    [neg90, pos90] = negposerror(times90);
    [neg180, pos180] = negposerror(times180);
    
    errorbar([0 90 180],[mean(times0); mean(times90); mean(times180)],...
        [neg0; neg90; neg180], [pos0; pos90; pos180], 'LineWidth', 2,...
        'Color', 'k', 'LineStyle', 'none');
    plot([0 90 180],[mean(times0); mean(times90); mean(times180)],...
        'LineWidth', 2, 'Color', col);
end

function erroradd2(times8, times20, times46, times72, col)
    [neg8, pos8] = negposerror(times8);
    [neg20, pos20] = negposerror(times20);
    [neg46, pos46] = negposerror(times46);
    [neg72, pos72] = negposerror(times72);
    
    plot([8 20 46 72],[mean(times8); mean(times20); mean(times46); mean(times72)],...
        'LineWidth', 2, 'Color', col);
    hold on
    errorbar([8 20 46 72],[mean(times8); mean(times20); mean(times46); mean(times72)],...
        [neg8; neg20; neg46; neg72], [pos8; pos20; pos46; pos72], 'LineWidth', 2,...
        'Color', 'k', 'LineStyle', 'none');
end

function [negerror, poserror] = negposerror(times)
    negerror = 0;
    poserror = 0;
    for i = 1:length(times)
        negerror = min(negerror, times(i) - mean(times));
        poserror = max(poserror, times(i) - mean(times));
    end
end

function valueout = meannew(arrayin)
    for i = 1:size(arrayin, 2)
        values = [];
        for j = 1:size(arrayin, 1)
            if arrayin(j, i) < 150
                values = [values; arrayin(j, i)];
            end
        end
        if isempty(values)
            valueout(1, i) = NaN;
        else
            valueout(1, i) = mean(values);
        end
    end
end



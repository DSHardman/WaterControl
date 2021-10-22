%% plot task graphs

figure();
numbers = [1 2 3 4.4 5.6];

for task = 1:5
    subplot(2,3,numbers(task))
    rad8 = zeros(10,1);
    rad46 = zeros(10,1);
    rad72 = zeros(10,1);
    %rad20 = zeros(45,1);
    rad20 = zeros(10,1);
    pairs = nchoosek(1:5, 2);
    for i = 1:10
        rad8(i) = Circle8.warp(task, pairs(i,1), pairs(i,2));
        rad20(i) = Circle20.warp(task, pairs(i,1), pairs(i,2));
        rad46(i) = Circle46.warp(task, pairs(i,1), pairs(i,2));
        rad72(i) = Circle72.warp(4, pairs(i,1), pairs(i,2));
    end
    % pairs = nchoosek(1:10, 2);
    % for i = 1:45
    %     rad20(i) = Circle20.lyapexp(1, pairs(i,1), pairs(i,2));
    % end

    erroradd2(rad8, rad20, rad46, rad72, 1/255*[217 95 2]);
    box off
    set(gca, 'FontSize', 15, 'LineWidth', 2);
    %set(gcf, 'Position', [489   469   776   390]);
    xlabel('Circle Diameter (mm)')
    ylim([0 15000])
    ylabel('Path Variation (mm)');
    %legend({'DDPG'}, 'Location', 'se')
    %title('Changing d_{object}')
    tasks = ["i"; "ii"; "iii"; "iv"; "v"];
    title('Task ' + tasks(task));
end

set(gcf, 'Position', 1000*[0.2826    0.2538    1.0280    0.6024], 'Color', 'w');

%% bayesian cases

figure();

pairs = nchoosek(1:5, 2);
vals0 = zeros(10,1);
vals90 = zeros(10,1);
vals180 = zeros(10,1);

% 0 degree
stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Bayesian\0\Bayes0_3_';
for i = 1:10
    load(stringbase + string(pairs(i,1)) + '.mat'); path1 = results;
    load(stringbase + string(pairs(i,2)) + '.mat'); path2 = results;
    
    
    timesteps = 500;
    times1 = 0:path1(1,end)/(timesteps-1):path1(1,end);
    times2 = 0:path2(1,end)/(timesteps-1):path2(1,end);
    path1 = interp1(path1(:,1), path1(:,2), times1);
    path2 = interp1(path2(:,1), path2(:,2), times2);

    path1 = path1(~isnan(path1));
    path2 = path2(~isnan(path2));
    
    vals0(i) = dtw(path1, path2);
end


% 90 degree
stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Bayesian\90\Bayes90_3_';
for i = 1:10
    load(stringbase + string(pairs(i,1)) + '.mat'); path1 = results;
    load(stringbase + string(pairs(i,2)) + '.mat'); path2 = results;
    
    
    timesteps = 500;
    times1 = 0:path1(1,end)/(timesteps-1):path1(1,end);
    times2 = 0:path2(1,end)/(timesteps-1):path2(1,end);
    path1 = interp1(path1(:,1), path1(:,2), times1);
    path2 = interp1(path2(:,1), path2(:,2), times2);

    path1 = path1(~isnan(path1));
    path2 = path2(~isnan(path2));
    
    vals90(i) = dtw(path1, path2);
end

% 180 degree
stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Bayesian\180\Bayes180_3_';
for i = 1:10
    load(stringbase + string(pairs(i,1)) + '.mat'); path1 = results;
    load(stringbase + string(pairs(i,2)) + '.mat'); path2 = results;
    
    
    timesteps = 500;
    times1 = 0:path1(1,end)/(timesteps-1):path1(1,end);
    times2 = 0:path2(1,end)/(timesteps-1):path2(1,end);
    path1 = interp1(path1(:,1), path1(:,2), times1);
    path2 = interp1(path2(:,1), path2(:,2), times2);

    path1 = path1(~isnan(path1));
    path2 = path2(~isnan(path2));
    
    vals180(i) = dtw(path1, path2);
end

erroradd(vals0, vals90, vals180, 1/255*[217 95 2]);
box off
set(gca, 'FontSize', 15, 'LineWidth', 2);
ylim([0 16000]);
xlim([-5 200]);
xlabel('Angle (^o)');
ylabel('Path Variation (mm)');

%% plot all shapes and tasks

figure();
subplot(2,4,1);
for i = 1:5
    Circle8.lyapexpall(i, i);
    hold on
    ylim([-1 1]);
end
title('Circle8');

subplot(2,4,2);
for i = 1:5
    Circle20.lyapexpall(i, i);
    hold on
    ylim([-1 1]);
end
title('Circle20');

subplot(2,4,3);
for i = 1:5
    Circle46.lyapexpall(i, i);
    hold on
    ylim([-1 1]);
end
title('Circle46');

subplot(2,4,4);
for i = 1:5
    Circle72.lyapexpall(i, i);
    hold on
    ylim([-1 1]);
end
title('Circle72');

subplot(2,4,5);
for i = 1:5
    Square22.lyapexpall(i, i);
    hold on
    ylim([-1 1]);
end
title('Square22');

subplot(2,4,6);
for i = 1:5
    Square35.lyapexpall(i, i);
    hold on
    ylim([-1 1]);
end
title('Square35');

subplot(2,4,7);
for i = 1:5
    Quatrefoil.lyapexpall(i, i);
    hold on
    ylim([-1 1]);
end
title('Quatrefoil');

%% functions
function erroradd(times0, times90, times180, col)
    [neg0, pos0] = negposerror(times0);
    [neg90, pos90] = negposerror(times90);
    [neg180, pos180] = negposerror(times180);
    
    errorbar([0 90 180],[mean(times0); mean(times90); mean(times180)],...
        [neg0; neg90; neg180], [pos0; pos90; pos180], 'LineWidth', 2,...
        'Color', 'k', 'LineStyle', 'none');
    hold on
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
ifinal = Circle20.Paths(1,:);
iifinal = Circle20.Paths(2,:);
iiifinal = Circle20.Paths(3,:);
ivfinal = Circle20.Paths(4,:);
vfinal = Circle20.Paths(5,:);

proximities = zeros(5,10);
for i = 1:10
    proximities(1,i) = ifinal(i).proximity(-0.3*pi);
    proximities(2,i) = iifinal(i).proximity(-pi/2);
    proximities(3,i) = iiifinal(i).proximity(-0.9*pi);
    proximities(4,i) = ivfinal(i).proximity(-pi/2);
    proximities(5,i) = vfinal(i).proximity(-pi);
end

proximities = proximities - 10;  % measure the gap between object & container edges

figure();
boxplot(proximities.', 'Labels', {'i','ii', 'iii', 'iv', 'v'},...
    'Whisker', 10, 'Colors', [0 0 0]);

%xlabel('Task')
%ylabel('d_{min} (mm)');

set(gca, 'FontSize', 15);
set(gcf, 'Position', [341.0000  453.0000  862.4000  242.4000]);
box off

ylim([0 220]);

%% bayesian case
proximities = zeros(3,5);

stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Bayesian\0\Bayes0_3_';

for i = 1:5
    load(stringbase + string(i) + '.mat');
    [x, y] = pol2cart(results(:,3), min(results(:,2),165));
    theta = -0 + pi/4;        
    [xtarget,ytarget] = pol2cart(theta,175);
    
    d = 1000;
    for j = 1:length(x)
        d = min(d, norm([xtarget; ytarget]-[x(j); y(j)]));
    end
    proximities(1,i) = d;
end

stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Bayesian\90\Bayes90_3_';

for i = 1:5
    load(stringbase + string(i) + '.mat');
    [x, y] = pol2cart(results(:,3), min(results(:,2),165));
    theta = -(-pi/2) + pi/4;        
    [xtarget,ytarget] = pol2cart(theta,175);
    
    d = 1000;
    for j = 1:length(x)
        d = min(d, norm([xtarget; ytarget]-[x(j); y(j)]));
    end
    proximities(2,i) = d;
end

stringbase = 'C:\Users\dshar\OneDrive - University of Cambridge\Documents\PhD\Water Control\Results\Bayesian\180\Bayes180_3_';

for i = 1:5
    load(stringbase + string(i) + '.mat');
    [x, y] = pol2cart(results(:,3), min(results(:,2),165));
    theta = -(pi) + pi/4;        
    [xtarget,ytarget] = pol2cart(theta,175);
    
    d = 1000;
    for j = 1:length(x)
        d = min(d, norm([xtarget; ytarget]-[x(j); y(j)]));
    end
    proximities(3,i) = d;
end

proximities = proximities - 10;  % measure the gap between object & container edges

figure();
boxplot(proximities.', 'Labels', {'0','90', '180'},...
    'Whisker', 10, 'Colors', [0 0 0], 'Widths', 0.4);

%xlabel('Angle (degrees)')
%ylabel('d_{min} (mm)');

set(gca, 'FontSize', 15);
set(gcf, 'Position', [501.8000  360.2000  654.4000  225.6000]);
box off

ylim([0 60]);
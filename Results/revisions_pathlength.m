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
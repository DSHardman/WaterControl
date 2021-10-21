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
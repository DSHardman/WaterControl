% Radar figure in paper

% Problems with transparency when saving as vector file: png used

subplot = @(m,n,p)subtightplot(m,n,p,[0.01 0.05], [0.05 0.1], [0.01 0.01]);
save = 0;

figure('Position', 1000*[0.1186 0.3874 1.1968 0.4716]);

fs = 16; %font size

subplot(1,3,1);
radar([-3/13; -1; -1], bayes0, saved_agent, saved_agent2, fs, 0);
th = title('0^o', 'FontSize', fs);
titlePos = get(th , 'position');
titlePos(2) = titlePos(2)+0.05;
set(th , 'position' , titlePos);
hLeg = legend('1', '2', 'Location', 'southoutside', 'FontSize', fs,...
    'Orientation', 'horizontal');
set(hLeg,'visible','off');

subplot(1,3,2);
radar([-3/13; -1; 0], bayes90, saved_agent, saved_agent2, fs, 1);
th = title('90^o', 'FontSize', fs);
titlePos = get(th , 'position');
titlePos(2) = titlePos(2)+0.05;
set(th , 'position' , titlePos);


hLeg = legend('1', '2', 'Location', 'southoutside', 'FontSize', fs,...
    'Orientation', 'horizontal');
set(hLeg,'visible','off');

subplot(1,3,3);
radar([-3/13; -1; 1], bayes180, saved_agent, saved_agent2, fs, 0);
th = title('180^o', 'FontSize', fs);
titlePos = get(th , 'position');
titlePos(2) = titlePos(2)+0.05;
set(th , 'position' , titlePos);
legend('Trained Agent b', 'Bayesian Optimisation',...
    'Location', 'southoutside', 'Orientation', 'horizontal',...
    'FontSize', fs);
legend boxoff

if save
    exportgraphics(gcf, "AutosavedFigures/"+...
        "spiderplots"+".eps", 'ContentType',...
        'vector', 'BackgroundColor', 'none');
end

function radar(state, bayesian, saved_agent, saved_agent2, fs, labels)
    [~,ind] = sort(bayesian.ObjectiveTrace, 'ascend');
    %secondactions = cell2mat(saved_agent2.getAction(state)).';
    if labels
        %{
    spider_plot([secondactions(1:11);...
        cell2mat(saved_agent.getAction(state)).';...
        table2array(bayesian.XTrace(ind(1),:))],...
        'FillOption', 'on', 'AxesDisplay', 'one',...
        'AxesLimits', [-ones(1,11); ones(1,11)],...
        'AxesLabelsEdge', 'none', 'Marker', '.', 'MarkerSize', 20,...
        'Color', 1/255*[50 50 50; 217 95 25; 100 50 200], 'LabelFontSize', fs,...
        'AxesLabels', {'A_x' 'f_x' '\phi_x' 'A_y' 'f_y' '\phi_y'...
        'A_z' 'f_z' 'd' '\theta_x' '\theta_y'});
        %}
    spider_plot([cell2mat(saved_agent.getAction(state)).';...
        table2array(bayesian.XTrace(ind(1),:))],...
        'FillOption', 'on', 'AxesDisplay', 'one',...
        'AxesLimits', [-ones(1,11); ones(1,11)],...
        'AxesLabelsEdge', 'none', 'Marker', '.', 'MarkerSize', 20,...
        'Color', 1/255*[217 95 25; 100 50 200], 'LabelFontSize', fs,...
        'AxesLabels', {'A_x' 'f_x' '\phi_x' 'A_y' 'f_y' '\phi_y'...
        'A_z' 'f_z' 'd' '\theta_x' '\theta_y'});
    else
    spider_plot([cell2mat(saved_agent.getAction(state)).';...
        table2array(bayesian.XTrace(ind(1),:))],...
        'FillOption', 'on', 'AxesDisplay', 'one',...
        'AxesLimits', [-ones(1,11); ones(1,11)],...
        'AxesLabels', 'none', 'Marker', '.', 'MarkerSize', 20,...
        'Color', 1/255*[217 95 25; 100 50 200]);
    end
end
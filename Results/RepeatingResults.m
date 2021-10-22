% Class to deal with multiple repetitions of the same tests
% Used heavily in Agent 5000's testing results

classdef RepeatingResults < handle
    properties
        n
        m
        Actions
        States
        Rewards
        Predictions
        Paths
    end
    methods
        function obj = RepeatingResults(Actions,States,Rewards,Predictions, pathfolder)
            %Constructor
            obj.Paths = TrackedPath.empty;
            assert(isequal(size(Actions,1), size(States,1), size(Rewards,1), size(Predictions,1)));
            obj.n = size(Actions,1);
            obj.m = size(Rewards,2);
            obj.Actions = Actions;
            obj.States = States;
            obj.Rewards = Rewards;
            obj.Predictions = Predictions;
            
            current = pwd;
            cd(pathfolder);
            contents = dir;
            cd(current);
            for i = 3:size(contents,1)
                trackedpath = TrackedPath(strcat(pathfolder,'\',contents(i).name));
                obj.Paths(floor((i-3)/obj.m)+1,mod((i-3),obj.m)+1) = trackedpath;
            end
            
        end
        
        function plotRewards(obj)
            plot(obj.Predictions, 'Color','r');
            hold on
            for i = 1:obj.m
                plot(obj.Rewards(:,i), 'Color', 'k');
            end
            xlabel('Attempt')
            ylabel('Reward')
            legend({'Predicted';'Actual'});
            ylim([-2 3]);
        end
        
       function [rew_mu, rew_sigma, pred_mu, pred_sigma,...
            err_mu, err_sigma, len_mu, len_sigma] = stats(obj)
            rew_mu = mean(obj.Rewards, 'all');
            rew_sigma = std(obj.Rewards(:));
            pred_mu = mean(obj.Predictions, 'all');
            pred_sigma = std(obj.Predictions(:));
            err_mu = mean(obj.Predictions - obj.Rewards, 'all');
            pr = obj.Predictions*ones(1,obj.m);
            err_sigma = std(pr(:) - obj.Rewards(:));
            lengths = zeros(obj.n,obj.m);
            for i = 1:obj.n
                for j = 1:obj.m
                    lengths(i,j) = obj.Paths(i,j).getLength();
                end
            end
            len_mu = mean(lengths, 'all');
            len_sigma = std(lengths(:));
            
        end
        
        function plotPath(obj, num1, num2)
            obj.Paths(num1,num2).plotPath;
            [x, y] = pol2cart(pi/2*(obj.States(num1,(num2)*3)+1) + pi/4, 165);
            viscircles([x y], 5, 'Color', 'b')
            [x, y] = pol2cart(pi/2*(obj.States(num1,(num2-1)*3+2)+1) + pi/4, 65*(obj.States(num1,(num2-1)*3+1)+1) + 40);
            viscircles([x y], 5, 'Color', 'k')
            title(strcat("Test ", string(num1), " Repetition ", string(num2)));
        end
        
        function allPaths(obj)
            for i = 1:obj.n
                for j = 1:obj.m
                    obj.plotPath(i,j);
                    pause()
                end
            end
        end
        
        function plotRepetitions(obj, num)
            for i = 1:10
                subplot(2,5,i);
                obj.plotPath(num,i);
            end
        end
        
        function plotOverlay(obj, num, visible, savename)
            global plottingcolor
            %{
            for i = 1:4
                theta = (i-1)*pi/4;
                viscircles([0 0], i*165/4, 'Color', [0.7 0.7 0.7], 'LineWidth', 0.2);
                line([-165*cos(theta) 165*cos(theta)], [165*sin(theta) -165*sin(theta)], 'Color', [0.7 0.7 0.7], 'LineWidth', 0.2);
                hold on
            end
            %}
            %viscircles([0 0], 165, 'Color', 'k', 'LineWidth', 1);
            hold on

            %[x, y] = pol2cart(pi/2*(obj.States(num,3)+1) + pi/4, 165);
            [x, y] = pol2cart(-(pi/2*(obj.States(num,3)+1)), 165);
            scatter(x, y, 30, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', 'w');
            %h = viscircles([x y], 7, 'Color', 'none');
            %fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'w');
            
            for i = 1:obj.m
                    obj.Paths(num,i).plotPath(1);
                    hold on
            end
            
            [x, y] = pol2cart(-(pi/2*(obj.States(num,2)+1)), 65*(obj.States(num,1)+1)+40);
            scatter(x, y, 30, 'MarkerEdgeColor', 'w', 'MarkerFaceColor', plottingcolor);

            %[x, y] = pol2cart(pi/2*(obj.States(num,2)+1) + pi/4, 65*(obj.States(num1,1)+1) + 40);
            %[x, y] = pol2cart(-(pi/2*(obj.States(num,2)+1)), 65*(obj.States(num,1)+1) + 40);

            %rectangle('Position',[x-6 y-6 12 12], 'FaceColor','k','EdgeColor','w')
            %scatter(x, y, 150, 'k', 'x', 'LineWidth', 3)
            %h = viscircles([x y], 5, 'Color', 'k');
            %fill(h.Children(1).XData(1:end-1), h.Children(1).YData(1:end-1), 'k');

            axis square
            set(gca,'XColor', 'none','YColor','none')
            %set(gca, 'Color', 'None');
            %set(gcf, 'Color', 'None');
            if nargin == 4
                exportgraphics(gcf, "AutosavedFigures/"+...
                    savename+string(num)+".eps", 'ContentType',...
                    'vector', 'BackgroundColor', 'none');
            end
            if ~visible
                close
            end
        end
        
        function plotOverlays(obj, visible, savename)
            figure();
            for i = 1:obj.n
                if nargin == 3
                    obj.plotOverlay(i, visible, savename);
                else
                    obj.plotOverlay(i, visible);
                end
            end
        end
        
        function expout = lyapexp(obj, task, n1, n2)
        % plot separation between two paths (to calculate lyapunov
        % exponent)
        
        seconds = 2; % Consider first few seconds only
        
         finaltime = min([obj.Paths(task,n1).timevec(end),...
             obj.Paths(task,n2).timevec(end), seconds]);
        
        %finaltime = 5;
        
        timesteps = 50;
        times = 0:finaltime/(timesteps-1):finaltime;
        delta = zeros(size(times));
        
        for i = 1:timesteps
            pos1 = [
                interp1(obj.Paths(task,n1).timevec,...
                obj.Paths(task,n1).xvec,times(i));...
                interp1(obj.Paths(task,n1).timevec,...
                obj.Paths(task,n1).yvec,times(i));
                interp1(obj.Paths(task, n1).timevec(2:end),...
                diff(obj.Paths(task,n1).xvec), times(i));
                interp1(obj.Paths(task, n1).timevec(2:end),...
                diff(obj.Paths(task,n1).yvec), times(i));
                ];
            
            pos2 = [
                interp1(obj.Paths(task,n2).timevec,...
                obj.Paths(task,n2).xvec,times(i));...
                interp1(obj.Paths(task,n2).timevec,...
                obj.Paths(task,n2).yvec,times(i));
                interp1(obj.Paths(task, n2).timevec(2:end),...
                diff(obj.Paths(task,n2).xvec), times(i));
                interp1(obj.Paths(task, n2).timevec(2:end),...
                diff(obj.Paths(task,n2).yvec), times(i));
                ];
            
            delta(i) = norm(pos1 - pos2);
        end
        
        %plot(times, log(delta./delta(find(~isnan(delta), 1)))./times);
        
        %start = find(~isnan(delta), 1);
        
        %delta = delta./delta(start); %normalise deltas by first non-nan value
      
%         sum = 0;
%         for i = start:length(delta)
%             sum = sum + log(delta(i));
%         end

        expout = log(delta(end))/(times(end));
        
        %expout = sum/(times(end)*(length(delta)-start));
        
        % This section found a least squares linear fit in the log plot
        %         A = [times; ones(size(times))].';
        %         firstvalue = find(~isnan(delta), 1);
        %         linearfit = A(firstvalue:end,:)\(log(delta(firstvalue:end)).');
        %         expout = linearfit(1);
        end
        
        
        function warpeddistance = warp(obj, task, n1, n2)
            timesteps = 500;
            times1 = 0:obj.Paths(task,n1).timevec(end)/...
                (timesteps-1):obj.Paths(task,n1).timevec(end);
            times2 = 0:obj.Paths(task,n2).timevec(end)/...
                (timesteps-1):obj.Paths(task,n2).timevec(end);
            path1 = interp1(obj.Paths(task,n1).timevec,...
                obj.Paths(task,n1).radiusvec, times1);
            path2 = interp1(obj.Paths(task,n2).timevec,...
                obj.Paths(task,n2).radiusvec, times2);
            
            path1 = path1(~isnan(path1));
            path2 = path2(~isnan(path2));

            warpeddistance = dtw(path1, path2);
        end
        
        function average = lyapexpall(obj, task, position)
            pairs = nchoosek(1:obj.m, 2);
            expsout = zeros(size(pairs,1), 1);
            for i = 1:size(pairs, 1)
                expsout(i) = obj.lyapexp(task, pairs(i,1), pairs(i,2));
                hold on
            end
            average = mean(expsout);
            scatter(position*ones(size(expsout)), expsout);
        end
        
        function average = warpall(obj, task, position)
            pairs = nchoosek(1:obj.m, 2);
            warpsout = zeros(size(pairs,1), 1);
            for i = 1:size(pairs, 1)
                warpsout(i) = obj.xcorr(task, pairs(i,1), pairs(i,2));
                hold on
            end
            average = mean(warpsout);
            scatter(position*ones(size(warpsout)), warpsout);
        end
        
        function scattertimes(obj, task, x)
            for i = 1:obj.m
                scatter(x, obj.Paths(task, i).timevec(end));
                hold on
            end
        end
       
        
        function removeEntry(obj,inds)
            for i = 1:length(inds)
                obj.Actions(inds(i),:) = [];
                obj.States(inds(i),:) = [];
                obj.Rewards(inds(i),:) = [];
                obj.Predictions(inds(i),:) = [];
                obj.Paths(inds(i),:) = [];
                obj.n = obj.n - 1;
                if i < length(inds)
                    for j = i+1:length(inds)
                        inds(j) = inds(j) - 1;
                    end
                end
            end
        end
    end
end


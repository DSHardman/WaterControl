% plot heatmaps of an agent's predictions
% if two agents are passed, heatmaps of the differences are plotted

function heatData(agent, agent2)
    
    subplot = @(m,n,p)subtightplot(m,n,p,[0.01 0.01], [0.01 0.05], [0.04 0.01]);

    rbins = 4;
    thetabins = 25;
    predictiondata = NaN(thetabins,thetabins,rbins,12);
    
    mcritic = agent.getCritic();
    if nargin == 2
        mcritic2 = agent2.getCritic();
    end
    
    heatvariables = ["Prediction" "A_x" "f_x" "\phi_x" "A_y" "f_y" "\phi_y" "A_z"...
    "f_z" "d" "\theta_x" "\theta_y"];

    for rplot = 1:rbins
        for tf = 1:thetabins
            for ts = 1:thetabins
                %state = [(2*(rplot-1)/(rbins-1))-1;...
                %    (2*(ts-1)/(thetabins-1))-1;...
                %    (2*(tf-1)/(thetabins-1))-1];
                state = [((12/13)*(rplot-1)/(rbins-1))-1;...
                    (2*(ts-1)/(thetabins-1))-1;...
                    (2*(tf-1)/(thetabins-1))-1];
                action = cell2mat(getAction(agent,state));
                if nargin == 2
                    action2 = getAction(agent2,state);
                    predictiondata(ts,tf,rplot,1) = ...
                        mcritic2.getValue(state, action2) - ...
                        mcritic.getValue(state, action);
                    for i = 1:11
                        predictiondata(ts,tf,rplot,i+1) = ...
                            action2(i) - action(i);
                    end
                else
                    %predictiondata(ts,tf,rplot,1) = mcritic.getValue(state, action);
                    predictiondata(ts,tf,rplot,1) = 1.15*mcritic.getValue(state, action);
                    for i = 1:11
                        predictiondata(ts,tf,rplot,i+1) = action(i);
                    end
                end
            end
        end
    end


    figure('Position', 1e3*[0.0882 0.4390 1.2344 0.4200]);
    for a = 1:12
        for i = 1:rbins
            subplot(rbins,12,(i-1)*12+a);
            heatmap(-1+(1/thetabins):(2/thetabins):1-(1/thetabins),...
                1-(1/thetabins):-(2/thetabins):-1+(1/thetabins),...
                flipud(predictiondata(:,:,i,a)),...
                'ColorbarVisible','off');
            %xlabel('\theta_{start}');
            %ylabel('\theta_{target}');
            if a == 1
                ylabel(strcat("r = ", string((2*(i-1)/(rbins-1))-1)))
            end
            if i == 1
                title(heatvariables(a))
            end
            colormap parula
            if a ~= 1
                if nargin == 2
                    caxis([-2, 2]);
                else
                    caxis([-1, 1]);
                end
            else
                if nargin == 2
                    %limits = 2*[min(predictiondata(:,:,:,1),[],'all'),...
                    %    max(predictiondata(:,:,:,1),[],'all')];
                    caxis([-1.25 2.25]);
                else
                    %limits = [min(predictiondata(:,:,:,1),[],'all'),...
                    %    max(predictiondata(:,:,:,1),[],'all')];
                    caxis([-1.25 2.25]);
                end
            end
            Ax = gca;
            Ax.XDisplayLabels = nan(size(Ax.XDisplayData));
            Ax.YDisplayLabels = nan(size(Ax.YDisplayData));
        end
    end
end
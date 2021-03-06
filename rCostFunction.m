% for preliminary bayesian tests, moving only radially

function cost = rCostFunction(x)

    global cam cameraParams worldcentre imagecentre
    
    params = Parameters(x.xamp, x.xfreq, x.xphase,...
        x.yamp, x.yfreq, x.yphase, x.zamp, x.zfreq,...
        x.depth, x.anglex, x.angley);
    

    TrackingPeriod = 120; %maximum time if target radius not reached
    r_target = 155;
    lambda = 5; % in cost function

    %saving
    sv = 1; %save
    filename = 'AttractorsOut3';
   

    %%
    % tracking view
    g = figure();

    %assume up to 5Hz tracking rate
    results = zeros(TrackingPeriod/0.2, 3);

    params.perform(TrackingPeriod); %start plunger moving

    n = 1;
    tic

    while toc < TrackingPeriod
        %radial position from image
        photo = TakePhoto(cam, cameraParams);
        set(0, 'currentfigure', g);
        [m_x, m_y] = SinglePosition(photo, imagecentre); %locate & draw circle
        text(50,50, string(toc),'color', 'r'); %display timer

        if ~isempty(m_x) %only update results if object could be found  

            %transform to world coordinates
            w_p  = pointsToWorld(cameraParams,...
                cameraParams.RotationMatrices(:,:,1),...
                cameraParams.TranslationVectors(1,:), [m_x m_y]);

            %relative to centre
            w_x = w_p(1) - worldcentre(1);
            w_y = w_p(2) - worldcentre(2);

            [theta, r] = cart2pol(w_x, w_y);

            results(n,:) = [toc r theta];
            if r >= r_target && n > 1 %exit when target radius reached
                system('taskkill /F /IM "python.exe" /T');
                fprintf('Edge Reached \n');
                break
            end
            n = n + 1;
        end

    end
    close(g)
    
    %pause(5)
    %ResetPosition() %reset floating object

    %remove any zeros remaining at end of results array
    results = results(find(results(:,1),1,'first'):find(results(:,1),1,'last'), :);
    
    %calculate cost function
    sum = 0;
    
    for i = 2:size(results,1)
        sum = sum + (results(i,3)-results(1,3))^2;
    end
    cost = results(end,1)...
        + lambda*(sqrt(sum/size(results,1)));
    if (size(results, 1) < 5) || cost < 0.4
        cost = 100;
    end
    
    %pause();
    pause(5);
    drawnow('update')
    
    %optionally save results
    if sv
        matname = strcat('C:\Users\David\Documents\PhD\Water Control\Motions\Bayesian\',filename,'.mat');
        save(matname, 'results');
    end
end
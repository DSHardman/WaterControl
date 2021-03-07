function Reward = reward3_IROS(State, results, outflag)

    if isempty(results)
        Reward = -1;
        return
    end
    
    %sigma_1 = pi/3;
    %sigma_2 = 50; %changed from attempts 3-4
    
    theta_des = pi/2*(State(3,1)+1) + pi/4;
    
    if outflag
        fprintf('Edge hit\n');
        %ang = mod(results(end,3),2*pi) - mod(theta_des,2*pi);
        %Reward = normpdf(ang,0,sigma_1)/normpdf(0,0,sigma_1);
    else
        fprintf('No edge hit\n');
        %Reward = -1;
    end

      
    mindist = NaN;
    [xdes, ydes] = pol2cart(theta_des,165);
    for i = 1:size(results,1)
        [xcurrent, ycurrent] = pol2cart(results(i,3),results(i,2));
        dist = sqrt((xdes-xcurrent)^2+(ydes-ycurrent)^2);
        mindist = min([mindist dist 3000]);
    end
    
    mindist = min([mindist 3000]);
    
    Reward = 3*exp(-3*mindist/165) - 1;
    %Reward = Reward + normpdf(mindist, 0, sigma_2)/normpdf(0,0,sigma_2);
    
    
    if isnan(Reward)
        Reward = -1.25;
    end
%     else
%         Reward = Reward + (60 - results(end,1))/240; %add small amount of time dependance
%     end
end
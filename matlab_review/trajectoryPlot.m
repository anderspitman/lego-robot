function trajectoryPlot(...
    initialVelocity, launchAngle, projectileWeight, dragCoefficient,...
    startTime, stopTime, timeStep)

    % preallocate the arrays
    pointsCount = fix((stopTime - startTime) / timeStep);
    xVals = zeros(1, pointsCount);
    yVals = zeros(1, pointsCount);
    
    time = startTime;
    index = 1;
    while time <= stopTime
        [x, y] = trajectory(initialVelocity, launchAngle,...
            projectileWeight, dragCoefficient, time);
        xVals(index) = x;
        yVals(index) = y;
        
        time = time + timeStep;
        index = index + 1;
    end
    
    axis([0 4500 0 1400]);
    plot(xVals, yVals);
    grid on;
    title('Aerodynamic Drag Influence on Projectile Trajectory');
    xlabel('X Coordinate (ft)');
    ylabel('Y Coordinate (ft)');

end


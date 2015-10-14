function trajectoryPlot(...
    initialVelocity, launchAngle, projectileWeight)

    stopTimes = [20.1 18.0 16.8 16.1 15.8];
    dragCoefficients = [0.0625 0.125 0.25 0.50 1.00];
    
    for i = 1:numel(stopTimes)
        startTime = 0;
        stopTime = stopTimes(i);
        timeStep = 0.1;
        dragCoefficient = dragCoefficients(i);
       
        hold on;
        trajectoryPlot(...
            initialVelocity, launchAngle, projectileWeight, dragCoefficient,...
            startTime, stopTime, timeStep);
    end

end


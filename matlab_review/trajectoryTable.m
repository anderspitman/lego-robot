function trajectoryTable(...
    initialVelocity, launchAngle, projectileWeight, dragCoefficient,...
    startTime, stopTime, timeStep)

    time = startTime;
    
    printHeader();
    
    while time <= stopTime
        [x, y, velocity] = trajectory(...
            initialVelocity, launchAngle, projectileWeight,...
            dragCoefficient, time);
        
        printLine(time, x, y, velocity);
        
        time = time + timeStep; 
    end

end

function printHeader()
    fprintf('%s    %s  %s    %s\n', 'Time', 'X Coordinate', 'Y Coordinate',...
        'Velocity');
    fprintf('-----------------------------------------------------------\n');
end

function printLine(time, x, y, velocity)

    fprintf('%4.1f    %7.2f    %6.2f    %7.2f\n', time, x, y, velocity);

end

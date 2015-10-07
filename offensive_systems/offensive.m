function [ initialVelocity, timeOfFlight ] = offensive...
    ( launchAngle, projectileWeight, dragCoefficient)

solveFunc = @(u) [xoff(u(1), launchAngle, projectileWeight,...
                       dragCoefficient, u(2)) - 5000
                  yoff(u(1), launchAngle, projectileWeight,...
                       dragCoefficient, u(2))];

VELOCITY_GUESS = 500;
TIME_GUESS = 20;
solution = fsolve(solveFunc, [VELOCITY_GUESS TIME_GUESS]);                               
initialVelocity = solution(1);
timeOfFlight = solution(2);
                                     
offensivePlot(initialVelocity, launchAngle, projectileWeight,...
              dragCoefficient, timeOfFlight);

end

function offensivePlot(initialVelocity, launchAngle, projectileWeight,...
                       dragCoefficient, timeOfFlight)
 
NUM_SAMPLES = 1000;
             
times = linspace(0, timeOfFlight, NUM_SAMPLES);

for i=1:numel(times)
    xvals(i) = xoff(initialVelocity, launchAngle, projectileWeight,...
                    dragCoefficient, times(i));
    yvals(i) = yoff(initialVelocity, launchAngle, projectileWeight,...
                    dragCoefficient, times(i));
end

plot(xvals, yvals);
grid on;
title('Trajectory of Projectile for Offensive System');
ylabel('Y Coordinate (ft)');
xlabel('X Coordinate (ft)');
axis([0 5000 0 1600]);

end
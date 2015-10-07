function [ y ] = yoff(initialVelocity, launchAngle, projectileWeight,...
                      dragCoefficient, timeOfFlight)
                     
earthGravity = 32.2;
projectileMass = projectileWeight / earthGravity;

drag = projectileMass / dragCoefficient;

y = 300 + (drag * ...
          (initialVelocity*sind(launchAngle) + drag*earthGravity) * ...
          (1 - exp(-(dragCoefficient / projectileMass) * timeOfFlight)))...
    - (drag*earthGravity*timeOfFlight);
                     
end

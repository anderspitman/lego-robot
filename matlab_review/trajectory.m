function [ x, y, velocity ] = trajectory(...
    initialVelocity, launchAngle, projectileWeight, dragCoefficient,...
    timeOfFlight)

    projectileMass = projectileWeight / EARTH_GRAVITY;
   
    dragExponent = exp(-(dragCoefficient / projectileMass) * timeOfFlight);
    drag = projectileMass / dragCoefficient;
    dragWithGravity = drag * EARTH_GRAVITY;
    
    initialVelocityX = initialVelocity * cosd(launchAngle);
    velocityX = initialVelocityX * dragExponent;
    
    initialVelocityY = initialVelocity * sind(launchAngle);
    velocityY = ((initialVelocityY + dragWithGravity) * dragExponent) -...
        dragWithGravity;
    
    velocity = sqrt((velocityX^2) + (velocityY^2));
    
    x = initialVelocityX * drag * (1 - dragExponent);
    
    y = drag * (initialVelocityY + dragWithGravity) * (1 - dragExponent) -...
        (dragWithGravity * timeOfFlight);

end

function [g] = EARTH_GRAVITY()
    g = 32.2;
end
clear
robot = LegoRobot();

speed = 60;
direction = -1;
% 
% robot.rotateAngleDegrees(90*direction, speed);
% robot.forwardCentimeters(10, speed);
% robot.rotateAngleDegrees(90*direction, speed);
% robot.forwardCentimeters(10, speed);
% robot.rotateAngleDegrees(90*direction, speed);
% robot.forwardCentimeters(10, speed);
% robot.rotateAngleDegrees(90*direction, speed);
% robot.forwardCentimeters(10, speed);

angle = 10;
robot.rotateAngleDegrees(angle*direction, speed);
robot.rotateAngleDegrees(angle*direction, speed);
robot.rotateAngleDegrees(angle*direction, speed);
robot.rotateAngleDegrees(angle*direction, speed);
direction = direction * -1;
robot.rotateAngleDegrees(angle*direction, speed);
robot.rotateAngleDegrees(angle*direction, speed);
robot.rotateAngleDegrees(angle*direction, speed);
robot.rotateAngleDegrees(angle*direction, speed);

% robot.forwardCentimeters(1, 30);
% robot.forwardCentimeters(1, 30);
% robot.forwardCentimeters(1, 30);
% robot.forwardCentimeters(1, 30);
% 
% robot.reverseCentimeters(1, 30);
% robot.reverseCentimeters(1, 30);
% robot.reverseCentimeters(1, 30);
% robot.reverseCentimeters(1, 30);
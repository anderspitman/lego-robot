clear
robot = LegoRobot();
brick = robot.getBrick();

robot.resetArm();

angle = 170;
power = 25;
timeSeconds = 3;

robot.rotateArmDegrees(angle, power);

%robot.resetArm();

robot.rotateArmDegrees(-angle, power);

% tic;
% while toc < timeSeconds
%     robot.resetArm();
% end
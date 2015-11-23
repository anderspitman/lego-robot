clear;
robot = LegoRobot();

while true
    state = robot.getPositionState();
    fprintf('state: %d\n', state);
    robot.forwardCentimeters(1);
    robot.reverseCentimeters(1);
end
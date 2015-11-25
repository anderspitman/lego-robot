clear

robot = Robot.makeRobot('lego');
lineFinder = LineFinder.makeLineFinder('basic', robot);
lineFollower = LineFollower.makeLineFollower('back_and_rotate', robot);

%lineFollower.setSide(LineFollower.SIDE_LEFT);
%lineFollower.followLineToInteraction();
%robot.allStop();

traverser = CourseTraverser(robot, lineFinder, lineFollower);
%traverser.traverse();
traverser.fineAlign();



% speed = 3;
% robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
% robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
% 
% distance = robot.getDistanceState();
% while distance > 20 || distance == -1
%     distance = robot.getDistanceState();
%     fprintf('Distance: %f\n', distance);
%     pause(.05);
% end

robot.allStop();

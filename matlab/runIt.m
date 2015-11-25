clear

robot = Robot.makeRobot('lego');
lineFinder = LineFinder.makeLineFinder('basic', robot);
lineFollower = LineFollower.makeLineFollower('back_and_rotate', robot);

%lineFollower.setSide(LineFollower.SIDE_LEFT);
%lineFollower.followLineToInteraction();
%robot.allStop();

traverser = CourseTraverser(robot, lineFinder, lineFollower);
traverser.traverse();
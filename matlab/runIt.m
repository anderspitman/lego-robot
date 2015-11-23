clear

robot = Robot.makeRobot('lego');
lineFinder = LineFinder.makeLineFinder('basic', robot);
lineFollower = LineFollower.makeLineFollower('back_and_rotate', robot);

traverser = CourseTraverser(robot, lineFinder, lineFollower);
traverser.traverse();
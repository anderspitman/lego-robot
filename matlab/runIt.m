clear

%traverser = CourseTraverser();
%traverser.traverse();

%robot = LegoRobot();
%lineFollower = CenterSensorLineFollower(robot);
%lineFollower.followLineToInteraction();

robot = LegoRobot();
lineFollower = FineLineFollower(robot);
lineFollower.followLineToInteraction();

%robot.forwardCentimetersDegrees(1, 20);
%robot.reverseCentimetersDegrees(1, 20);
clear

robot = LegoRobot();
lineFollower = LineFollower.makeLineFollower('back_and_rotate', robot);
traverser = CourseTraverser(robot, lineFollower);
%traverser.traverse();

% for i=1:10
%     result(i) = traverser.measureTimeToLine()
%     disp(result);
% end

%robot = LegoRobot();
%lineFollower = CenterSensorLineFollower(robot);
%lineFollower.followLineToInteraction();

%robot = LegoRobot();
%lineFollower = FineLineFollower(robot);
%ineFollower.followLineToInteraction();

%robot.forwardCentimetersDegrees(1, 20);
%robot.reverseCentimetersDegrees(1, 20);
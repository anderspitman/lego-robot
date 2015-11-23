classdef TestCourseTraverser < matlab.unittest.TestCase

    methods (Test)

        function testConstructor(obj)
            robot = MockRobot();
            lineFollower = MockLineFollower(robot);
            traverser = CourseTraverser(robot, lineFollower);
            traverser.traverse();
        end

        function testDoFirstInteraction(obj)
            robot = MockRobot();
            lineFollower = MockLineFollower(robot);
            traverser = CourseTraverser(robot, lineFollower);
            traverser.doFirstInteraction();
            obj.verifyEqual(robot.forwardCentimetersTimeCalledWith(),...
                            [20 35 40 20]);
            obj.verifyEqual(robot.rotateTimeCalledWith(), [-90 -120 -90]);
        end

    end
end

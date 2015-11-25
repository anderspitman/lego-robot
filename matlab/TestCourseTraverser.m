classdef TestCourseTraverser < matlab.unittest.TestCase

    methods (Test)

        function testMakeMethod(obj)
            traverser = CourseTraverser.makeCourseTraverser('mock');
            traverser.traverse();
        end

        function testDoFirstInteraction(obj)
            robot = MockRobot();
            lineFinder = MockLineFinder(robot);
            lineFollower = MockLineFollower(robot);
            traverser = CourseTraverser(robot, lineFinder, lineFollower);
            traverser.doFirstInteraction();
            obj.verifyEqual(robot.forwardCentimetersTimeCalledWith(),...
                            [20 35 40 20]);
            obj.verifyEqual(robot.rotateAngleTimeCalledWith(), [-90 -120 -90]);
        end

    end
end

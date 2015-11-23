classdef TestCourseTraverser < matlab.unittest.TestCase

    methods (Test)

        function testConstructor(obj)
            robot = MockRobot();
            lineFollower = MockLineFollower(robot);
            traverser = CourseTraverser(robot, lineFollower);
            traverser.traverse();
        end

    end
end

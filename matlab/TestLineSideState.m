classdef TestLineSideState < matlab.unittest.TestCase

    methods (Test)
        function testRotateAwayLeft(obj)
            robot = Robot.makeRobot('mock');
            state = LineLeft();
            state.rotateAwayFromLine(robot);
            obj.verifyEqual(robot.leftMotorReverseCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
        end

        function testArcTowardLineLeft(obj)
            robot = Robot.makeRobot('mock');
            state = LineLeft();
            state.arcTowardLine(robot);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 20);
        end
    end

end

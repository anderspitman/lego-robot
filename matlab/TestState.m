classdef TestState < matlab.unittest.TestCase
    methods (Test)
        function testConstructor(obj)
            robot = MockRobot();
            lineFollower = BackAndRotateLineFollower(robot);
            state = OnLine();

            robot.setPositionState(Robot.STATE_ON_LINE);
            state.iterate(lineFollower);
            obj.verifyEqual(robot.straightReverseCalledWith(), 60);
            obj.verifyEqual(robot.leftMotorReverseCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
        end
    end
end

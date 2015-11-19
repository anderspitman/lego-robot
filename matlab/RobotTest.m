classdef RobotTest < matlab.unittest.TestCase
    methods (Test)
        function testClassExists(testCase)
            robot = MockRobot();
        end

        function testPositionState(testCase)
            robot = MockRobot();
            testCase.verifyEqual(robot.getPositionState(), 1);
            testCase.verifyTrue(robot.getPositionStateCalled());
        end

        function testLeftMotorForward(testCase)
            robot = MockRobot();
            robot.leftMotorForward(50);
            testCase.verifyEqual(robot.leftMotorForwardCalledWith(), 50);
        end

        function testLeftMotorReverse(testCase)
            robot = MockRobot();
            robot.leftMotorReverse(25);
            testCase.verifyEqual(robot.leftMotorReverseCalledWith(), 25);
        end

        function testRightMotorForward(testCase)
            robot = MockRobot();
            robot.rightMotorForward(50);
            testCase.verifyEqual(robot.rightMotorForwardCalledWith(), 50);
        end

        function testRightMotorReverse(testCase)
            robot = MockRobot();
            robot.rightMotorReverse(25);
            testCase.verifyEqual(robot.rightMotorReverseCalledWith(), 25);
        end

        function testConstants(testCase)
            robot = MockRobot();
            testCase.verifyEqual(robot.COLOR_BLUE, 1);
        end
    end
end


classdef LineFollowerTests < matlab.unittest.TestCase
    properties (Constant)
        DRIVE_POWER = 30;
        IDLE_POWER = 20;
    end

    methods
        function verifyCurvedLeft(testCase, robot)
            testCase.verifyEqual(robot.leftMotorReverseCalledWith(),...
                                 testCase.IDLE_POWER);
            testCase.verifyEqual(robot.rightMotorForwardCalledWith(),...
                                 testCase.DRIVE_POWER);
        end
        function verifyCurvedRight(testCase, robot)
            testCase.verifyEqual(robot.rightMotorReverseCalledWith(),...
                                 testCase.IDLE_POWER);
            testCase.verifyEqual(robot.leftMotorForwardCalledWith(),...
                                 testCase.DRIVE_POWER);
        end
    end

    methods (Test)
        function testConstructor(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
        end

        function testSide(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            testCase.verifyEqual(lineFollower.getSide(),...
                                 LineFollower.SIDE_LEFT);
            lineFollower.setSide(LineFollower.SIDE_RIGHT);
            testCase.verifyEqual(lineFollower.getSide(),...
                                 LineFollower.SIDE_RIGHT);
        end

        function testFollowLineOnLine(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_LEFT);

            robot.setPositionState(Robot.STATE_ON_LINE);
            lineFollower.iterate();

            testCase.verifyTrue(robot.getPositionStateCalled());
            testCase.verifyCurvedLeft(robot);
        end

        function testFollowLineOffLine(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_LEFT);

            robot.setPositionState(Robot.STATE_OFF_LINE);
            lineFollower.iterate();
            testCase.verifyCurvedRight(robot);
        end

        function testCurveLeft(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.curveLeft();
            testCase.verifyCurvedLeft(robot);
        end

        function testCurveRight(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.curveRight();
            testCase.verifyCurvedRight(robot);
        end

        function testCurveTowardLineLeft(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_LEFT);
            lineFollower.curveTowardLine();
            testCase.verifyCurvedRight(robot);
        end

        function testCurveTowardLineRight(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_RIGHT);
            lineFollower.curveTowardLine();
            testCase.verifyCurvedLeft(robot);
        end

        function testCurveAwayFromLineLeft(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_LEFT);
            lineFollower.curveAwayFromLine();
            testCase.verifyCurvedLeft(robot);
        end

        function testCurveAwayFromLineRight(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_RIGHT);
            lineFollower.curveAwayFromLine();
            testCase.verifyCurvedRight(robot);
        end
    end
end

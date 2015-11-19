
classdef LineFollowerTests < matlab.unittest.TestCase
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

            robot.setPositionState(Robot.STATE_ON_LINE);
            lineFollower.iterate();

            testCase.verifyTrue(robot.getPositionStateCalled());
            testCase.verifyEqual(robot.leftMotorForwardCalledWith(), 30);
            testCase.verifyEqual(robot.rightMotorReverseCalledWith(), 20);
        end

        function testFollowLineOffLine(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);

            robot.setPositionState(Robot.STATE_OFF_LINE);
            lineFollower.iterate();
            testCase.verifyEqual(robot.leftMotorReverseCalledWith(), 20);
            testCase.verifyEqual(robot.rightMotorForwardCalledWith(), 30);
        end

        function testCurveLeft(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.curveLeft();
            testCase.verifyEqual(robot.leftMotorForwardCalledWith(), 30);
            testCase.verifyEqual(robot.rightMotorReverseCalledWith(), 20);
        end

        function testCurveRight(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.curveRight();
            testCase.verifyEqual(robot.leftMotorReverseCalledWith(), 20);
            testCase.verifyEqual(robot.rightMotorForwardCalledWith(), 30);
        end

        function testCurveTowardLineLeft(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_LEFT);
            lineFollower.curveTowardLine();
            testCase.verifyEqual(robot.leftMotorReverseCalledWith(), 20);
            testCase.verifyEqual(robot.rightMotorForwardCalledWith(), 30);
        end

        function testCurveTowardLineRight(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_RIGHT);
            lineFollower.curveTowardLine();
            testCase.verifyEqual(robot.leftMotorForwardCalledWith(), 30);
            testCase.verifyEqual(robot.rightMotorReverseCalledWith(), 20);
        end

        function testCurveAwayFromLineLeft(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_LEFT);
            lineFollower.curveAwayFromLine();
            testCase.verifyEqual(robot.leftMotorForwardCalledWith(), 30);
            testCase.verifyEqual(robot.rightMotorReverseCalledWith(), 20);
        end

        function testCurveAwayFromLineRight(testCase)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('drive_idle', robot);
            lineFollower.setSide(LineFollower.SIDE_RIGHT);
            lineFollower.curveAwayFromLine();
            testCase.verifyEqual(robot.leftMotorReverseCalledWith(), 20);
            testCase.verifyEqual(robot.rightMotorForwardCalledWith(), 30);
        end
    end
end

classdef TestBackAndRotateLineFollower < matlab.unittest.TestCase
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
        function testConstructor(obj)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('back_and_rotate',...
                                                         robot);
            obj.verifyClass(lineFollower, 'BackAndRotateLineFollower');
        end

        function testIterateOnLineLeft(obj)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('back_and_rotate',...
                                                         robot);
            robot.setPositionState(Robot.STATE_ON_LINE);
            lineFollower.setSideState(LineLeft());
            foundInteraction = lineFollower.iterate();
            obj.verifyFalse(foundInteraction);
            obj.verifyEqual(robot.straightReverseCalledWith(), 60);
            obj.verifyEqual(robot.leftMotorReverseCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
        end

        function testIterateOffLineLeft(obj)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('back_and_rotate',...
                                                         robot);
            robot.setPositionState(Robot.STATE_OFF_LINE);
            lineFollower.setSideState(LineLeft());
            foundInteraction = lineFollower.iterate();
            obj.verifyFalse(foundInteraction);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 20);
        end

        function testIterateOnLineRight(obj)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('back_and_rotate',...
                                                         robot);
            robot.setPositionState(Robot.STATE_ON_LINE);
            lineFollower.setSideState(LineRight());
            foundInteraction = lineFollower.iterate();
            obj.verifyFalse(foundInteraction);
            obj.verifyEqual(robot.straightReverseCalledWith(), 60);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorReverseCalledWith(), 60);
        end

        function testIterateOffLineRight(obj)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('back_and_rotate',...
                                                         robot);
            robot.setPositionState(Robot.STATE_OFF_LINE);
            lineFollower.setSideState(LineRight());
            foundInteraction = lineFollower.iterate();
            obj.verifyFalse(foundInteraction);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 20);
        end

        function testIterateOnInteraction(obj)
            robot = MockRobot();
            lineFollower = LineFollower.makeLineFollower('back_and_rotate',...
                                                         robot);
            robot.setPositionState(Robot.STATE_ON_INTERACTION);
            lineFollower.setSideState(LineLeft());
            foundInteraction = lineFollower.iterate();
            obj.verifyTrue(foundInteraction);
        end
    end
end

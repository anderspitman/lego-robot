classdef TestMockRobot < matlab.unittest.TestCase
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

        function testStraightForwardRegulated(obj)
            robot = MockRobot();
            robot.straightForwardRegulated(30);
            obj.verifyEqual(robot.straightForwardRegulatedCalledWith(), 30);
        end

        function testStraightReverseRegulated(obj)
            robot = MockRobot();
            robot.straightReverseRegulated(30);
            obj.verifyEqual(robot.straightReverseRegulatedCalledWith(), 30);
        end

        function testForwardCentimetersTime(obj)
            robot = MockRobot();
            robot.forwardCentimetersTime(30);
            obj.verifyEqual(robot.forwardCentimetersTimeCalledWith(), 30);
        end

        function testReverseCentimetersTime(obj)
            robot = MockRobot();
            robot.reverseCentimetersTime(30);
            obj.verifyEqual(robot.reverseCentimetersTimeCalledWith(), 30);
        end

        function testRotateAngleTime(obj)
            robot = MockRobot();
            robot.rotateAngleTime(90);
            robot.rotateAngleTime(-90);
            obj.verifyEqual(robot.rotateAngleTimeCalledWith(), [90 -90]);
        end

        function testRotateTime(obj)
            robot = MockRobot();
            robot.rotateTime(Robot.DIRECTION_CLOCKWISE, 60, 2);
            obj.verifyEqual(robot.rotateTimeCalledWith(),...
                            {Robot.DIRECTION_CLOCKWISE, 60, 2});
        end

        function testRotateClockwiseTime(obj)
            robot = MockRobot();
            robot.rotateClockwiseTime(60);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorReverseCalledWith(), 60);
        end

        function testRotateCounterClockwiseTime(obj)
            robot = MockRobot();
            robot.rotateCounterClockwiseTime(60);
            obj.verifyEqual(robot.leftMotorReverseCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
        end

        function testRotateClockwise(obj)
            robot = MockRobot();
            robot.rotateClockwise(60);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorReverseCalledWith(), 60);
        end

        function testRotateCounterClockwise(obj)
            robot = MockRobot();
            robot.rotateCounterClockwise(60);
            obj.verifyEqual(robot.leftMotorReverseCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
        end

        function testCurveLeftNoTurn(obj)
            robot = MockRobot();
            robot.curveLeft(60, 0); 
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
        end
        
        function testCurveLeftFullTurn(obj)
            robot = MockRobot();
            robot.curveLeft(60, 100); 
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 0);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
        end

        function testCurveLeftPartialTurn(obj)
            robot = MockRobot();
            robot.curveLeft(50, 20); 
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 40);
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 50);
        end

        function testCurveRightNoTurn(obj)
            robot = MockRobot();
            robot.curveRight(60, 0); 
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 60);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
        end
        
        function testCurveRightFullTurn(obj)
            robot = MockRobot();
            robot.curveRight(60, 100); 
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 0);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 60);
        end

        function testCurveRightPartialTurn(obj)
            robot = MockRobot();
            robot.curveRight(50, 20); 
            obj.verifyEqual(robot.rightMotorForwardCalledWith(), 40);
            obj.verifyEqual(robot.leftMotorForwardCalledWith(), 50);
        end
    end
end

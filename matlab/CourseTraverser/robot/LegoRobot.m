classdef LegoRobot < Robot

    properties (Constant)
        BLUETOOTH_ADDRESS = '0016530BAFBE';
        COLOR_PORT = lego.NXT.IN_1;
        COLOR_LINE = 2; % BLUE (lego.NXT.SENSOR_TYPE_COLORBLUE;)
        COLOR_INTERACT = 5; % RED (lego.NXT.SENSOR_TYPE_COLORRED;)
        COLOR_BACKGROUND = 6; % WHITE (lego.NXT.SENSOR_TYPE_LIGHT_INACTIVE;)
        COLOR_FINISH = 1;  
        ULTRASONIC_PORT = lego.NXT.IN_2;

        LEFT_MOTOR = lego.NXT.OUT_A;
        RIGHT_MOTOR = lego.NXT.OUT_C;
        BOTH_MOTORS = lego.NXT.OUT_AC;
        
        ARM_MOTOR = lego.NXT.OUT_B;
        
        MOTOR_POWER_PERCENT = 60;
        
        CENTIMETERS_PER_SECOND = 17.75;
        DEGREES_ROTATE_PER_SECOND = 190;
        ROTATE_TIME_PERCENT_POWER = 60;
        POWER_SECONDS_PER_DEGREE = LegoRobot.ROTATE_TIME_PERCENT_POWER / LegoRobot.DEGREES_ROTATE_PER_SECOND;
        
        TIRE_DIAMETER_CENTIMETERS = 4.3;
        TIRE_RADIUS_CENTIMETERS = LegoRobot.TIRE_DIAMETER_CENTIMETERS / 2;
        TIRE_CIRCUMFERENCE_CENTIMETERS = ...
            2 * pi * LegoRobot.TIRE_RADIUS_CENTIMETERS;
        DEGREES_PER_CENTIMETER = ...
            360 / LegoRobot.TIRE_CIRCUMFERENCE_CENTIMETERS;
    end
    
    properties (Access=private)
        brick
    end

    methods
        function obj = LegoRobot()
            obj.brick = lego.NXT(LegoRobot.BLUETOOTH_ADDRESS);
            obj.brick.setSensorColorFull(LegoRobot.COLOR_PORT);
            obj.brick.setSensorUltrasonic(LegoRobot.ULTRASONIC_PORT);
        end
        
        function brick = getBrick(obj)
            brick = obj.brick;
        end
        
        function shutdown(obj)
            obj.brick.close()
        end
        
        function motorForwardRegulated(obj, motorId, powerPercent)
            obj.brick.motorForwardReg(motorId, powerPercent);
        end
        
        function distanceState = getDistanceState(obj)
            distanceState = obj.brick.sensorValue(LegoRobot.ULTRASONIC_PORT);
        end

        function motorReverseRegulated(obj, motorId, powerPercent)
            obj.brick.motorReverseReg(motorId, powerPercent);
        end
        
        function moveDegrees(obj, degrees, powerPercent)
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTORS, powerPercent, degrees, 0, true,...
                true);
        end

        function positionState = getPositionState(obj)
            color = obj.brick.sensorValue(LegoRobot.COLOR_PORT);
            if color == LegoRobot.COLOR_LINE || color == LegoRobot.COLOR_FINISH
            %if color == LegoRobot.COLOR_LINE
                positionState = Robot.STATE_ON_LINE;
            elseif color == LegoRobot.COLOR_INTERACT
                positionState = Robot.STATE_ON_INTERACTION;
            elseif color == LegoRobot.COLOR_BACKGROUND
                positionState = Robot.STATE_OFF_LINE;
            elseif color == LegoRobot.COLOR_FINISH
                positionState = Robot.STATE_ON_FINISH;
            else
                %fprintf('Not processing color %d\n', color);
                positionState = Robot.STATE_INVALID;
            end
        end
        
        function straightForward(obj, powerPercent)
            obj.brick.motorForward(LegoRobot.BOTH_MOTORS,...
                                   powerPercent);
        end
        
        function straightForwardRegulated(obj, powerPercent)
            obj.brick.motorForwardReg(LegoRobot.BOTH_MOTORS, powerPercent);
        end
        
        function straightReverse(obj, powerPercent)
            obj.brick.motorReverse(LegoRobot.BOTH_MOTORS,...
                                   powerPercent);
        end
        
        function straightReverseRegulated(obj, powerPercent)
            obj.brick.motorReverseReg(LegoRobot.BOTH_MOTORS, powerPercent);
        end
        
        function curveLeft(obj, powerPercent, turnPercent)
            turnRatio = obj.computeTurnRatio(turnPercent);
            obj.rightMotorForward(powerPercent)
            obj.leftMotorForward(powerPercent * turnRatio);
        end

        function curveRight(obj, powerPercent, turnPercent)
            turnRatio = obj.computeTurnRatio(turnPercent);
            obj.leftMotorForward(powerPercent)
            obj.rightMotorForward(powerPercent * turnRatio);
        end

        function turnRatio = computeTurnRatio(obj, turnPercent)
            if turnPercent == 0
                turnRatio = 1;
            else
                turnRatio = 1 - (turnPercent / 100.0);
            end
        end
        
        
        function rotateAngleTime(obj, angleDegrees)
            if angleDegrees >= 0
                obj.leftMotorReverse(LegoRobot.ROTATE_TIME_PERCENT_POWER);
                obj.rightMotorForward(LegoRobot.ROTATE_TIME_PERCENT_POWER);
            else
                obj.rightMotorReverse(LegoRobot.ROTATE_TIME_PERCENT_POWER);
                obj.leftMotorForward(LegoRobot.ROTATE_TIME_PERCENT_POWER);
            end
            
            rotateAngleTimeSeconds = ...
                abs(angleDegrees) / LegoRobot.DEGREES_ROTATE_PER_SECOND;
            pause(rotateAngleTimeSeconds);
            obj.allStop();
        end
        
        function rotateClockwiseTime(obj, powerPercent, timeSeconds)
            obj.rotateClockwise(powerPercent, timeSeconds);
            pause(timeSeconds);
            obj.allStop();
        end
        
        function rotateClockwise(obj, powerPercent)
            leftMotorForward(powerPercent);
            rightMotorReverse(powerPercent);
        end
        
        function rotateCounterClockwiseTime(obj, powerPercent, timeSeconds)
            obj.rotateCounterClockwise(powerPercent);
            pause(timeSeconds);
            obj.allStop();
        end
        
        function rotateCounterClockwise(obj, powerPercent)
            rightMotorForward(powerPercent);
            leftMotorReverse(powerPercent);
        end
        
        function forwardCentimetersDegrees(obj, distanceCentimeters,...
                                           powerPercent)
            degrees = distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER;
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTORS, powerPercent, degrees, 0, true,...
                true);
        end
        
        
        
        function reverseCentimetersDegrees(obj, distanceCentimeters,...
                                           powerPercent)
            degrees = ...
                -(distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER);
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTORS, powerPercent, degrees, 0, true,...
                true);
        end
        
        function forwardCentimetersTime(obj, distanceCentimeters)
            obj.straightForward(LegoRobot.MOTOR_POWER_PERCENT);
            obj.pauseCentimetersTime(distanceCentimeters);
        end
        
        function reverseCentimetersTime(obj, distanceCentimeters)
            obj.straightBack(LegoRobot.MOTOR_POWER_PERCENT);
            obj.pauseCentimetersTime(distanceCentimeters);
        end
        
        function pauseCentimetersTime(obj, distanceCentimeters)
            pauseTime = ...
                distanceCentimeters / LegoRobot.CENTIMETERS_PER_SECOND;
            pause(pauseTime);
            obj.allStop();
        end
        
        function leftMotorForward(obj, powerPercent)
            obj.brick.motorForward(LegoRobot.LEFT_MOTOR,...
                                   powerPercent);
        end

        function rightMotorForward(obj, powerPercent)
            obj.brick.motorForward(LegoRobot.RIGHT_MOTOR,...
                                   powerPercent);
        end

        function leftMotorReverse(obj, powerPercent)
            obj.brick.motorReverse(LegoRobot.LEFT_MOTOR,...
                                   powerPercent);
        end

        function rightMotorReverse(obj, powerPercent)
            obj.brick.motorReverse(LegoRobot.RIGHT_MOTOR,...
                                   powerPercent);
        end
        
        function allStop(obj)
            obj.brick.motorBrake(LegoRobot.BOTH_MOTORS);
        end
        
        function rotateArm(obj, angleDegrees, powerPercent)
            obj.brick.motorRotateExt(...
                LegoRobot.ARM_MOTOR, powerPercent, angleDegrees, 0, ...
                true, true);
        end
        
        function battery = getBatteryLevel(obj)
            battery = obj.brick.getBatteryLevel();
        end
        
        function resetArm(obj)
            tachoCount = obj.brick.getOutputState(LegoRobot.ARM_MOTOR).rotationCount;
            fprintf('tachoCount: %f\n', tachoCount);
            obj.rotateArmDegrees(tachoCount, 20);
            fprintf('tachoCount: %f\n', tachoCount);
        end
        
        function rotateArmDegrees(obj, angleDegrees, powerPercent)
            obj.brick.motorRotateExt(...
                LegoRobot.ARM_MOTOR, powerPercent, angleDegrees, 0,...
                false, true);
%             obj.brick.motorRotate(...
%                 LegoRobot.ARM_MOTOR, powerPercent, angleDegrees);
            obj.waitUntilRotateFinished(LegoRobot.ARM_MOTOR);
        end

        function breakArm(obj)
            obj.brick.motorBrake(LegoRobot.ARM_MOTOR);
        end
        
        function forwardCentimeters(obj, distanceCentimeters,...
                                    powerPercent)
            degrees = distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER;
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTORS, powerPercent, degrees, 0, true,...
                true);
            obj.waitUntilRotateFinished(LegoRobot.LEFT_MOTOR);
        end
        
        function reverseCentimeters(obj, distanceCentimeters,...
                                    powerPercent)
            degrees = ...
                -(distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER);
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTORS, powerPercent, degrees, 0, true,...
                true);
            obj.waitUntilRotateFinished(LegoRobot.LEFT_MOTOR);
        end
        
        function rotateAngleDegrees(obj, angleDegrees, powerPercent)
            
            if angleDegrees >= 0
                turnPercent = 100;
                tireDegreesPerRobotDegrees = 2.45;
            else
                turnPercent = -100;
                tireDegreesPerRobotDegrees = 2.45;
            end
            
            tireAngle = angleDegrees * tireDegreesPerRobotDegrees;
            
            obj.brick.motorRotateExt(LegoRobot.BOTH_MOTORS,...
                                     powerPercent, tireAngle,...
                                     turnPercent, true, true);
            obj.waitUntilRotateFinished(LegoRobot.LEFT_MOTOR);
        end
        
        function move(obj, distanceCentimeters, turnPercent, powerPercent)
            degrees = distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER;
            obj.brick.motorRotateExt(LegoRobot.BOTH_MOTORS,...
                                     powerPercent, degrees,...
                                     turnPercent, true, true);
            obj.waitUntilRotateFinished(LegoRobot.LEFT_MOTOR);
        end

        function waitUntilRotateFinished(obj, motor)            
            regulationMode = -1;
            
            disp('waiting');
            tic;
            while regulationMode ~= 0
                outputState = obj.brick.getOutputState(motor);
                regulationMode = outputState.mode;
            end
            fprintf('done waiting: %f\n', toc);
        end
    end
end

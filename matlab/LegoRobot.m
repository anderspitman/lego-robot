classdef LegoRobot < Robot

    properties (Constant)
        BLUETOOTH_ADDRESS = '0016530BAFBE';
        COLOR_PORT = lego.NXT.IN_1;
        COLOR_LINE = 2; % BLUE (lego.NXT.SENSOR_TYPE_COLORBLUE;)
        COLOR_INTERACT = 5; % RED (lego.NXT.SENSOR_TYPE_COLORRED;)
        COLOR_BACKGROUND = 6; % WHITE (lego.NXT.SENSOR_TYPE_LIGHT_INACTIVE;)

        LEFT_MOTOR_PORT = lego.NXT.OUT_A;
        RIGHT_MOTOR_PORT = lego.NXT.OUT_C;
        BOTH_MOTOR_PORTS = lego.NXT.OUT_AC;
        
        MOTOR_POWER_PERCENT = 20;
        
        CENTIMETERS_PER_SECOND = 7.5;
        DEGREES_ROTATE_PER_SECOND = 64;
        ROTATE_TIME_PERCENT_POWER = 20;
        
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
        end
        
        function shutdown(obj)
            obj.brick.close()
        end
        
        function allStop(obj)
            obj.brick.motorBrake(LegoRobot.BOTH_MOTOR_PORTS);
        end

        function positionState = getPositionState(obj)
            color = obj.brick.sensorValue(LegoRobot.COLOR_PORT);
            if color == LegoRobot.COLOR_LINE
                positionState = Robot.STATE_ON_LINE;
            elseif color == LegoRobot.COLOR_INTERACT
                positionState = Robot.STATE_ON_INTERACTION;
            elseif color == LegoRobot.COLOR_BACKGROUND
                positionState = Robot.STATE_OFF_LINE;
            else
                fprintf('Not processing color %d\n', color);
                positionState = Robot.STATE_INVALID;
            end
        end

        function leftMotorForward(obj, powerPercent)
            obj.brick.motorForwardReg(LegoRobot.LEFT_MOTOR_PORT,...
                                      powerPercent);
        end

        function rightMotorForward(obj, powerPercent)
            obj.brick.motorForwardReg(LegoRobot.RIGHT_MOTOR_PORT,...
                                      powerPercent);
        end

        function leftMotorReverse(obj, powerPercent)
            obj.brick.motorReverseReg(LegoRobot.LEFT_MOTOR_PORT,...
                                      powerPercent);
        end

        function rightMotorReverse(obj, powerPercent)
            obj.brick.motorReverseReg(LegoRobot.RIGHT_MOTOR_PORT,...
                                      powerPercent);
        end
        
        function straightForward(obj, powerPercent)
            obj.brick.motorForwardReg(LegoRobot.BOTH_MOTOR_PORTS,...
                                      powerPercent);
        end
        
        function straightBack(obj, powerPercent)
            obj.brick.motorReverseReg(LegoRobot.BOTH_MOTOR_PORTS,...
                                      powerPercent);
        end
        
        function forwardCentimetersDegrees(obj, distanceCentimeters,...
                                           powerPercent)
            degrees = distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER;
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTOR_PORTS, powerPercent, degrees, 0, true,...
                true);
        end
        
        function reverseCentimetersDegrees(obj, distanceCentimeters,...
                                           powerPercent)
            degrees = ...
                -(distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER);
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTOR_PORTS, powerPercent, degrees, 0, true,...
                true);
        end
        
        function rotateDegrees(obj, angleDegrees, powerPercent)
            tireDegreesPerRobotDegrees = 2;
            tireAngle = angleDegrees * tireDegreesPerRobotDegrees;
            if angleDegrees >= 0
                turnPercent = 10;
            else
                turnPercent = -10;
            end
            obj.brick.motorRotateExt(LegoRobot.BOTH_MOTOR_PORTS,...
                                     powerPercent, tireAngle,...
                                     turnPercent, true, true);
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
        
        function rotateTime(obj, angleDegrees)
            if angleDegrees >= 0
                obj.leftMotorReverse(LegoRobot.ROTATE_TIME_PERCENT_POWER);
                obj.rightMotorForward(LegoRobot.ROTATE_TIME_PERCENT_POWER);
            else
                obj.rightMotorReverse(LegoRobot.ROTATE_TIME_PERCENT_POWER);
                obj.leftMotorForward(LegoRobot.ROTATE_TIME_PERCENT_POWER);
            end
            
            rotateTimeSeconds = ...
                abs(angleDegrees) / LegoRobot.DEGREES_ROTATE_PER_SECOND;
            pause(rotateTimeSeconds);
            obj.allStop();
        end
    end
end

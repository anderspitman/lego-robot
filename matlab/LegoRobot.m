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
            obj.brick.motorBrake(LegoRobot.LEFT_MOTOR_PORT);
            obj.brick.motorBrake(LegoRobot.RIGHT_MOTOR_PORT);
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
            obj.brick.motorForwardReg(LegoRobot.LEFT_MOTOR_PORT, powerPercent);
        end

        function rightMotorForward(obj, powerPercent)
            obj.brick.motorForwardReg(LegoRobot.RIGHT_MOTOR_PORT, powerPercent);
        end

        function leftMotorReverse(obj, powerPercent)
            obj.brick.motorReverseReg(LegoRobot.LEFT_MOTOR_PORT, powerPercent);
        end

        function rightMotorReverse(obj, powerPercent)
            obj.brick.motorReverseReg(LegoRobot.RIGHT_MOTOR_PORT, powerPercent);
        end
        
        function straightForward(obj, powerPercent)
            %obj.brick.motorForwardReg(LegoRobot.BOTH_MOTOR_PORTS, powerPercent);
            obj.brick.motorForwardSync(LegoRobot.BOTH_MOTOR_PORTS, powerPercent,...
                                       100);
        end
        
        function straightBack(obj, powerPercent)
            obj.brick.motorReverseReg(LegoRobot.BOTH_MOTOR_PORTS, powerPercent);
        end
        
        function forwardCentimeters(obj, distanceCentimeters)
            degrees = distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER;
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTOR_PORTS,LegoRobot.MOTOR_POWER_PERCENT,...
                degrees, 0, false, true);
        end
        
        function reverseCentimeters(obj, distanceCentimeters)
            degrees = ...
                -(distanceCentimeters * LegoRobot.DEGREES_PER_CENTIMETER);
            obj.brick.motorRotateExt(...
                LegoRobot.BOTH_MOTOR_PORTS,LegoRobot.MOTOR_POWER_PERCENT,...
                degrees, 0, false, true);
        end
        
        function pauseCentimeters(obj, distanceCentimeters)
            pauseTime = ...
                distanceCentimeters / LegoRobot.CENTIMETERS_PER_SECOND;
            pause(pauseTime);
            obj.allStop();
        end
        
        function rotate(obj, angleDegrees, powerPercent)
            degreesPerSecond = 100;
            if angleDegrees >= 0
                obj.rightMotorReverse(50);
                obj.leftMotorForward(50);
            else
                obj.leftMotorReverse(50);
                obj.rightMotorForward(50);
            end
            
            rotateTimeSeconds = abs(angleDegrees) / degreesPerSecond;
            pause(rotateTimeSeconds);
            obj.allStop();
        end
        
        function rotateDegrees(obj, angleDegrees, powerPercent)
            degreesPerSecond = 100;
            
            if angleDegrees >= 0
                obj.brick.motorRotateExt(LegoRobot.BOTH_MOTOR_PORTS,...
                                         powerPercent, 360, 0, true, false);
            else
                
            end
            
            rotateTimeSeconds = abs(angleDegrees) / degreesPerSecond;
            pause(rotateTimeSeconds);
            obj.allStop();
        end
    end
end

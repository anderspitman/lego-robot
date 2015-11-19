classdef LegoRobot < Robot

    properties (Constant)
        BLUETOOTH_ADDRESS = '0016530BAFBE';
        COLOR_PORT = lego.NXT.IN_1;
        COLOR_LINE = lego.NXT.SENSOR_TYPE_COLORBLUE;
        COLOR_INTERACT = lego.NXT.SENSOR_TYPE_COLORRED;
        COLOR_BACKGROUND = lego.NXT.SENSOR_TYPE_LIGHT_INACTIVE; % white

        LEFT_MOTOR_PORT = lego.NXT.OUT_A;
        RIGHT_MOTOR_PORT = lego.NXT.OUT_C;
    end

    methods
        function obj = LegoRobot()
            obj.brick = lego.NXT(LegoRobot.BLUETOOTH_ADDRESS);
            obj.brick.setSensorColorFull(LegoRobot.COLOR_PORT);
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
            end
        end

        function leftMotorForward(obj, powerPercent)
            obj.brick.motorForward(LegoRobot.LEFT_MOTOR_PORT, powerPercent);
        end

        function rightMotorForward(obj, powerPercent)
            obj.brick.motorForward(LegoRobot.RIGHT_MOTOR_PORT, powerPercent);
        end

        function leftMotorReverse(obj, powerPercent)
            obj.brick.motorReverse(LegoRobot.LEFT_MOTOR_PORT, powerPercent);
        end

        function rightMotorReverse(obj, powerPercent)
            obj.brick.motorReverse(LegoRobot.RIGHT_MOTOR_PORT, powerPercent);
        end
    end
end

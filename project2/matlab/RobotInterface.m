classdef (Abstract) RobotInterface < handle
    properties (Constant)
        COLOR_BLUE = 1;
        STATE_ON_LINE = 0;
        STATE_OFF_LINE = 1;
        STATE_ON_INTERACTION = 2;
    end

    methods (Abstract)
        getPositionState(obj)
        leftMotorForward(obj, powerPercent)
        leftMotorReverse(obj, powerPercent)
        rightMotorForward(obj, powerPercent)
        rightMotorReverse(obj, powerPercent)
    end
end

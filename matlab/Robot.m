classdef (Abstract) Robot < handle
    properties (Constant)
        COLOR_BLUE = 1;
        STATE_ON_LINE = 0;
        STATE_OFF_LINE = 1;
        STATE_ON_INTERACTION = 2;
        STATE_INVALID = 3;
    end

    methods (Abstract)
        getPositionState(obj)
        allStop(obj)
        shutdown(obj)
        rotate(obj, angleDegrees, powerPercent)
        straightForward(obj, powerPercent)
        straightBack(obj, powerPercent)
        forwardCentimeters(obj, distanceCentimeters)
        reverseCentimeters(obj, distanceCentimeters)
        leftMotorForward(obj, powerPercent)
        leftMotorReverse(obj, powerPercent)
        rightMotorForward(obj, powerPercent)
        rightMotorReverse(obj, powerPercent)
    end
end

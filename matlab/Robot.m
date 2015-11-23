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
        leftMotorForward(obj, powerPercent)
        leftMotorReverse(obj, powerPercent)
        rightMotorForward(obj, powerPercent)
        rightMotorReverse(obj, powerPercent)
        straightForward(obj, powerPercent)
        straightForwardRegulated(obj, powerPercent)
        straightReverse(obj, powerPercent)
        straightReverseRegulated(obj, powerPercent)
        rotateDegrees(obj, angleDegrees, powerPercent)
        rotateAngleTime(obj, angleDegrees)
        forwardCentimetersDegrees(obj, distanceCentimeters)
        forwardCentimetersTime(obj, distanceCentimeters)
        reverseCentimetersDegrees(obj, distanceCentimeters)
        allStop(obj)
    end
end

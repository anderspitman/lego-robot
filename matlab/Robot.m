classdef (Abstract) Robot < handle
    properties (Constant)
        COLOR_BLUE = 1;
        STATE_ON_LINE = 0;
        STATE_OFF_LINE = 1;
        STATE_ON_INTERACTION = 2;
        STATE_INVALID = 3;
        DIRECTION_CLOCKWISE = 0;
        DIRECTION_COUNTER_CLOCKWISE = 1;
    end
    
    methods(Static)
        function newRobot = makeRobot(type)
            if strcmp(type, 'lego')
                newRobot = LegoRobot();
            elseif strcmp(type, 'mock')
                newRobot = MockRobot();
            end
        end
    end

    methods (Abstract)
        getPositionState(obj)
        straightForward(obj, powerPercent)
        straightForwardRegulated(obj, powerPercent)
        straightReverse(obj, powerPercent)
        straightReverseRegulated(obj, powerPercent)
        curveLeft(obj, powerPercent, turnPercent)
        curveRight(obj, powerPercent, turnPercent)
        rotateAngleDegrees(obj, angleDegrees, powerPercent)
        rotateAngleTime(obj, angleDegrees)
        rotateClockwiseTime(obj, powerPercent, timeSeconds)
        rotateClockwise(obj, powerPercent)
        rotateCounterClockwiseTime(obj, powerPercent, timeSeconds)
        rotateCounterClockwise(obj, powerPercent)
        forwardCentimetersDegrees(obj, distanceCentimeters, percentPower)
        forwardCentimetersTime(obj, distanceCentimeters)
        reverseCentimetersDegrees(obj, distanceCentimeters, percentPower)
        leftMotorForward(obj, powerPercent)
        leftMotorReverse(obj, powerPercent)
        rightMotorForward(obj, powerPercent)
        rightMotorReverse(obj, powerPercent)
        allStop(obj)
        rotateArm(obj, angleDegrees, powerPercent)
    end
end

classdef MockRobot < Robot

    properties (Access=private)
        m_getPositionStateCalled = false;
        m_leftMotorForwardCalledValue
        m_leftMotorReverseCalledValue
        m_rightMotorForwardCalledValue
        m_rightMotorReverseCalledValue
        positionState
        straighReverseCalledWithValue
        straightForwardRegulatedCalledWithValue
        straightReverseRegulatedCalledWithValue
        forwardCentimetersTimeCalledWithValue
        reverseCentimetersTimeCalledWithValue
        rotateAngleTimeCalledWithValue
        rotateTimeCalledWithValue
        rotateClockwiseTimeCalledWithValue
        rotateCounterClockwiseTimeCalledWithValue
    end

    methods
        function obj = MockRobot()
            obj.positionState = Robot.STATE_OFF_LINE;
        end

        function state = getPositionState(obj)
            state = obj.positionState;
            obj.m_getPositionStateCalled = true;
        end
        function wasCalled = getPositionStateCalled(obj)
            wasCalled = obj.m_getPositionStateCalled;
        end

        function setPositionState(obj, state)
            obj.positionState = state;
        end

        function straightForward(obj, powerPercent)
        end
        function straightForwardRegulated(obj, powerPercent)
            obj.straightForwardRegulatedCalledWithValue = powerPercent;
        end

        function value = straightForwardRegulatedCalledWith(obj)
            value = obj.straightForwardRegulatedCalledWithValue;
        end

        function straightReverse(obj, powerPercent)
            obj.straighReverseCalledWithValue = powerPercent;
        end
        function value = straightReverseCalledWith(obj)
            value = obj.straighReverseCalledWithValue;
        end

        function straightReverseRegulated(obj, powerPercent)
            obj.straightReverseRegulatedCalledWithValue = powerPercent;
        end
        function value = straightReverseRegulatedCalledWith(obj)
            value = obj.straightReverseRegulatedCalledWithValue;
        end

        function curveLeft(obj, powerPercent, turnPercent)
            turnRatio = obj.computeTurnRatio(powerPercent, turnPercent);
            obj.rightMotorForward(powerPercent)
            obj.leftMotorForward(powerPercent * turnRatio);
        end

        function curveRight(obj, powerPercent, turnPercent)
            turnRatio = obj.computeTurnRatio(powerPercent, turnPercent);
            obj.leftMotorForward(powerPercent)
            obj.rightMotorForward(powerPercent * turnRatio);
        end

        function turnRatio = computeTurnRatio(obj, powerPercent, turnPercent)
            if turnPercent == 0
                turnRatio = 1;
            else
                turnRatio = 1 - (turnPercent / 100.0);
            end
        end

        function rotateAngleDegrees(obj, angleDegrees, powerPercent)
        end

        function rotateTime(obj, direction, powerPercent, timeSeconds)
            % TODO: figure out how to initialize cell directly with values
            obj.rotateTimeCalledWithValue = {};
            obj.rotateTimeCalledWithValue{1} = direction;
            obj.rotateTimeCalledWithValue{2} = powerPercent;
            obj.rotateTimeCalledWithValue{3} = timeSeconds;
        end
        function value = rotateTimeCalledWith(obj)
            value = obj.rotateTimeCalledWithValue;
        end

        function rotateClockwiseTime(obj, powerPercent, timeSeconds)
            obj.rotateClockwise(powerPercent);
        end

        function rotateCounterClockwiseTime(obj, powerPercent, timeSeconds)
            obj.rotateCounterClockwise(powerPercent);
        end

        function rotateAngleTime(obj, angleDegrees)
            obj.rotateAngleTimeCalledWithValue(end+1) = angleDegrees;
        end
        function value = rotateAngleTimeCalledWith(obj)
            value = obj.rotateAngleTimeCalledWithValue;
        end

        function forwardCentimetersDegrees(obj, distanceCentimeters)
        end

        function forwardCentimetersTime(obj, distanceCentimeters)
            obj.forwardCentimetersTimeCalledWithValue(end+1) = ...
                distanceCentimeters;
        end
        function value = forwardCentimetersTimeCalledWith(obj,...
                                                          distanceCentimeters)
            value = obj.forwardCentimetersTimeCalledWithValue;
        end

        function reverseCentimetersTime(obj, distanceCentimeters)
            obj.reverseCentimetersTimeCalledWithValue = distanceCentimeters;
        end
        function value = reverseCentimetersTimeCalledWith(obj,...
                                                          distanceCentimeters)
            value = obj.reverseCentimetersTimeCalledWithValue;
        end

        function reverseCentimetersDegrees(obj, distanceCentimeters)
        end

        function allStop(obj)
        end

        function leftMotorForward(obj, powerPercent)
            obj.m_leftMotorForwardCalledValue = powerPercent;
        end
        function value = leftMotorForwardCalledWith(obj, value)
            value = obj.m_leftMotorForwardCalledValue; 
        end

        function leftMotorReverse(obj, powerPercent)
            obj.m_leftMotorReverseCalledValue = powerPercent;
        end
        function value = leftMotorReverseCalledWith(obj, value)
            value = obj.m_leftMotorReverseCalledValue; 
        end

        function rightMotorForward(obj, powerPercent)
            obj.m_rightMotorForwardCalledValue = powerPercent;
        end
        function value = rightMotorForwardCalledWith(obj, value)
            value = obj.m_rightMotorForwardCalledValue; 
        end

        function rightMotorReverse(obj, powerPercent)
            obj.m_rightMotorReverseCalledValue = powerPercent;
        end
        function value = rightMotorReverseCalledWith(obj, value)
            value = obj.m_rightMotorReverseCalledValue; 
        end

        function rotateClockwise(obj, powerPercent)
            obj.leftMotorForward(powerPercent);
            obj.rightMotorReverse(powerPercent);
        end

        function rotateCounterClockwise(obj, powerPercent)
            obj.rightMotorForward(powerPercent);
            obj.leftMotorReverse(powerPercent);
        end

    end
end

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
        rotateTimeCalledWithValue
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
        function rotateDegrees(obj, angleDegrees, powerPercent)
        end
        function rotateTime(obj, angleDegrees)
            obj.rotateTimeCalledWithValue = angleDegrees;
        end
        function value = rotateTimeCalledWith(obj)
            value = obj.rotateTimeCalledWithValue;
        end
        function forwardCentimetersDegrees(obj, distanceCentimeters)
        end
        function forwardCentimetersTime(obj, distanceCentimeters)
            obj.forwardCentimetersTimeCalledWithValue = distanceCentimeters;
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
    end
end

classdef MockRobot < Robot

    properties (Access=private)
        m_getPositionStateCalled = false;
        m_leftMotorForwardCalledValue
        m_leftMotorReverseCalledValue
        m_rightMotorForwardCalledValue
        m_rightMotorReverseCalledValue
        positionState
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
    end
end

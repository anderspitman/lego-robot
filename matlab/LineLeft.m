classdef LineLeft < LineState
    methods
        function rotateAwayFromLine(obj, robot)
            robot.leftMotorReverse(obj.HIGH_POWER_PERCENT);
            robot.rightMotorForward(obj.HIGH_POWER_PERCENT);
        end

        function arcTowardLine(obj, robot)
            robot.leftMotorForward(obj.HIGH_POWER_PERCENT);
            robot.rightMotorForward(obj.LOW_POWER_PERCENT);
        end
    end
end

classdef LineRight < LineState
    methods
        function rotateAwayFromLine(obj, robot)
            robot.leftMotorForward(obj.HIGH_POWER_PERCENT);
            robot.rightMotorReverse(obj.HIGH_POWER_PERCENT);
        end

        function arcTowardLine(obj, robot)
            robot.rightMotorForward(obj.HIGH_POWER_PERCENT);
            robot.leftMotorForward(obj.LOW_POWER_PERCENT);
        end
    end
end

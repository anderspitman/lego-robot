classdef BackAndRotateLineFollower < LineFollower
    properties (Constant)
        HIGH_POWER_PERCENT = 60;
        LOW_POWER_PERCENT = 20;
    end

    methods
        function obj = BackAndRotateLineFollower(robot)
            obj@LineFollower(robot);

        end
        
        function followLineToInteraction(obj)
            foundInteraction = false;
           
            while ~foundInteraction
                foundInteraction = obj.iterate();
            end
        end

        function foundInteraction = iterate(obj)
            foundInteraction = false;

            positionState = obj.robot.getPositionState();
            if positionState == Robot.STATE_ON_LINE
                obj.backUp();
                obj.rotateAwayFromLine();
            elseif positionState == Robot.STATE_OFF_LINE
                obj.arcTowardLine();
            elseif positionState == Robot.STATE_ON_INTERACTION
                foundInteraction = true;
            end

            obj.robot.allStop();
        end

        function backUp(obj)
            obj.robot.straightReverse(obj.HIGH_POWER_PERCENT);
            pause(.1)
        end

        function rotateAwayFromLine(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.robot.leftMotorReverse(obj.HIGH_POWER_PERCENT);
                obj.robot.rightMotorForward(obj.HIGH_POWER_PERCENT);
            elseif obj.side == LineFollower.SIDE_RIGHT
                obj.robot.leftMotorForward(obj.HIGH_POWER_PERCENT);
                obj.robot.rightMotorReverse(obj.HIGH_POWER_PERCENT);
            else
                error('Invalid line side');
            end

            pause(.2)
        end

        function arcTowardLine(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.robot.leftMotorForward(obj.HIGH_POWER_PERCENT);
                obj.robot.rightMotorForward(obj.LOW_POWER_PERCENT);
            elseif obj.side == LineFollower.SIDE_RIGHT
                obj.robot.rightMotorForward(obj.HIGH_POWER_PERCENT);
                obj.robot.leftMotorForward(obj.LOW_POWER_PERCENT);
            else
                error('Invalid line side');
            end
        end
    end
end

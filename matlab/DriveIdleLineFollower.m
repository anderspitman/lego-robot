classdef DriveIdleLineFollower < LineFollower

    properties (Constant)
        DRIVE_POWER_PERCENT = 30;
        IDLE_POWER_PERCENT = 20;
    end

    methods
        function obj = DriveIdleLineFollower(robot)
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
                obj.curveAwayFromLine();
            elseif positionState == Robot.STATE_ON_INTERACTION
                foundInteraction = true;
            elseif positionState == Robot.STATE_OFF_LINE
                obj.curveTowardLine();
            end
        end

        function curveAwayFromLine(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.curveLeft();
            elseif obj.side == LineFollower.SIDE_RIGHT
                obj.curveRight();
            end
        end

        function curveTowardLine(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.curveRight();
            elseif obj.side == LineFollower.SIDE_RIGHT
                obj.curveLeft();
            end
        end

        function curveLeft(obj)
            obj.robot.leftMotorReverse(...
                DriveIdleLineFollower.IDLE_POWER_PERCENT);
            obj.robot.rightMotorForward(...
                DriveIdleLineFollower.DRIVE_POWER_PERCENT);
        end

        function curveRight(obj)
            obj.robot.leftMotorForward(...
                DriveIdleLineFollower.DRIVE_POWER_PERCENT);
            obj.robot.rightMotorReverse(...
                DriveIdleLineFollower.IDLE_POWER_PERCENT);
        end
    end
end

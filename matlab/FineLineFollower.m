classdef FineLineFollower < LineFollower
    properties (Constant)
        DRIVE_POWER_PERCENT = 5;
        IDLE_POWER_PERCENT = 4;
    end

    methods
        function obj = FineLineFollower(robot)
            obj@LineFollower(robot);

        end
        
        function followLineToInteraction(obj)
            
            foundInteraction = false;

            while ~foundInteraction
                positionState = obj.robot.getPositionState();
                
                if positionState == Robot.STATE_ON_LINE
                    obj.getOffLine();
                elseif positionState == Robot.STATE_OFF_LINE
                    obj.curveTowardLine();
                elseif positionState == Robot.STATE_ON_INTERACTION
                    foundInteraction = true;
                end
            end
            
            obj.robot.allStop();
        end

        function getOffLine(obj)
            positionState = Robot.STATE_ON_LINE;
            while positionState == Robot.STATE_ON_LINE
                obj.robot.leftMotorReverseRegulated(FineLineFollower.IDLE_POWER_PERCENT);
                obj.robot.rightMotorForwardRegulated(FineLineFollower.IDLE_POWER_PERCENT);
                positionState = obj.robot.getPositionState();
            end
        end

        function curveTowardLine(obj)
            obj.robot.rightMotorForwardRegulated(FineLineFollower.IDLE_POWER_PERCENT);
            obj.robot.leftMotorForwardRegulated(FineLineFollower.DRIVE_POWER_PERCENT);
        end
    end
end


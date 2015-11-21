classdef FineLineFollower < LineFollower
    properties (Constant)
        DRIVE_POWER_PERCENT = 20;
        IDLE_POWER_PERCENT = 15;
    end

    methods
        function obj = FineLineFollower(robot)
            obj@LineFollower(robot);

        end
        
        function findLine(obj)
        end

        function followLine(obj)
        end
        
        function followLineToInteraction(obj)
            
            foundInteraction = false;

            while ~foundInteraction
                positionState = obj.robot.getPositionState();
                
                if positionState == Robot.STATE_ON_LINE
                    obj.robot.leftMotorForward(FineLineFollower.IDLE_POWER_PERCENT);
                    obj.robot.rightMotorForward(FineLineFollower.DRIVE_POWER_PERCENT);
                elseif positionState == Robot.STATE_ON_INTERACTION
                    foundInteraction = true;
                elseif positionState == Robot.STATE_OFF_LINE
                    obj.robot.leftMotorForward(FineLineFollower.DRIVE_POWER_PERCENT);
                    obj.robot.rightMotorForward(FineLineFollower.IDLE_POWER_PERCENT);
                end
            end
            
            obj.robot.allStop();
        end
    end
end


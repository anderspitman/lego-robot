classdef CenterSensorLineFollower < LineFollower
    properties (Constant)
        DRIVE_POWER_PERCENT = 10;
        IDLE_POWER_PERCENT = 5;
    end

    methods
        function obj = CenterSensorLineFollower(robot)
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
                    obj.robot.reverseCentimetersTime(3);
                    obj.robot.rotateTime(45);
                elseif positionState == Robot.STATE_OFF_LINE
                    obj.robot.leftMotorForward(30);
                    obj.robot.rightMotorForward(1);
                elseif positionState == Robot.STATE_ON_INTERACTION
                    foundInteraction = true;
                end
            end
            
            obj.robot.allStop();
        end
    end
end


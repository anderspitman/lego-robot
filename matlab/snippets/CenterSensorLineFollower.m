classdef CenterSensorLineFollower < LineFollower
    properties (Constant)
        DRIVE_POWER_PERCENT = 20;
        IDLE_POWER_PERCENT = 15;
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
                    obj.robot.straightReverse(60);
                    pause(.1)
                    obj.robot.leftMotorReverse(60);
                    obj.robot.rightMotorForward(60);
                    pause(.2)
                elseif positionState == Robot.STATE_OFF_LINE
                    obj.robot.leftMotorForward(60);
                    obj.robot.rightMotorForward(20);
                elseif positionState == Robot.STATE_ON_INTERACTION
                    foundInteraction = true;
                end
            end
            
            obj.robot.allStop();
        end
    end
end


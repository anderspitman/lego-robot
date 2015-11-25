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

            % TODO: How does it work with this here?
            % does not work.
            %obj.robot.allStop();
        end

        function backUp(obj)
            obj.robot.straightReverse(obj.HIGH_POWER_PERCENT);
            pause(.1)
            obj.robot.allStop();
        end

        function rotateAwayFromLine(obj)
            obj.sideState.rotateAwayFromLine(obj.robot);
        end

        function arcTowardLine(obj)
            obj.sideState.arcTowardLine(obj.robot);
        end
    end
end

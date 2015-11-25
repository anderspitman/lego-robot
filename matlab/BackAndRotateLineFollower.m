classdef BackAndRotateLineFollower < LineFollower
    properties (Constant)
        HIGH_POWER_PERCENT = 60;
        LOW_POWER_PERCENT = 20;
    end
    
    properties (Access=private)
        prevState = Robot.STATE_OFF_LINE;
        onToOffTimes;
        onToOffIndex;
        offToOnTimes;
        offToOnIndex;
    end

    methods
        function obj = BackAndRotateLineFollower(robot)
            tic;
            obj@LineFollower(robot);
            obj.onToOffIndex = 1;
            obj.offToOnIndex = 1;

        end
        
        function followLineToInteraction(obj)
            found = '';
            while ~strcmp(found, 'interaction')
                found = obj.iterate();
            end
        end
        
        function followLineToFinish(obj)
            found = '';
            while ~strcmp(found, 'finish')
                found = obj.iterate();
            end
        end

        function found = iterate(obj)
            found = '';

            positionState = obj.robot.getPositionState();
            hitWall = obj.checkStateTransitionTime(positionState);
            
            if positionState == Robot.STATE_ON_LINE
                obj.backUp();
                obj.rotateAwayFromLine();
            elseif positionState == Robot.STATE_OFF_LINE
                obj.arcTowardLine();
            elseif positionState == Robot.STATE_ON_FINISH
                found = 'finish';
            elseif positionState == Robot.STATE_ON_INTERACTION
                found = 'interaction';
            end
            
            if hitWall
                found = 'finish';
            end

            % TODO: How does it work with this here?
            % does not work.
            %obj.robot.allStop();
        end
        
        function hitWall = checkStateTransitionTime(obj, state)
            hitWall = false;
            runTime = toc;
            if runTime > 10
                hitWall = true;
            end
            %fprintf('State: %d, Prev: %d\n', state, obj.prevState);
            if obj.prevState == Robot.STATE_OFF_LINE && state == Robot.STATE_ON_LINE
                obj.offToOnTimes(obj.offToOnIndex) = toc;
                fprintf('Off to on time: %f\n', obj.offToOnTimes(obj.offToOnIndex));
                obj.prevState = Robot.STATE_ON_LINE;
                obj.offToOnIndex = obj.offToOnIndex + 1;
                tic;
            elseif obj.prevState == Robot.STATE_ON_LINE && state == Robot.STATE_OFF_LINE
                obj.onToOffTimes(obj.onToOffIndex) = toc;
                fprintf('On to off time: %f\n', obj.onToOffTimes(obj.onToOffIndex));
                obj.prevState = Robot.STATE_OFF_LINE;
                obj.onToOffIndex = obj.onToOffIndex + 1;
                tic;
            end
        end
        
        function untilPositionStateIs(obj, state)
            positionState = state;
            while positionState ~= state
                positionState = obj.robot.getPositionState();
            end
        end
        
        function whilePositionStateIs(obj, state)
            positionState = state;
            while positionState == state
                positionState = obj.robot.getPositionState();
            end
        end

        function backUp(obj)
            obj.robot.straightReverse(obj.HIGH_POWER_PERCENT);
            pause(.1)
            obj.robot.allStop();
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
            
            obj.robot.allStop();
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

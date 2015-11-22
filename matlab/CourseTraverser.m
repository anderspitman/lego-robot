classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFollower
        fineLineFollower
    end
    
    methods
        function obj = CourseTraverser()
            obj.robot = LegoRobot();
            %obj.lineFollower = LineFollower.makeLineFollower('drive_idle',...
            %                                                 obj.robot);
            obj.lineFollower = BackAndRotateLineFollower(obj.robot);
            obj.fineLineFollower = FineLineFollower(obj.robot);
        end
        
        function traverse(obj)
            
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            obj.lineFollower.followLineToInteraction();
            
            %obj.fineLineFollower.followLineToInteraction();
            
            obj.fineAlign();
            
            %obj.doFirstInteraction();
            
            %obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            %obj.lineFollower.followLineToInteraction();
            
            obj.robot.allStop();
            %obj.robot.shutdown();
        end
        
        function fineAlign(obj)
            obj.backOffLine();
            obj.back1CM();
            
%            currDistance = obj.measureDistanceToLine();
%            fprintf('Distance to line: %f\n', currDistance);
            
%             prevDistance = 1000;
%             while prevDistance > currDistance
%                 prevDistance = currDistance;
%                 obj.rotateCCW();
%                 currDistance = obj.measureDistanceToLine();
%                 fprintf('Distance to line: %f\n', currDistance);
%             end
%             obj.rotateCW();
%             
%             obj.forwardToInteractionLine();
            
            currTime = obj.measureTimeToLine();
            fprintf('Time to line: %f\n', currTime);
            
            prevTime = 1000;
            while prevTime > currTime
                prevTime = currTime;
                obj.rotateCCW();
                currTime = obj.measureTimeToLine();
                fprintf('Time to line: %f\n', currTime);
            end
            obj.rotateCW();
            
            obj.forwardToInteractionLine();
            
        end
        
        function rotateCCW(obj)
            speed = 5;
            obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            pause(.5);
        end
        
        function rotateCW(obj)
            speed = 5;
            obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, speed);
            pause(.5);
        end
        
        function rotateCCWDegrees(obj, speed, degrees)
            speedSecondsPerDegree = 50/90;
            obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            pause((degrees / speed) * speedSecondsPerDegree);
            obj.robot.brake();
        end
        
        function rotateCWDegrees(obj, speed, degrees)
            speedSecondsPerDegree = 50/90;
            obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, speed);
            pause((degrees / speed) * speedSecondsPerDegree);
            obj.robot.brake();
        end
        
        function orientToInteractionArmAlign(obj)
            obj.robot.rotateCCWDegrees(80, 20);

            obj.robot.forwardCentimetersDegrees(11, 20);
            obj.robot.rotateCCWDegrees(20, 20);
        end
        
        function orientToInteractionDistance(obj)
            % right side mounted US sensor
            minDistanceToTarget = 10;
            aligned = false
            while ~aligned
                d = obj.robot.getDistanceState()
                if d < 0
                    % we're too far to the right (detecting nothing)
                    % rotate CCW until we're facing something
                    while (d < 0)
                        obj.robot.rotateCCW();
                        d = obj.robot.getDistanceState();
                    end
                elseif d < minDistanceToTarget
                    % rotate a little more centered
                    obj.robot.rotateCW();
                    aligned = true;
                end
            end
        end
        
        function orientToInteractionFollow(obj)
            %XXX: we assume the interactions are always on the left and
            % for simplicity
            s = obj.getSide();
            obj.setSide(LineFollower.SIDE_LEFT);

            %FIXME: calculate time to follow from distance
            % follow for a few seconds to straighten out the robot
            start = clock;
            while (etime (clock, start) <= 3)
                obj.iterateInteraction();
            end
            obj.setSide(s);
        end
        
        function iterateInteractionLine(obj)
            positionState = obj.robot.getPositionState();
            if positionState == Robot.STATE_ON_INTERACTION
                obj.lineFollower.curveAwayFromLine();
            else
                obj.lineFollower.curveTowardLine();
            end
        end
        
        function timeThroughLineAvg = measureTimeToLine(obj)
            
            numToAverage = 1;
            for i = 1:numToAverage
                speed = 2;
                positionState = obj.robot.getPositionState();

                tic;
                while positionState ~= Robot.STATE_ON_INTERACTION
                    obj.robot.straightForwardRegulated(speed);
                    positionState = obj.robot.getPositionState();
                end
                timeToLine = toc;

                tic;
                while positionState == Robot.STATE_ON_INTERACTION
                    obj.robot.straightForwardRegulated(speed);
                    positionState = obj.robot.getPositionState();
                end

                timeThroughLine(i) = toc;

                % undo movement
                obj.robot.straightReverseRegulated(speed);
                pause((timeToLine + timeThroughLine(i)))
            end
            timeThroughLineAvg = sum(timeThroughLine) / numToAverage;
            obj.robot.allStop();
        end
        
%         function distanceToLine = measureDistanceToLine(obj)
%             speed = 15;
%             degreesStep = 3;
%             positionState = obj.robot.getPositionState();
%             
%             degreesCount = 0;
%             while positionState ~= Robot.STATE_ON_INTERACTION
%                 obj.robot.moveDegrees(degreesStep, speed);
%                 degreesCount = degreesCount + degreesStep;
%                 positionState = obj.robot.getPositionState();
%             end
%             
%             % undo movement
%             for i = 1:degreesCount
%                 obj.robot.moveDegrees(-degreesStep, speed);
%             end
%             
%             distanceToLine = degreesCount;
%         end
        
        function backOffLine(obj)
            positionState = obj.robot.getPositionState();
            
            % Just in case we overshot the red line
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightReverseRegulated(5);
                positionState = obj.robot.getPositionState();
            end
            
            while positionState ~= Robot.STATE_OFF_LINE
                obj.robot.straightReverseRegulated(5);
                positionState = obj.robot.getPositionState();
            end
        end
        
        function back1CM(obj)
            obj.robot.straightReverseRegulated(10);
            pause(.3);
        end
        
        function forwardToInteractionLine(obj)
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightForwardRegulated(5);
                positionState = obj.robot.getPositionState();
            end
        end
        
        function doFirstInteraction(obj)
            obj.robot.forwardCentimetersTime(20);
            obj.robot.rotateTime(-90);
            obj.robot.forwardCentimetersTime(35);
            obj.robot.rotateTime(-120);
            obj.robot.forwardCentimetersTime(40);
            obj.robot.rotateTime(-90);
            obj.robot.forwardCentimetersTime(20);
        end
    end
end
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
        
        function timeToLine = measureTimeToLine(obj)
            speed = 1;
            positionState = obj.robot.getPositionState();
            tic;
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightForwardRegulated(speed);
                positionState = obj.robot.getPositionState();
            end
            timeToLine = toc;
            
            % undo movement
            obj.robot.straightReverseRegulated(speed);
            pause(timeToLine*1.1)
            obj.robot.allStop();
        end
        
        function distanceToLine = measureDistanceToLine(obj)
            speed = 15;
            degreesStep = 3;
            positionState = obj.robot.getPositionState();
            
            degreesCount = 0;
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.moveDegrees(degreesStep, speed);
                degreesCount = degreesCount + degreesStep;
                positionState = obj.robot.getPositionState();
            end
            
            % undo movement
            for i = 1:degreesCount
                obj.robot.moveDegrees(-degreesStep, speed);
            end
            
            distanceToLine = degreesCount;
        end
        
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
            pause(.5);
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
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
            s = obj.lineFollower.getSide();
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);

            %FIXME: calculate time to follow from distance
            % follow for a few seconds to straighten out the robot
            start = clock;
            while (etime (clock, start) <= 3)
                obj.iterateInteractionLine();
            end
            obj.lineFollower.setSide(s);
        end
        
        function iterateInteractionLine(obj)
            positionState = obj.robot.getPositionState();
            if positionState == Robot.STATE_ON_INTERACTION
                obj.lineFollower.curveAwayFromLine();
            else
                obj.lineFollower.curveTowardLine();
            end
        end
        
        function forwardToInteractionLine(obj)
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightForwardRegulated(5);
                positionState = obj.robot.getPositionState();
            end
        end
        
        function returnToLine(obj)
            % post-interaction line return
            % backs up until we pass the line, then rotates toward the
            % course direction
            speed = 15;
            while obj.robot.getPositionState() == Robot.STATE_OFF_LINE
                obj.robot.straightBackwardRegulated(speed);
            end
            
            while obj.robot.getPositionState() ~= Robot.STATE_OFF_LINE
                obj.robot.straightBackwardRegulated(speed);
            end
            obj.robot.rotateCWDegrees(45, 20);
        end
        
        function crossOverLine(obj)
            speed = 15;
            % drive until we hit the line
            % FIXME: add a failsafe in case we're already on or past the
            % line, possibly backing up or bailing out after x seconds
            while (obj.robot.getPositionState() == Robot.STATE_OFF_LINE)
                obj.robot.straightForwardRegulated(speed);
            end
            
            % continue forward until we pass the line
            while (obj.robot.getPositionState() ~= Robot.STATE_OFF_LINE)
                obj.robot.straightForwardRegulated(speed);
            end
            
            % flip the current side (and resume following the line)
            s = LineFollower.SIDE_LEFT;
            if s == obj.lineFollower.getSide()
                obj.lineFollower.setSide(LineFollower.SIDE_RIGHT)
            end
            
            obj.lineFollower.setSide(s);
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

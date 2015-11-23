classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFinder
        lineFollower
        firstInteraction
    end
    
    methods
        function obj = CourseTraverser(robot, lineFinder, lineFollower)
            obj.robot = robot;
            obj.lineFinder = lineFinder;
            obj.lineFollower = lineFollower;
            obj.firstInteraction = Interaction.makeInteraction('first',...
                                                               robot);
        end
        
        function traverse(obj)
            
            %obj.lineFinder.findLine();
            
            %obj.crossOverLine();
            
            obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            
            obj.lineFollower.followLineToInteraction();

            
            %obj.doFirstInteraction();
            obj.orientToInteractionDistance();
            
            obj.robot.allStop();
        end
        
        function rotateCCWDegrees(obj, degrees, speed)
            obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            pause((degrees / speed) * LegoRobot.POWER_SECONDS_PER_DEGREE);
            obj.robot.allStop();
        end
        
        function rotateCWDegrees(obj, degrees, speed)
            obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, speed);
            pause((degrees / speed) * LegoRobot.POWER_SECONDS_PER_DEGREE);
            obj.robot.allStop();
        end
        
        function rotateCCWDegreesState(obj, degrees, speed, state)
            movetime = (degrees / speed) * LegoRobot.POWER_SECONDS_PER_DEGREE;
            start = clock;
            while etime(clock, start) <= movetime && obj.robot.getPositionState == state;
                obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
                obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            end
            obj.robot.allStop();
        end
        
        function orientToInteractionArmAlign(obj)
            obj.robot.rotateCCWDegrees(80, 20);

            obj.robot.forwardCentimetersDegrees(11, 20);
            obj.robot.rotateCCWDegrees(20, 20);
        end
        
        function orientDistanceIteration(obj, distance)           
            % we're too far to the right (detecting nothing)
            % rotate CCW until we're facing something
            d = obj.robot.getDistanceState();
            while (d < 0 || d > distance)
                obj.rotateCCWDegrees(30, 10);
                d = obj.robot.getDistanceState();
                fprintf('cur: %d, target: %d\n', d, distance);
            end
            obj.robot.allStop();
        end
        
        function orientToInteractionDistance(obj)
            % drive over the red line
            obj.robot.getPositionState();
            while (obj.robot.getPositionState() == Robot.STATE_ON_INTERACTION)
                obj.robot.straightForwardRegulated(10);
            end
            obj.robot.allStop();
 
            % right side mounted UlS sensor
            obj.rotateCCWDegrees(45, 20);
            minDistanceToTarget = 15;
            aligned = false;
            while ~aligned
                d = obj.robot.getDistanceState();
                fprintf('%d\n', d);
                if d < 0 || d > minDistanceToTarget
                    obj.orientDistanceIteration(minDistanceToTarget);
                    %obj.robot.forwardCentimetersDegrees(2, 10);
                    %obj.orientDistanceIteration(minDistanceToTarget / 1.5);
                    %obj.robot.forwardCentimetersDegrees(2, 10);
                    %obj.orientDistanceIteration(minDistanceToTarget / 2);
                    %obj.robot.forwardCentimetersDegrees(2, 10);
                end
                d = obj.robot.getDistanceState();
                % rotate a little more centered
                rot = acosd(12.5 / d);
                fprintf('rotating %d degrees\n', rot);
                obj.rotateCCWDegreesState(rot, 15, Robot.STATE_ON_INTERACTION);
                
                % make sure we dont go over the red line
                aligned = true;
            end
        end
        
        function orientToInteractionFollow(obj)
            %XXX: we assume the interactions are always on the left and
            % for simplicity--
            s = obj.lineFollower.getSide();
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);

            %FIXME: calculate time to follow from distance
            % follow for a few seconds to straighten out the robot
            start = clock;
            while (etime (clock, start) <= 1.2)
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
        
        function crossOverLineOld(obj)
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
            obj.firstInteraction.complete();
        end
        
        function doSecondInteraction(obj)
            % assume we're already lined up perfectly with the cage
            % FIXME: add arm movemnt commands
            % lower arm to be inside the cage
            obj.robot.rotateArm(120, 20);
            % lower until it is lined up vertically
            % drive forward to pick up the box
            obj.robot.moveDegrees(270, 20);
            % lift the arm up
            obj.robot.rotateArm(-120, 20);
            % back up until we are out of the cage
            obj.robot.straightBack(15);
            % (while moving back) lower the arm 
            % continue backing up
            obj.robot.allStop();
            % get back to the line
            obj.returnToLine();
        end
        
        function doThirdInteraction(obj)
            % follow the same methodology as above
            % just dont lower the arm as you back out
        end
        
        function crossOverLine(obj)
            positionState = obj.robot.getPositionState();
            
            while positionState == Robot.STATE_ON_LINE
                obj.robot.straightForward(60);
                positionState = obj.robot.getPositionState();
            end
            
            obj.robot.allStop();
        end
    end
end

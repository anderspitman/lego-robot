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
            obj.orientToInteractionDistance(24, true);
            
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
        
        function rotateCCWDistance(obj, speed, distance)
            d = obj.robot.getDistanceState();
            fprintf('%d %d', d, distance);
            while d < 0 || d > distance
                fprintf('iterating: %d\n', d);
                obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
                obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
                d = obj.robot.getDistanceState();
                %pause(0.01);
            end
            fprintf('stopped at distance: %d\n', d);
            obj.robot.allStop();
        end
             
        function orientDistanceIteration(obj, speed, distance, state)
            d = obj.robot.getDistanceState();
            hitState = false;
            leftState = false;
            fprintf('%d %d', d, distance);
            
            % continuously rotate CCW
            obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
                
            while (d < 0 || d > distance)
                fprintf('iterating: %d %d\n', d, obj.robot.getPositionState());
                
                % check that we rotate on and past the interaction marker
                d = obj.robot.getDistanceState();
                if obj.robot.getPositionState() == state
                    hitState = true;
                end
                if hitState && obj.robot.getPositionState() ~= state
                    leftState = true;
                end
                %pause(0.01);
            end
            fprintf('stopped at distance: %d\n', d);
            obj.robot.allStop();
        end
        
        function orientDistanceIterationSampled(obj, speed, distance, state)
            % XXX: just an idea
            dSamples = zeros(1, 5);
            avgDist = -1;
            si = 1;
            numSamples = 5;
            
            d = obj.robot.getDistanceState();
            fprintf('%d %d', d, distance);
            
            % continuously rotate CCW
            obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            
            for i=1:1:numSamples
                dSamples(i) = d;
            end
            
            while d < 0 || avgDist > distance
                fprintf('iterating: %d %d\n', d, obj.robot.getPositionState());
                
                % check that we rotate on and past the interaction marker
                d = obj.robot.getDistanceState();
                if d > 0
                    dSamples(si) = d;
                    si = si + 1;
                    if si > numSamples
                        si = 1;
                    end
                end
                
                %pause(0.01);
            end
            fprintf('stopped at distance: %d\n', d);
            obj.robot.allStop();
        end
        
        function orientToInteractionDistance(obj, targetDistance, trigCorrect)
            % drive over the red line
            obj.robot.getPositionState();
            while (obj.robot.getPositionState() == Robot.STATE_ON_INTERACTION)
                obj.robot.straightForwardRegulated(10);
            end
            obj.robot.allStop();
            
            %XXX: trying this pivoted then backup thing
            %obj.robot.motorReverseRegulated(10);
            %pause(0.001);
            %while (obj.robot.getPositionState() == Robot.STATE_ON_INTERACTION)
            %end
            %obj.robot.allStop();
            %while (obj.robot.getPositionState() == Robot.STATE_ON_INTERACTION)
            %    obj.robot.straightForwardRegulated(10);
            %end
            %obj.robot.allStop();
            
            % right side mounted UlS sensor
            %obj.rotateCCWDegrees(45, 20);
            %targetDistance = 15;
            d = obj.robot.getDistanceState();
            if d < 0 || d > targetDistance
                obj.orientDistanceIteration(5, targetDistance, Robot.STATE_ON_INTERACTION)
                %obj.rotateCCWDistance(5, minDistanceToTarget);
                %obj.orientDistanceIteration(minDistanceToTarget);
                %obj.robot.forwardCentimetersDegrees(2, 10);
                %obj.orientDistanceIteration(minDistanceToTarget / 1.5);
                %obj.robot.forwardCentimetersDegrees(2, 10);
                %obj.orientDistanceIteration(minDistanceToTarget / 2);
                %obj.robot.forwardCentimetersDegrees(2, 10);
            end
            
            pause(0.5);
            
            if trigCorrect
                % rotate a little more centered
                d = obj.robot.getDistanceState();
                rot = acosd(12.5 / d);
                fprintf('rotating %d degrees\n', rot);
                obj.rotateCCWDegreesState(rot, 25, Robot.STATE_ON_INTERACTION);
            end
            
            rDist = (targetDistance - d) + 5;
            fprintf('backing up %d robot centimeters', rDist);
            obj.robot.reverseCentimetersDegrees(rDist, 20);
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

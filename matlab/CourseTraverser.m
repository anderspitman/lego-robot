classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFinder
        lineFollower
        firstInteraction
    end

    methods (Static)
        function traverser = makeCourseTraverser(type)
            if strcmp(type, 'normal')
                robot = Robot.makeRobot('lego');
                lineFinder = LineFinder.makeLineFinder('basic', robot);
                lineFollower = LineFollower.makeLineFollower(...
                    'back_and_rotate', robot);
            elseif strcmp(type, 'mock')
                robot = Robot.makeRobot('mock');
                lineFinder = LineFinder.makeLineFinder('mock', robot);
                lineFollower = LineFollower.makeLineFollower(...
                    'mock', robot);
            end

            traverser = CourseTraverser(robot, lineFinder, lineFollower);

        end
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
        
        function rotateCCWDegreesState(obj, degrees, speed, state)
            movetime = (degrees / speed) * LegoRobot.POWER_SECONDS_PER_DEGREE;
            start = clock;
            while etime(clock, start) <= movetime && obj.robot.getPositionState == state;
                obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
                obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            end
            obj.robot.allStop();
        end
                
        function orientToInteractionDistance(obj, targetDistance, trigCorrect)
            % drive over the red line
            obj.robot.getPositionState();
            while (obj.robot.getPositionState() == Robot.STATE_ON_INTERACTION)
                obj.robot.straightForwardRegulated(10);
            end
            obj.robot.allStop();
            
            % rotate till you dudes
            % rotate until we detect something within targetDistance
            d = obj.robot.getDistanceState();
            if d < 0 || d > targetDistance % -1 is no detect
                obj.orientDistanceIteration(5, targetDistance)
            end
            
            pause(0.5);
            
            if trigCorrect
                % rotate a little more centered
                d = obj.robot.getDistanceState();
                rot = acosd(12.5 / d);
                fprintf('rotating %d degrees\n', rot);
                
                % rotates but dumps out if we pass the interaction
                obj.rotateCCWDegreesState(rot, 25, Robot.STATE_ON_INTERACTION);
            end
            
            rDist = (targetDistance - d) + 5;
            fprintf('backing up %d robot centimeters', rDist);
            obj.robot.reverseCentimetersDegrees(rDist, 20);
        end     
        
        function orientDistanceIteration(obj, speed, distance)
            d = obj.robot.getDistanceState();
            fprintf('distances: cur: %d dest: %d', d, distance);
            
            % continuously rotate CCW
            obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
                
            while d < 0 || d > distance % -1 is no detect
                fprintf('iterating: %d %d\n', d, obj.robot.getPositionState());
                
                % check that we rotate on and past the interaction marker
                d = obj.robot.getDistanceState();
            end
            fprintf('stopped at distance: %d\n', d);
            obj.robot.allStop();
        end
        
        function forwardToInteractionLine(obj)
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightForwardRegulated(5);
                positionState = obj.robot.getPositionState();
            end
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

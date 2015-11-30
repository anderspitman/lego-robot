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
            

            obj.lineFinder.findLine();
            
            obj.crossOverLine();
            
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            obj.lineFollower.followLineToInteraction();
            
            obj.fullAlignLeft();
            
            obj.doFirstInteraction();
            
            obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            obj.lineFollower.followLineToInteraction();
            
            obj.fullAlignRight();
            
            followLine2();
            redLine2();
%               
%               obj.skipInteraction();
%               obj.lineFollower.followLineToInteraction();
%               
%              obj.skipInteraction();
%              obj.robot.curveLeft(60, 50);
%              pause(2);
%              obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
%              obj.lineFollower.followLineToFinish();
             
             obj.robot.allStop();
        end
        
        function backUpABitLeft(obj)
            positionState = Robot.STATE_OFF_LINE;
            
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightReverse(20);
                positionState = obj.robot.getPositionState();
            end
            
            while positionState ~= Robot.STATE_OFF_LINE
                obj.robot.straightReverse(30);
                positionState = obj.robot.getPositionState();
            end
            
            
%             obj.robot.leftMotorReverse(40);
%             obj.robot.rightMotorReverse(60);
%             pause(1);

            obj.robot.straightReverse(60);
            pause(.4);
            obj.robot.allStop();
            obj.robot.rotateAngleTime(-50);
            
            while positionState ~= Robot.STATE_ON_LINE
                obj.robot.straightForward(30);
                positionState = obj.robot.getPositionState();
            end

            obj.robot.allStop();
        end
        
        function backUpABitRight(obj)
            positionState = Robot.STATE_OFF_LINE;
            
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightReverse(20);
                positionState = obj.robot.getPositionState();
            end
            
            while positionState ~= Robot.STATE_OFF_LINE
                obj.robot.straightReverse(30);
                positionState = obj.robot.getPositionState();
            end
            
            
%             obj.robot.leftMotorReverse(40);
%             obj.robot.rightMotorReverse(60);
%             pause(1);

            obj.robot.straightReverse(60);
            pause(.4);
            obj.robot.allStop();
            obj.robot.rotateAngleTime(50);
            
            while positionState ~= Robot.STATE_ON_LINE
                obj.robot.straightForward(30);
                positionState = obj.robot.getPositionState();
            end

            obj.robot.allStop();
        end
        
        function fullAlignLeft(obj)
            obj.backUpABitLeft();
            obj.ryanAlignLeft();
            obj.robot.straightReverse(25);
            pause(2.0);
            obj.robot.allStop();
            obj.alignForSecondAlignPassLeft();
            obj.ryanAlignLeft();
        end
        
        function fullAlignRight(obj)
            obj.backUpABitRight();
            obj.ryanAlignRight();
            obj.robot.straightReverse(25);
            pause(2.0);
            obj.robot.allStop();
            obj.alignForSecondAlignPassRight();
            obj.ryanAlignRight();
        end
        
        
        function alignForSecondAlignPassLeft(obj)
            obj.robot.leftMotorForward(30);
            obj.robot.rightMotorForward(10);
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_LINE;
                positionState = obj.robot.getPositionState();
            end
            obj.robot.allStop();
            
            %obj.robot.straightForward(20);
            %while positionState ~= Robot.STATE_OFF_LINE
            %    positionState = obj.robot.getPositionState();
            %end
            %obj.robot.allStop();
        end
        
        function alignForSecondAlignPassRight(obj)
            obj.robot.leftMotorForward(10);
            obj.robot.rightMotorForward(30);
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_LINE;
                positionState = obj.robot.getPositionState();
            end
            obj.robot.allStop();
        end
        
        function ryanAlignLeft(obj)
            followLineLeft();
        end
        
        function ryanAlignRight(obj)
            followLine1();
        end
         
        function fineAlign(obj)
            speed = 1;
%             positionState = obj.robot.getPositionState();
%             while positionState ~= Robot.STATE_ON_INTERACTION
%                 obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, speed);
%                 obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, speed);
%                 positionState = obj.robot.getPositionState();
%             end
%             
%             while positionState == Robot.STATE_ON_INTERACTION
% %                 obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, speed);
% %                 obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, speed);
%                 obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
%                 obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
%                 positionState = obj.robot.getPositionState();
%             end
            
            done = false;
            while ~done
                done = obj.alignIteration();
            end
            
            obj.robot.allStop();
            
        end
        
        function done = alignIteration(obj)
            slowSpeed = 1;
            fastSpeed = 3;
            positionState = Robot.STATE_OFF_LINE;
            done = false;
            while positionState ~= Robot.STATE_ON_INTERACTION && ~done
%                 obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, slowSpeed);
%                 obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, slowSpeed);
                obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, 4);
                obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, 5);
                positionState = obj.robot.getPositionState();
                
            end            
            
            tic;
            while positionState == Robot.STATE_ON_INTERACTION && ~done
%                 obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, fastSpeed);
%                 obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, slowSpeed);
                obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, 2);
                obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, 4);
                positionState = obj.robot.getPositionState();
                time = toc;
                if time > 2.8
                    done = true;
                end
            end
            
            fprintf('Time: %f\n', time);
            
        end
        
        function skipFirstInteraction(obj)
            obj.robot.rotateAngleTime(20);
            obj.robot.curveRight(60, 20);
            pause(2.0)
        end
        
        function skipInteraction(obj)
            obj.robot.rotateAngleTime(-30);
            obj.robot.straightForward(60);
            pause(.5);
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
        
        function rotateToFace(obj, speed, side)
            if strcmp(side, 'left')
                obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
                obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            elseif strcmp(side, 'right')
                obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, speed);
                obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, speed);
            end
        end
        
        function orientToInteractionDistance(obj, targetDistance, side, trigCorrect)
            % drive over the red line
            obj.robot.getPositionState();        
            obj.robot.straightForwardRegulated(10);
            while (obj.robot.getPositionState() == Robot.STATE_ON_INTERACTION)
            end
            pause(0.5); % keep drivin a little
            obj.robot.allStop();
            
            % rotate till you dudes
            % rotate until we detect something within targetDistance
            d = obj.robot.getDistanceState();
            if d < 0 || d > targetDistance % -1 is no detect
                d = obj.orientDistanceIteration(5, targetDistance, side)
            end
            
            pause(0.5);
            
            if trigCorrect
                speed = 10;
                state = Robot.STATE_ON_INTERACTION;
                lineToSensorDistance = 10;
                % rotate a little more centered
                rot = acosd((targetDistance - lineToSensorDistance) / d);
                fprintf('rotating %d degrees\n', rot);
                
                % rotates but dumps out if we pass the interaction
                % FIXME: this DOESN'T go the specified degrees, but it
                % seems to work well. degrees = robot degrees
                movetime = (rot / speed) * LegoRobot.POWER_SECONDS_PER_DEGREE;
                start = clock;
                obj.rotateToFace(speed, side);
                while etime(clock, start) <= movetime && obj.robot.getPositionState == state;
                end
                obj.robot.allStop();
            end
            
            rDist = (targetDistance - d) + 5;
            fprintf('backing up %d robot centimeters', rDist);
            %obj.robot.reverseCentimetersDegrees(rDist, 20);
        end     
        
        function foundD = orientDistanceIteration(obj, speed, distance, side)
            d = obj.robot.getDistanceState();
            fprintf('distances: cur: %d dest: %d', d, distance);
            
            % continuously rotate CCW
            obj.rotateToFace(speed, side);
            
            while d < 0 || d > distance % -1 is no detect
                fprintf('iterating: %d %d\n', d, obj.robot.getPositionState());
                
                % check that we rotate on and past the interaction marker
                d = obj.robot.getDistanceState();
                pause(.01);
            end
            fprintf('stopped at distance: %d\n', d);
            foundD = d;
            
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

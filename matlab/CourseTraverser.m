classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFinder
        lineFollower
        firstInteraction
        secondInteraction
        thirdInteraction
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
            obj.secondInteraction = Interaction.makeInteraction('second',...
                                                                robot);
            obj.thirdInteraction = Interaction.makeInteraction('third',...
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
            obj.doSecondInteraction();

            obj.lineFollower.followLineToInteraction();
            
            obj.fullAlignRight();
            obj.lineFollower.followLineToInteraction();

%            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
%            obj.lineFollower.followLineToFinish();
             
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
        
        function doFirstInteraction(obj)
            obj.firstInteraction.complete();
        end
        
        function doSecondInteraction(obj)
            obj.secondInteraction.complete();
        end
        
        function doThirdInteraction(obj)
            obj.thirdInteraction.complete();
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

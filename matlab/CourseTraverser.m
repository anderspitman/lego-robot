classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFinder
        lineFollower
        aligner
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
            obj.aligner = Aligner.makeAligner(robot);
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
            
            obj.aligner.setSide(LineFollower.SIDE_LEFT);
            obj.aligner.fullAlign();
            
            obj.doFirstInteraction();
            
            obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            obj.lineFollower.followLineToInteraction();
            
            obj.aligner.setSide(LineFollower.SIDE_RIGHT);
            obj.aligner.fullAlign();
            obj.doSecondInteraction();

            obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            obj.lineFollower.followLineToInteraction();
             
            obj.aligner.setSide(LineFollower.SIDE_RIGHT);
            obj.aligner.fullAlign();
            obj.doThirdInteraction();
            
            % hack to reset timer for detecting wall
            tic;
            
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            obj.lineFollower.followLineToFinish();
             
            obj.robot.allStop();
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
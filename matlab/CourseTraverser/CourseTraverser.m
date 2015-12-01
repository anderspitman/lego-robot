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
        function traverser = makeCourseTraverser()
            traverser = CourseTraverser();
        end
    end
    
    methods
        function obj = CourseTraverser()
            addpath('robot');
            addpath('line_finder');
            addpath('line_follower');
            addpath('aligner');
            addpath('interaction'); 
            
            obj.robot = Robot.makeRobot('lego');
            obj.lineFinder = LineFinder.makeLineFinder('basic', obj.robot);
            obj.lineFollower = LineFollower.makeLineFollower(...
                'back_and_rotate', obj.robot);
            obj.aligner = Aligner.makeAligner(obj.robot);
            obj.firstInteraction = Interaction.makeInteraction('first',...
                                                               obj.robot);
            obj.secondInteraction = Interaction.makeInteraction('second',...
                                                                obj.robot);
            obj.thirdInteraction = Interaction.makeInteraction('third',...
                                                                obj.robot);
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
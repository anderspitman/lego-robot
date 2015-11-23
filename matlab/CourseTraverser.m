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
            
            obj.lineFinder.findLine();
            
            obj.crossOverLine();
            
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            
            obj.lineFollower.followLineToInteraction();

            
            obj.doFirstInteraction();
            
            obj.robot.allStop();
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

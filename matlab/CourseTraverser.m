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
            
            obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            obj.lineFollower.followLineToInteraction();
            
            %obj.doFirstInteraction();
            
            obj.robot.allStop();
        end
               
        function doFirstInteraction(obj)
            obj.firstInteraction.complete();
        end
    end
end

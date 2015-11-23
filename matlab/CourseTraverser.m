classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFollower
        firstInteraction
    end
    
    methods
        function obj = CourseTraverser(robot, lineFollower)
            obj.robot = robot;
            obj.lineFollower = lineFollower;
            obj.firstInteraction = Interaction.makeInteraction('first', robot);
        end
        
        function traverse(obj)
            
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            obj.lineFollower.followLineToInteraction();
            
            obj.doFirstInteraction();
            
            obj.robot.allStop();
        end
               
        function doFirstInteraction(obj)
            obj.firstInteraction.complete();
        end
    end
end

classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFollower
    end
    
    methods
        function obj = CourseTraverser(robot, lineFollower)
            obj.robot = robot;
            obj.lineFollower = lineFollower;
        end
        
        function traverse(obj)
            
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            obj.lineFollower.followLineToInteraction();
            
            obj.doFirstInteraction();
            
            obj.robot.allStop();
        end
               
        function doFirstInteraction(obj)
            obj.robot.forwardCentimetersTime(20);
            obj.robot.rotateTime(-90);
            obj.robot.forwardCentimetersTime(35);
            obj.robot.rotateTime(-120);
            obj.robot.forwardCentimetersTime(40);
            obj.robot.rotateTime(-90);
            obj.robot.forwardCentimetersTime(20);
        end
    end
end

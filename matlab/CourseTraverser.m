classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFollower
    end
    
    methods
        function obj = CourseTraverser()
            obj.robot = LegoRobot();
            obj.lineFollower = LineFollower.makeLineFollower('drive_idle',...
                                                             obj.robot);
        end
        
        function traverse(obj)
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            obj.lineFollower.followLineToInteraction();
            
            
            obj.doFirstInteraction();
            obj.robot.allStop();
            %obj.robot.shutdown();
        end
        
        function doFirstInteraction(obj)
            obj.robot.rightMotorReverse(50);
            obj.robot.leftMotorReverse(50);
            pause(.5);
            obj.robot.rotate(90);
        end
    end
end
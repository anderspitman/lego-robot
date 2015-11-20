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
            obj.lineFollower.followLine();
        end
    end
end
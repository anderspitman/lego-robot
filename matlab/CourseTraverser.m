classdef CourseTraverser < handle

    properties(Access=private)
        robot
        lineFollower
        fineLineFollower
    end
    
    methods
        function obj = CourseTraverser()
            obj.robot = LegoRobot();
            obj.lineFollower = LineFollower.makeLineFollower('drive_idle',...
                                                             obj.robot);
            obj.fineLineFollower = FineLineFollower(obj.robot);
        end
        
        function traverse(obj)
            
            obj.lineFollower.setSide(LineFollower.SIDE_LEFT);
            obj.lineFollower.followLineToInteraction();
            
            %obj.fineLineFollower.followLineToInteraction();
            obj.doFirstInteraction();
            
            %obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            %obj.lineFollower.followLineToInteraction();
            
            obj.robot.allStop();
            %obj.robot.shutdown();
        end
        
        function doFirstInteraction(obj)
            obj.robot.forwardCentimetersTime(20);
            obj.robot.rotateTime(-90);
            obj.robot.forwardCentimetersTime(35);
            obj.robot.rotateTime(-100);
            obj.robot.forwardCentimetersTime(40);
            obj.robot.rotateTime(-90);
            obj.robot.forwardCentimetersTime(20);
        end
    end
end
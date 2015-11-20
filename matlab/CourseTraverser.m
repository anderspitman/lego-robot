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
            
            %obj.doFirstInteraction();
            
            %obj.lineFollower.setSide(LineFollower.SIDE_RIGHT);
            %obj.lineFollower.followLineToInteraction();
            
            obj.robot.allStop();
            %obj.robot.shutdown();
        end
        
        function doFirstInteraction(obj)
            obj.robot.reverseCentimeters(15);
            obj.robot.rotate(45);
            obj.robot.forwardCentimeters(40);
            %obj.robot.rotate(-45);
            %obj.robot.forwardCentimeters(30);
            %obj.robot.rotate(-45);
            %obj.lineFollower.findLine();
            
        end
    end
end
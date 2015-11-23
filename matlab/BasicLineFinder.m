classdef BasicLineFinder < LineFinder
    methods
        function obj = BasicLineFinder(robot)
            obj@LineFinder(robot);
        end
        
        function findLine(obj)
%             obj.robot.straightForward(60);
%             pause(2);
%             obj.robot.rotateAngleTime(90);
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_LINE
                obj.robot.curveLeft(40, 30);
                positionState = obj.robot.getPositionState();
            end
            
            obj.robot.allStop();
        end
        
        function moveFowardToLine(obj)
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_LINE
                obj.robot.straightForward(60);
                positionState = obj.robot.getPositionState();
            end
        end
    end
end


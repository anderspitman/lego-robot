classdef FirstInteraction < Interaction
    methods
        function obj = FirstInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            obj.robot.forwardCentimetersTime(5);
            obj.robot.curveRight(60, 60);
            pause(7.2);
            obj.robot.forwardCentimetersTime(20);
            obj.robot.rotateAngleTime(-90);
            obj.robot.forwardCentimetersTime(15);
            
            obj.robot.straightReverse(30);
            positionState = Robot.STATE_OFF_LINE;
            while positionState ~= Robot.STATE_ON_LINE
                positionState = obj.robot.getPositionState();
            end
            
            obj.robot.forwardCentimetersTime(5);
            
            obj.robot.allStop();
            
%             obj.robot.forwardCentimetersTime(20);
%             obj.robot.rotateAngleTime(-90);
%             obj.robot.forwardCentimetersTime(20);
%             obj.robot.rotateAngleTime(-90);
%             obj.robot.forwardCentimetersTime(30);
%             obj.robot.rotateAngleTime(-90);
%             obj.robot.forwardCentimetersTime(30);
%             obj.robot.rotateAngleTime(-90);
        end
    end
end

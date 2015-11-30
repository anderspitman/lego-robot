classdef FirstInteraction < Interaction
    methods
        function obj = FirstInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            obj.robot.forwardCentimetersTime(20);
            obj.robot.rotateAngleTime(-90);
            obj.robot.forwardCentimetersTime(20);
            obj.robot.rotateAngleTime(-90);
            obj.robot.forwardCentimetersTime(30);
            obj.robot.rotateAngleTime(-90);
            obj.robot.forwardCentimetersTime(30);
            obj.robot.rotateAngleTime(-90);
        end
    end
end

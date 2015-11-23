classdef FirstInteraction < Interaction
    methods
        function obj = FirstInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
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

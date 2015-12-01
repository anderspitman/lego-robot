classdef SecondInteraction < Interaction
    methods
        function obj = SecondInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            followLine2();
            redLine2();
        end
    end
end

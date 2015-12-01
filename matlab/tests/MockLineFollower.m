classdef MockLineFollower < LineFollower
    methods
        function obj = MockLineFollower(robot)
            obj@LineFollower(robot);
        end

        function followLineToInteraction(obj)
        end
    end
end

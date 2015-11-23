classdef (Abstract) Interaction < handle

    properties (GetAccess=protected)
        robot
    end

    methods (Static)
        function newInteraction = makeInteraction(type, robot)
            if strcmp(type, 'first')
                newInteraction = FirstInteraction(robot);
            end
        end
    end

    methods (Abstract)
        complete(obj)
    end

    methods
        function obj = Interaction(robot)
            obj.robot = robot;
        end
    end
end

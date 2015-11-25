classdef MockLineFinder < LineFinder
    methods
        function obj = MockLineFinder(robot)
            obj@LineFinder(robot);
        end

        function findLine(obj)
        end
    end
end

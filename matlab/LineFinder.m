classdef (Abstract) LineFinder < handle
    
    properties (Access=protected)
        robot
    end
    
    methods(Static)
        function newLineFinder = makeLineFinder(type, robot)
            if strcmp(type, 'basic')
                newLineFinder = BasicLineFinder(robot);
            elseif strcmp(type, 'mock')
                newLineFinder = MockLineFinder(robot);
            else
                error('Invalid LineFinder type');
            end
        end
    end
    
    methods (Abstract)
        findLine(obj);
    end
    
    methods
        function obj = LineFinder(robot)
            obj.robot = robot;
        end
    end
end


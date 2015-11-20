classdef LineFollower < handle

    properties (GetAccess=protected)
        side
        robot
    end

    properties (Constant)
        SIDE_LEFT = 0;
        SIDE_RIGHT = 1;
    end

    methods(Static)
        function newLineFollower = makeLineFollower(type, robot)
            if strcmp(type, 'drive_idle')
                newLineFollower = DriveIdleLineFollower(robot);
            end
        end
    end

    methods(Abstract)
        followLine(obj)
    end

    methods
        function obj = LineFollower(robot)
            obj.robot = robot;
            obj.side = LineFollower.SIDE_LEFT;
        end

        function side = getSide(obj)
            side = obj.side;
        end

        function setSide(obj, side)
            obj.side = side;
        end
    end
end

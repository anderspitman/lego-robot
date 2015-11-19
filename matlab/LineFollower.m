classdef LineFollower < handle
    properties (Constant)
        SIDE_LEFT = 0;
        SIDE_RIGHT = 1;
    end
    methods(Static)
        function newLineFollower = makeLineFollower(type, robot)
            if type == 'original'
                newLineFollower = DriveIdleLineFollower(robot);
            end
        end
    end
end

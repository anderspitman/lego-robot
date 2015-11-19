classdef DriveIdleLineFollower < LineFollower

    properties (GetAccess=private)
        drivePower
        idlePower
    end

    methods
        function obj = DriveIdleLineFollower(robot)
            obj@LineFollower(robot);

            obj.drivePower = 30;
            obj.idlePower = 20;
        end

        function followLine(obj)
            while true
                obj.iterate();
            end
        end

        function iterate(obj)
            positionState = obj.robot.getPositionState();

            if positionState == Robot.STATE_ON_LINE
                obj.curveAwayFromLine();
            elseif positionState == Robot.STATE_OFF_LINE
                obj.curveTowardLine();
            end
        end

        function curveAwayFromLine(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.curveLeft();
            elseif obj.side == LineFollower.SIDE_RIGHT
                obj.curveRight();
            end
        end

        function curveTowardLine(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.curveRight();
            elseif obj.side == LineFollower.SIDE_RIGHT
                obj.curveLeft();
            end
        end

        function curveLeft(obj)
            obj.robot.leftMotorForward(obj.drivePower);
            obj.robot.rightMotorReverse(obj.idlePower);
        end

        function curveRight(obj)
            obj.robot.leftMotorReverse(obj.idlePower);
            obj.robot.rightMotorForward(obj.drivePower);
        end
    end
end

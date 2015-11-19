classdef DriveIdleLineFollower < handle
    properties (Constant)
        SIDE_LEFT = 0;
        SIDE_RIGHT = 1;
    end

    properties (GetAccess=private)
        robot
        side
        drivePower
        idlePower
    end

    methods
        function obj = DriveIdleLineFollower(robot)
            obj.robot = robot;
            obj.side = DriveIdleLineFollower.SIDE_LEFT;
            obj.drivePower = 30;
            obj.idlePower = 20;
        end

        function side = getSide(obj)
            side = obj.side;
        end

        function setSide(obj, side)
            obj.side = side;
        end

        function followLine(obj)
            while true
                obj.iterate();
            end
        end

        function iterate(obj)
            positionState = obj.robot.getPositionState();

            if positionState == RobotInterface.STATE_ON_LINE
                obj.curveAwayFromLine();
            elseif positionState == RobotInterface.STATE_OFF_LINE
                obj.curveTowardLine();
            end
        end

        function curveAwayFromLine(obj)
            if obj.side == DriveIdleLineFollower.SIDE_LEFT
                obj.curveLeft();
            elseif obj.side == DriveIdleLineFollower.SIDE_RIGHT
                obj.curveRight();
            end
        end

        function curveTowardLine(obj)
            if obj.side == DriveIdleLineFollower.SIDE_LEFT
                obj.curveRight();
            elseif obj.side == DriveIdleLineFollower.SIDE_RIGHT
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

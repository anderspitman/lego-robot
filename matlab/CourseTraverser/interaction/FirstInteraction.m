classdef FirstInteraction < Interaction
    methods
        function obj = FirstInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            obj.moveALittleAwayFromFlag();
            obj.doCircle();
            obj.crossLine();
            obj.backUpToLine();
            obj.moveForwardOffLine();
        end
        
        function moveALittleAwayFromFlag(obj)
            obj.robot.reverseCentimeters(10, 60);
            obj.robot.rotateAngleDegrees(20, 60);
            obj.robot.forwardCentimeters(10, 60);
            obj.robot.rotateAngleDegrees(-20, 60);
        end
        
        function doCircle(obj)
            obj.robot.move(140, -20, 60);
        end
        
        function crossLine(obj)
            obj.robot.forwardCentimeters(20, 60);
            obj.robot.rotateAngleDegrees(-90, 60);
            obj.robot.forwardCentimeters(15, 60);
        end
        
        function backUpToLine(obj)
            obj.robot.straightReverse(30);
            positionState = Robot.STATE_OFF_LINE;
            while positionState ~= Robot.STATE_ON_LINE
                positionState = obj.robot.getPositionState();
            end
        end
        
        function moveForwardOffLine(obj)
            obj.robot.forwardCentimeters(5, 60);
        end
    end
end

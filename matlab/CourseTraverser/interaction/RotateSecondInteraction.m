classdef RotateSecondInteraction < Interaction
    methods
        function obj = RotateSecondInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            obj.robot.forwardCentimeters(7, 40);
            obj.robot.rotateAngleDegrees(90, 60);
            obj.robot.reverseCentimeters(2, 40);
            
            obj.pickUpBox();
            obj.putDownBox();
            obj.getBackOnLine();
        end
        
        function pickUpBox(obj)
            obj.robot.rotateArmDegrees(90, 20);
            % give hook time to stop swinging a little
            pause(1);
            obj.robot.rotateArmDegrees(90, 5);
            obj.robot.forwardCentimeters(3, 40);
            obj.robot.rotateArmDegrees(-90, 25);
            obj.robot.breakArm();
        end
        
        function putDownBox(obj)
            obj.robot.reverseCentimeters(10, 40);
            obj.robot.rotateAngleDegrees(90, 20);
            obj.robot.rotateArmDegrees(90, 5);
            obj.robot.reverseCentimeters(6, 60);
            obj.robot.rotateArmDegrees(-180, 20);
        end
        
        function getBackOnLine(obj)
            obj.robot.rotateAngleDegrees(150, 60);
        end
    end
end


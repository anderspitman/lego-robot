classdef RotateThirdInteraction < Interaction
    methods
        function obj = RotateThirdInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            obj.robot.forwardCentimeters(17, 40);
            obj.robot.rotateAngleDegrees(90, 60);
            obj.robot.reverseCentimeters(7, 40);
            
            obj.pickUpTrophy();
        end
        
        function pickUpTrophy(obj)
            obj.robot.rotateArmDegrees(90, 20);
            pause(3);
            obj.robot.rotateArmDegrees(65, 5);
            obj.robot.breakArm();
            pause(2);
            obj.robot.forwardCentimeters(10, 40);
            obj.robot.rotateArmDegrees(-90, 25);
            obj.robot.breakArm();
            %obj.robot.reverseCentimeters(10, 40);
        end
    end
end

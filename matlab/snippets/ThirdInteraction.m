classdef ThirdInteraction < Interaction
    methods
        function obj = ThirdInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            robot = obj.robot;
            brick = obj.robot.getBrick();
            followLine2()
            import lego.*;
            brick = NXT('0016530BAFBE');
            
            COLORPORT = lego.NXT.IN_1;
            brick.setSensorColorFull(COLORPORT)
            MOTORLEFT = lego.NXT.OUT_A;
            MOTORRIGHT = lego.NXT.OUT_C;
            
            % Starting arm position is all the way up
            % Sets Time in motor sync to turn for 90 deg
            ninetyDeg = 1.9;
            % Sets Time in motor sync to turn for 90 deg
            oneInch = .7;
            % Motor Power of arm
            armPowerFast = 30;
            armPowerSlow = 13;
            
            % Motor Power of drive motors)
            MotorPower = 25;
            
            fprintf('\nIdle Command %d\n\n')
            brick.motorRotate(NXT.OUT_B, armPowerFast,0);
            brick.motorBrake(NXT.OUT_B);
            pause(1);
            
            fprintf('\nDrive forward to set hook %d\n')
            brick.motorReverseSync(NXT.OUT_AC, MotorPower,0);
            pause(oneInch*1);
            brick.motorBrake(NXT.OUT_AC);
            
            fprintf('\nDrive forward to set hook %d\n')
            brick.motorForwardSync(NXT.OUT_AC, MotorPower,45);
            pause(oneInch*.25);
            brick.motorBrake(NXT.OUT_AC);
            
            fprintf('\n Rapid arm to location %d\n\n')
            brick.motorRotate(NXT.OUT_B, armPowerSlow, 90);
            brick.motorBrake(NXT.OUT_B);
            pause(4);
            
            fprintf('\n Fine tune arm to touch floor %d\n\n')
            brick.motorRotate(NXT.OUT_B, armPowerSlow, 18);
            brick.motorBrake(NXT.OUT_B);
            pause(4);
            
            fprintf('\nDrive forward to set hook %d\n')
            brick.motorForwardSync(NXT.OUT_AC, MotorPower,0);
            pause(oneInch*1.8);
            brick.motorBrake(NXT.OUT_AC);
            
            pause(1);
            fprintf('\nLift crate out of pen %d\n')
            brick.motorRotate(NXT.OUT_B, armPowerFast, -50);
            pause(5)
            
            brick.motorCoast(NXT.OUT_B)
            
        end
    end
end

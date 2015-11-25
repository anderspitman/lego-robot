classdef SecondInteraction < Interaction
    methods
        function obj = FirstInteraction(robot)
            obj@Interaction(robot);
        end

        function complete(obj)
            batteryLife = robot.getBatteryLevel();
            % Starting arm position is all the way up
            % Sets Time in motor sync to turn for 90 deg
            ninetyDeg = 1.9;
            % Sets Time in motor sync to turn for 90 deg
            oneInch = .7;
            % Motor Power of arm
            armPowerFast = 30;
            armPowerSlow = 13;
            
            armPowerFast = armPowerFast*(1+1-batteryLife);
            armPowerSlow = armPowerSlow*(1+1-batteryLife);
            % Motor Power of drive motors)
            MotorPower = 25;
            MotorPower = MotorPower*(1+1-batteryLife);            
            
            fprintf('\nIdle Command %d\n\n')
            robot.brick.motorRotate(NXT.OUT_B, armPowerFast,0);
            robot.brick.motorBrake(NXT.OUT_B);
            pause(1);
            
            fprintf('\n Rapid arm to location %d\n\n')
            robot.brick.motorRotate(NXT.OUT_B, armPowerSlow, 145);
            robot.brick.motorBrake(NXT.OUT_B);
            pause(4);
            
            fprintf('\n Slightly back up to clear crate %d\n')
            robot.brick.motorReverseSync(NXT.OUT_AC, MotorPower,0);
            pause(oneInch*1);
            robot.brick.motorBrake(NXT.OUT_AC);
            pause(2)
            
            fprintf('\n Fine tune arm to touch floor %d\n\n')
            robot.brick.motorRotate(NXT.OUT_B, armPowerSlow, 20);
            robot.brick.motorBrake(NXT.OUT_B);
            pause(4);
            
            fprintf('\nDrive forward to set hook %d\n')
            robot.brick.motorForwardSync(NXT.OUT_AC, MotorPower,0);
            pause(oneInch*1.5);
            robot.brick.motorBrake(NXT.OUT_AC);
            
            pause(1);
            fprintf('\nLift crate out of pen %d\n')
            robot.brick.motorRotate(NXT.OUT_B, armPowerFast, -115);
            pause(5)
            
            fprintf('\nBack Up %d\n')
            robot.brick.motorReverseSync(NXT.OUT_AC, MotorPower, 0);
            pause(oneInch*1);
            pause(1)
            robot.brick.motorBrake(NXT.OUT_AC);
            pause(1);
            
            fprintf('\nRotate to left of container %d\n')
            robot.brick.motorReverseSync(NXT.OUT_AC,MotorPower,90);
            pause(ninetyDeg);
            robot.brick.motorBrake(NXT.OUT_AC);
            
            fprintf('\nGo Forward 2 inches%d\n')
            robot.brick.motorForwardSync(NXT.OUT_AC, MotorPower,0);
            pause(oneInch*2);
            robot.brick.motorBrake(NXT.OUT_AC);
            
            fprintf('\nLower Crate %d\n')
            robot.brick.motorRotate(NXT.OUT_B, armPowerSlow, 110);
            pause(2)
            
            fprintf('\nBack up to release crate %d\n')
            robot.brick.motorReverseSync(NXT.OUT_AC, MotorPower,0);
            pause(oneInch*2);
            robot.brick.motorBrake(NXT.OUT_AC);
            pause(1)
            
            fprintf('\nRaise Arm Back Up %d\n')
            robot.brick.motorRotate(NXT.OUT_B, armPowerFast, -180);
            pause(4)
            robot.brick.motorCoast(NXT.OUT_B);
            
            fprintf('\nRotate to left of container %d\n')
            robot.brick.motorReverseSync(NXT.OUT_AC,MotorPower,-90);
            pause(ninetyDeg*2);
            robot.brick.motorBrake(NXT.OUT_AC);
            
            fprintf('\nGo Forward 2 inches%d\n')
            robot.brick.motorForwardSync(NXT.OUT_AC, MotorPower,0);
            pause(oneInch*2);
            robot.brick.motorBrake(NXT.OUT_AC);
            
            robot.brick.motorCoast(NXT.OUT_B)

        end
    end
end

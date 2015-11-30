function redLine2()

% Make Connection
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

fprintf('\n Rapid arm to location %d\n\n')
brick.motorRotate(NXT.OUT_B, armPowerSlow, 146);
brick.motorBrake(NXT.OUT_B);
pause(4);

fprintf('\n Slightly back up to clear crate %d\n')
brick.motorReverseSync(NXT.OUT_AC, MotorPower,0);
pause(oneInch*1);
brick.motorBrake(NXT.OUT_AC);
pause(2)

fprintf('\n Fine tune arm to touch floor %d\n\n')
brick.motorRotate(NXT.OUT_B, armPowerSlow, 20);
brick.motorBrake(NXT.OUT_B);
pause(4);

fprintf('\nDrive forward to set hook %d\n')
brick.motorForwardSync(NXT.OUT_AC, MotorPower,0);
pause(oneInch*2);
brick.motorBrake(NXT.OUT_AC);

pause(1);
fprintf('\nLift crate out of pen %d\n')
brick.motorRotate(NXT.OUT_B, armPowerFast, -115);
pause(5)

fprintf('\nBack Up %d\n')
brick.motorReverseSync(NXT.OUT_AC, MotorPower, 0);
pause(oneInch*1);
pause(1)
brick.motorBrake(NXT.OUT_AC);
pause(1);

fprintf('\nRotate to left of container %d\n')
brick.motorReverseSync(NXT.OUT_AC,MotorPower,90); 
pause(ninetyDeg);
brick.motorBrake(NXT.OUT_AC);

fprintf('\nGo Forward 2 inches%d\n')
brick.motorForwardSync(NXT.OUT_AC, MotorPower,0); 
pause(oneInch*2);
brick.motorBrake(NXT.OUT_AC);

fprintf('\nLower Crate %d\n')
brick.motorRotate(NXT.OUT_B, armPowerSlow, 110);
pause(2)

fprintf('\nBack up to release crate %d\n')
brick.motorReverseSync(NXT.OUT_AC, MotorPower,0); 
pause(oneInch*2);
brick.motorBrake(NXT.OUT_AC);
pause(1)

fprintf('\nRaise Arm Back Up %d\n')
brick.motorRotate(NXT.OUT_B, armPowerFast, -180);
pause(4)
brick.motorCoast(NXT.OUT_B);

fprintf('\nRotate to left of container %d\n')
brick.motorReverseSync(NXT.OUT_AC,MotorPower,-90); 
pause(ninetyDeg*2.1);
brick.motorBrake(NXT.OUT_AC);

fprintf('\nGo Forward 2 inches%d\n')
brick.motorForwardSync(NXT.OUT_AC, MotorPower,0); 
pause(oneInch*2.5);
brick.motorBrake(NXT.OUT_AC);

brick.motorCoast(NXT.OUT_B)

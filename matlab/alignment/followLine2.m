function followLine2()
%After being aligned to blue line and seeing red line for 2nd interaction
% This progams aligns the robot to the center of the interaction


import lego.*
brick = lego.NXT('0016530BAFBE');

COLORPORT = lego.NXT.IN_1;
brick.setSensorColorFull(COLORPORT)
MOTORLEFT = lego.NXT.OUT_A;
MOTORRIGHT = lego.NXT.OUT_C;

Power = 40
Seconds = .5
NinetyDeg = .95
%See Line
%Back Up
brick.motorReverseSync(NXT.OUT_AC, Power,0);
pause(Seconds*1);
brick.motorBrake(NXT.OUT_AC);
%Turn Right
brick.motorReverseSync(NXT.OUT_AC, Power,-90);
pause(NinetyDeg);
brick.motorBrake(NXT.OUT_AC);
% Go Forward
brick.motorForwardSync(NXT.OUT_AC, Power,0);
pause(Seconds*1.5);
brick.motorBrake(NXT.OUT_AC);
%Turn Left
brick.motorForwardSync(NXT.OUT_AC, Power,90);
pause(NinetyDeg*1.);
brick.motorBrake(NXT.OUT_AC);
%Go Forward to Past Red Line
brick.motorForwardSync(NXT.OUT_AC, Power,0);
pause(Seconds*2.4);
brick.motorBrake(NXT.OUT_AC);
%Turn Left
brick.motorForwardSync(NXT.OUT_AC, Power,90);
pause(NinetyDeg);
brick.motorBrake(NXT.OUT_AC);
%Go Forward
brick.motorForwardSync(NXT.OUT_AC, Power,0);
pause(Seconds*1.1);
brick.motorBrake(NXT.OUT_AC);
brick.motorCoast(NXT.OUT_AC);
end



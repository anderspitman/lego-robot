function WholeProgram()
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

brick = lego.NXT('0016530BAFBE');
import lego.*

COLORPORT = lego.NXT.IN_1;
MOTORLEFT = lego.NXT.OUT_A;
MOTORRIGHT = lego.NXT.OUT_C;
brick.setSensorColorFull(COLORPORT)


%followLine1()
followLineLeft()
followLine2()
%Aligns robot to center of 3rd interaction
followLine3()
%Stops robot
brick.motorBrake(NXT.OUT_AC);
brick.motorCoast(NXT.OUT_AC);
%Runs 2nd interaction
redLine2()
end


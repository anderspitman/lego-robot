function followLine1()
%Aligns true to blue line from right of line

COLOR_LINE = 2; %blue
COLOR_INTERACT = 5; %red
COLOR_BG = 6; %white
Power = 20

import lego.*
brick = lego.NXT('0016530BAFBE');

COLORPORT = lego.NXT.IN_1;
brick.setSensorColorFull(COLORPORT)
MOTORLEFT = lego.NXT.OUT_A;
MOTORRIGHT = lego.NXT.OUT_C;

%BlueColorPowerML = 6;
%BlueColorPowerMR = 7;
%WhiteColorPowerML = 7;
%WhiteColorPowerMR = 6;


while true
    fprintf('color: %d\n', brick.sensorValue(COLORPORT));
    
    %on line
    if (isOnLine(brick.sensorValue(COLORPORT)))
        %steer right
        brick.motorReverseSync(NXT.OUT_AC, 15,-20);
        
    %    brick.motorForwardReg(MOTORRIGHT, BlueColorPowerML);
    %    brick.motorForwardReg(MOTORLEFT, BlueColorPowerMR);

    elseif (brick.sensorValue(COLORPORT) == COLOR_BG)
        brick.motorForwardSync(NXT.OUT_AC, 20,5);
    %    brick.motorForwardReg(MOTORRIGHT, WhiteColorPowerML);
    %    brick.motorForwardReg(MOTORLEFT, WhiteColorPowerMR);
         %steer left]
         
    elseif (brick.sensorValue(COLORPORT) == COLOR_INTERACT)
     brick.motorBrake(NXT.OUT_AC);
       break
    end
end


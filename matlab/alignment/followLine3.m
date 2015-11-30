function followLine3()
%After being aligned to center of interaction this program stops the robot
%When it sees blue line it will stop



import lego.*
brick = lego.NXT('0016530BAFBE');

COLORPORT = lego.NXT.IN_1;
brick.setSensorColorFull(COLORPORT)
MOTORLEFT = lego.NXT.OUT_A;
MOTORRIGHT = lego.NXT.OUT_C;


COLOR_LINE = 2; %blue
COLOR_INTERACT = 5; %red
COLOR_BG = 6; %white

while true
    %fprintf('color: %d\n', brick.sensorValue(COLORPORT));
    %on line
    if (brick.sensorValue(COLORPORT) == COLOR_BG)
        brick.motorForwardSync(NXT.OUT_AC,20,0);
         %steer left]
    elseif (brick.sensorValue(COLORPORT) == COLOR_LINE)
       break
    end
end


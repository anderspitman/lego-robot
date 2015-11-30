function SeeRedLine()
%Hit Red Line, then rotate right until hit blue line

import lego.*
brick = lego.NXT('0016530BAFBE');

COLOR_LINE = 2; %blue
COLOR_INTERACT = 5; %red
COLOR_BG = 6; %white
Power = 20

COLORPORT = lego.NXT.IN_1;
brick.setSensorColorFull(COLORPORT)

MOTORLEFT = lego.NXT.OUT_A;
MOTORRIGHT = lego.NXT.OUT_C;




%Turn around
while brick.sensorValue(COLORPORT) ~= COLOR_LINE
    {
    fprintf('color: %d\n', brick.sensorValue(COLORPORT));
    brick.motorReverseSync(NXT.OUT_AC, 20,95)
     }
end
%Run down the line for a bit
    tic
    while toc < 3
    fprintf('color: %d\n', brick.sensorValue(COLORPORT));
    if (brick.sensorValue(COLORPORT) == COLOR_LINE)
        brick.motorReverseSync(NXT.OUT_AC, 20,-25);
        
    elseif (brick.sensorValue(COLORPORT) == COLOR_BG)
        brick.motorReverseSync(NXT.OUT_AC, 20,25);
         
    elseif (brick.sensorValue(COLORPORT) == COLOR_INTERACT)
       break
    end
    end
%Turn back around
    while true
    %fprintf('color: %d\n', brick.sensorValue(COLORPORT));
    if (brick.sensorValue(COLORPORT) == COLOR_LINE)
       break
    elseif (brick.sensorValue(COLORPORT) == COLOR_INTERACT)
       brick.motorReverseSync(NXT.OUT_AC, 5,25)
    elseif (brick.sensorValue(COLORPORT) == COLOR_BG)
       brick.motorReverseSync(NXT.OUT_AC, 5,25)
    end
%Run down the line till red
    while true
    fprintf('color: %d\n', brick.sensorValue(COLORPORT));
    if (brick.sensorValue(COLORPORT) == COLOR_LINE)
        brick.motorReverseSync(NXT.OUT_AC, 10,-25);
        
    elseif (brick.sensorValue(COLORPORT) == COLOR_BG)
        brick.motorReverseSync(NXT.OUT_AC, 5,25);
         
    elseif (brick.sensorValue(COLORPORT) == COLOR_INTERACT)
       break
    end
    end
    end
end

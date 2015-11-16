function followLine( brick )
%FOLLOWLINE Follows a blue line with a white background
import lego.*

COLORPORT = lego.NXT.IN_1;
MOTORLEFT = lego.NXT.OUT_A;
MOTORRIGHT = lego.NXT.OUT_C;

COLOR_LINE = 2; %blue
COLOR_INTERACT = 5; %red
COLOR_BG = 6; %white

DRIVEPOWER = 50;
IDLEPOWER = 35;

% FIXME: error check
brick.setSensorColorFull(COLORPORT)

while true
    fprintf('color: %d\n', brick.sensorValue(COLORPORT));
    
    %on line
    if (brick.sensorValue(COLORPORT) == COLOR_LINE)
        %steer right
        brick.motorForward(MOTORLEFT, DRIVEPOWER);
        brick.motorReverse(MOTORRIGHT, IDLEPOWER);
    %elseif (brick.sensorValue(COLORPORT) == COLOR_INTERACT)
    %    %interact
    elseif (brick.sensorValue(COLORPORT) == COLOR_BG)
        brick.motorReverse(MOTORLEFT, IDLEPOWER);
        brick.motorForward(MOTORRIGHT, DRIVEPOWER);
         %steer left
    end
    
    
end

end


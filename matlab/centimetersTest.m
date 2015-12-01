clear
robot = LegoRobot();

brick = robot.getBrick();
brick.motorReverseSync(lego.NXT.OUT_AC, 25, -25);
pause(2);
brick.motorForwardSync(lego.NXT.OUT_AC, 25, 25);
pause(2);
robot.allStop();
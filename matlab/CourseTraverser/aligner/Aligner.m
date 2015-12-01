classdef Aligner < handle
    properties (Access=private)
        side
        robot
    end
    
    methods(Static)
        function newAligner = makeAligner(robot)
            newAligner = Aligner(robot);
        end
    end

    methods (Access=private)
        function obj = Aligner(robot)
            obj.robot = robot;
            obj.side = LineFollower.SIDE_LEFT;
        end
    end

    methods
        function setSide(obj, side)
            obj.side = side;
        end

        function backUpABit(obj)
            positionState = Robot.STATE_OFF_LINE;
            
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightReverse(20);
                positionState = obj.robot.getPositionState();
            end
            
            while positionState ~= Robot.STATE_OFF_LINE
                obj.robot.straightReverse(30);
                positionState = obj.robot.getPositionState();
            end

            obj.robot.straightReverse(60);
            pause(.4);
            obj.robot.allStop();

            obj.rotateTowardLine();
            
            while positionState ~= Robot.STATE_ON_LINE
                obj.robot.straightForward(30);
                positionState = obj.robot.getPositionState();
            end

            obj.robot.allStop();

        end

        function rotateTowardLine(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.robot.rotateAngleTime(-50);
            else
                obj.robot.rotateAngleTime(50);
            end
        end

        function fullAlign(obj)
            obj.backUpABit();
            obj.followLine();
            obj.robot.straightReverse(25);
            pause(2.0);
            obj.robot.allStop();
            obj.alignForSecondAlignPass();
            obj.followLine();
        end
        
        function alignForSecondAlignPass(obj)
            if obj.side == LineFollower.SIDE_LEFT
                obj.robot.leftMotorForward(30);
                obj.robot.rightMotorForward(10);
            else
                obj.robot.leftMotorForward(10);
                obj.robot.rightMotorForward(30);
            end
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_LINE;
                positionState = obj.robot.getPositionState();
            end
            obj.robot.allStop();
        end
        
        function followLine(obj)
            brick = obj.robot.getBrick();

            if obj.side == LineFollower.SIDE_LEFT
                powerAwayFromLine = 25;
                turnPercentAwayFromLine = 25;
                powerTowardLine = 25;
                turnPercentTowardLine = -5;
            else
                powerAwayFromLine = 25;
                turnPercentAwayFromLine = -25;
                powerTowardLine = 25;
                turnPercentTowardLine = 5;
            end

            while true
                %fprintf('color: %d\n', brick.sensorValue(COLORPORT));
                
                positionState = obj.robot.getPositionState();
                    
                if positionState == Robot.STATE_ON_LINE
                    brick.motorReverseSync(...
                        lego.NXT.OUT_AC,...
                        powerAwayFromLine,...
                        turnPercentAwayFromLine);

                elseif positionState == Robot.STATE_OFF_LINE
                    brick.motorForwardSync(...
                        lego.NXT.OUT_AC,...
                        powerTowardLine,...
                        turnPercentTowardLine);

                elseif positionState == Robot.STATE_ON_INTERACTION
                    brick.motorBrake(lego.NXT.OUT_AC);
                    break
                end
            end
        end
    end
end

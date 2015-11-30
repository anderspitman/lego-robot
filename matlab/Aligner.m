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
                powerSteerRight = 15
                turnPercentSteerRight = 25
                powerSteerLeft = 15
                turnPercentSteerLeft = -5
            else
                powerSteerRight = 15
                turnPercentSteerRight = -20
                powerSteerLeft = 20
                turnPercentSteerLeft = 5
            end

            while true
                fprintf('color: %d\n', brick.sensorValue(COLORPORT));
                    
                %on line
                if (isOnLine(brick.sensorValue(COLORPORT)))
                    %steer right
                    brick.motorReverseSync(...
                        NXT.OUT_AC,...
                        powerSteerRight,...
                        turnPercentSteerRight);

                elseif (brick.sensorValue(COLORPORT) == COLOR_BG)
                    brick.motorForwardSync(...
                        NXT.OUT_AC,...
                        powerSteerLeft,...
                        turnPercentSteerLeft);

                elseif (brick.sensorValue(COLORPORT) == COLOR_INTERACT)
                    brick.motorBrake(NXT.OUT_AC);
                    break
                end
            end
        end
    end
end

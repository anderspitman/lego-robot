        function fineAlign(obj)
            obj.backOffLine();
            obj.back1CM();
            
%            currDistance = obj.measureDistanceToLine();
%            fprintf('Distance to line: %f\n', currDistance);
            
%             prevDistance = 1000;
%             while prevDistance > currDistance
%                 prevDistance = currDistance;
%                 obj.rotateCCW();
%                 currDistance = obj.measureDistanceToLine();
%                 fprintf('Distance to line: %f\n', currDistance);
%             end
%             obj.rotateCW();
%             
%             obj.forwardToInteractionLine();
            
            currTime = obj.measureTimeToLine();
            fprintf('Time to line: %f\n', currTime);
            
            prevTime = 1000;
            while prevTime > currTime
                prevTime = currTime;
                obj.rotateCCW();
                currTime = obj.measureTimeToLine();
                fprintf('Time to line: %f\n', currTime);
            end
            obj.rotateCW();
            
            obj.forwardToInteractionLine();
            
        end
        
        function rotateCCW(obj)
            speed = 5;
            obj.robot.motorForwardRegulated(LegoRobot.RIGHT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.LEFT_MOTOR, speed);
            pause(.5);
        end
        
        function rotateCW(obj)
            speed = 5;
            obj.robot.motorForwardRegulated(LegoRobot.LEFT_MOTOR, speed);
            obj.robot.motorReverseRegulated(LegoRobot.RIGHT_MOTOR, speed);
            pause(.5);
        end
        
        function timeThroughLineAvg = measureTimeToLine(obj)
            
            numToAverage = 1;
            for i = 1:numToAverage
                speed = 2;
                positionState = obj.robot.getPositionState();

                tic;
                while positionState ~= Robot.STATE_ON_INTERACTION
                    obj.robot.straightForwardRegulated(speed);
                    positionState = obj.robot.getPositionState();
                end
                timeToLine = toc;

                tic;
                while positionState == Robot.STATE_ON_INTERACTION
                    obj.robot.straightForwardRegulated(speed);
                    positionState = obj.robot.getPositionState();
                end

                timeThroughLine(i) = toc;

                % undo movement
                obj.robot.straightReverseRegulated(speed);
                pause((timeToLine + timeThroughLine(i)))
            end
            timeThroughLineAvg = sum(timeThroughLine) / numToAverage;
            obj.robot.allStop();
        end
        
%         function distanceToLine = measureDistanceToLine(obj)
%             speed = 15;
%             degreesStep = 3;
%             positionState = obj.robot.getPositionState();
%             
%             degreesCount = 0;
%             while positionState ~= Robot.STATE_ON_INTERACTION
%                 obj.robot.moveDegrees(degreesStep, speed);
%                 degreesCount = degreesCount + degreesStep;
%                 positionState = obj.robot.getPositionState();
%             end
%             
%             % undo movement
%             for i = 1:degreesCount
%                 obj.robot.moveDegrees(-degreesStep, speed);
%             end
%             
%             distanceToLine = degreesCount;
%         end
        
        function backOffLine(obj)
            positionState = obj.robot.getPositionState();
            
            % Just in case we overshot the red line
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightReverseRegulated(5);
                positionState = obj.robot.getPositionState();
            end
            
            while positionState ~= Robot.STATE_OFF_LINE
                obj.robot.straightReverseRegulated(5);
                positionState = obj.robot.getPositionState();
            end
        end
        
        function back1CM(obj)
            obj.robot.straightReverseRegulated(10);
            pause(.3);
        end
        
        function forwardToInteractionLine(obj)
            positionState = obj.robot.getPositionState();
            
            while positionState ~= Robot.STATE_ON_INTERACTION
                obj.robot.straightForwardRegulated(5);
                positionState = obj.robot.getPositionState();
            end
        end


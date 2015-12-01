classdef SongPlayer < handle
    
    properties (Access=private)
        robot;
    end
    
    methods (Static)
        function newSongPlayer = makeSongPlayer()
            newSongPlayer = SongPlayer();
        end
    end
    
    methods
        function obj = SongPlayer()
            obj.robot = Robot.makeRobot('lego');
        end
        
        function playSong(obj)
            obj.playTone(392, 0.17);
            obj.playTone(523, 0.17);
            obj.playTone(659, 0.17);
            obj.playTone(784, 0.38);
            obj.playTone(659, 0.13);
            obj.playTone(784, 1.0);
        end

        function playTone(obj, frequency, durationSeconds)
            brick = obj.robot.getBrick();
            durationMilliseconds = durationSeconds*1000;
            brick.playTone(frequency, durationMilliseconds);
            pause(durationSeconds);
        end
    end
end
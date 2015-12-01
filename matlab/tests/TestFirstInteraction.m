classdef TestFirstInteraction < matlab.unittest.TestCase
    methods (Test)
        function testConstructor(obj)
            robot = MockRobot();
            interaction = Interaction.makeInteraction('first', robot);
        end
    end
end

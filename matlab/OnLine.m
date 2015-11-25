classdef OnLine < State
    methods
        function foundInteraction = iterate(obj, lineFollower)
            lineFollower.backUp();
            lineFollower.rotateAwayFromLine();
        end
    end
end

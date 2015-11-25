classdef OffLine < State
    methods
        function foundInteraction = iterate(obj, lineFollower)
            lineFollower.arcTowardLine();
        end
    end
end

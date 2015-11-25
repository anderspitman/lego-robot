classdef (Abstract) LineState < handle
    properties (Constant)
        HIGH_POWER_PERCENT = 60;
        LOW_POWER_PERCENT = 20;
    end

    methods (Abstract)
        rotateAwayFromLine(obj, robot);
    end
end

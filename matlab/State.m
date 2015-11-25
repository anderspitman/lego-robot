classdef (Abstract) State < handle
    methods (Abstract)
        iterate(obj);
    end
end

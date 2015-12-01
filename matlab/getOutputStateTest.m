function getOutputStateTest()

    brick = lego.NXT('0016530BAFBE');

    brick.motorRotate(lego.NXT.OUT_C, 20, 720);

    while true
        outputState = brick.getOutputState(lego.NXT.OUT_C);
        printVal('port', outputState.port);
        printVal('powerSetPoint', outputState.powerSetPoint);
        printVal('mode', outputState.mode);
        printVal('regulationMode', outputState.regulationMode);
        %printVal('turnRatio', outputState.turnRatio);
        printVal('runState', outputState.runState);
        printVal('tachoLimit', outputState.tachoLimit);
        printVal('tachoCount', outputState.tachoCount);
        printVal('blockTachoCount', outputState.blockTachoCount);
        printVal('rotationCount', outputState.rotationCount);
        fprintf('\n\n\n');
        pause(.1);
    end
end

function printVal(text, val)
    fprintf('%s: %f\n', text, val);
end
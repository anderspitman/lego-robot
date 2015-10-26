function equation(xstart, xstop, xinc, flag)
    % flag = 1, Print table
    % flag = 2, Make plot
    % flag = 3, Print table and make plot

    if shouldPrintTable(flag)
        printHeader();
    end
    
    x = xstart;
    index = 1;
    while x <= xstop
        y = x^3 - 6;
        
        xVals(index) = x;
        yVals(index) = y;
        
        if shouldPrintTable(flag)
            printLine(x, y);
        end
        
        x = x + xinc;
        index = index + 1;
    end
    
    if shouldPrintTable(flag)
        printFooter();
    end
    
    if shouldMakePlot(flag)
        plot(xVals, yVals);
    end

end

function [shouldPrint] = shouldPrintTable(flag)
    shouldPrint = (flag == FLAG_PRINT_TABLE()) ||...
                  (flag == FLAG_TABLE_AND_PLOT());
end

function [shouldMake] = shouldMakePlot(flag)
    shouldMake = (flag == FLAG_MAKE_PLOT()) ||...
                 (flag == FLAG_TABLE_AND_PLOT());
end

function [value] = FLAG_PRINT_TABLE()
    value = 1;
end

function [value] = FLAG_MAKE_PLOT()
    value = 2;
end

function [value] = FLAG_TABLE_AND_PLOT()
    value = 3;
end

function printHeader()
    printHorizontalSeparator();
    fprintf('|    %s    |    %s    |\n', 'X', 'Y');
    printHorizontalSeparator();
end

function printFooter()
    printHorizontalSeparator();
end

function printHorizontalSeparator()
        fprintf('---------------------\n');
end

function printLine(x, y)

    fprintf('| %7.2f | %7.2f |\n', x, y);

end
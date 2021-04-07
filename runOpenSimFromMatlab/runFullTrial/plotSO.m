function [] = plotSO(activationFile, cycle)
%RUNIK Summary of this function goes here
%   Detailed explanation goes here
    data = load_sto_file(activationFile);
    data_cell = struct2cell(data);
    
    fields = fieldnames(data);
    
    figure('right side');
    hold on;
    for i = 2 : 44
        temp = normalizetimebase(data_cell{i}(cycle.left.start : cycle.left.end));
        plot( 0:100, temp);
    end
    title('right');
    legend(fields{2:44}, 'Interpreter', 'none');
    enlargeFigure;
    
    figure('left side');
    hold on;
    for i = 45 : 87
        temp = normalizetimebase(data_cell{i}(cycle.right.start : cycle.right.end));
        plot( 0:100, temp);
    end
    title('left');
    legend(fields{45:87}, 'Interpreter', 'none');
    enlargeFigure;

end
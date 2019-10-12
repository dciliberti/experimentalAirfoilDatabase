close all; clear; clc

% Input data
saveFiguresFlag = 0;
numberOfSections = 1;
airfoilType = {'sc'};
localReynolds = [6E6];
thicknessRatio = [9];

% Call airfoil database
[localClMax, localClAlfa, localAlfaStar, localAlfaStall, localClZero,...
    localAlfaZeroLift, localCdMin, localK, localCli, localCmc4] = ...
    airfoilDatabase(numberOfSections,airfoilType,localReynolds,thicknessRatio);
localClStar = localClAlfa .* (localAlfaStar - localAlfaZeroLift);

% Generate figures
for i = 1:numberOfSections
    
    A = [localAlfaStar(i)^3, localAlfaStar(i)^2, localAlfaStar(i), 1; ...
        localAlfaStall(i)^3, localAlfaStall(i)^2, localAlfaStall(i), 1; ...
        3*localAlfaStar(i)^2, 2*localAlfaStar(i), 1, 0; ...
        3*localAlfaStall(i)^2, 2*localAlfaStall(i), 1, 0];
    b = [localClStar(i), localClMax(i), localClAlfa(i), 0]';
    x = A\b;
    
    % Lift curve
    alfaLinear = localAlfaZeroLift(i):localAlfaStar(i);
    alfaNonLinear = localAlfaStar(i):0.1:localAlfaStall+3;
    clLinear = localClAlfa(i) .* (alfaLinear - localAlfaZeroLift(i));
    clNonLinear = x(1)*alfaNonLinear.^3 + x(2)*alfaNonLinear.^2 + ...
        x(3)*alfaNonLinear + x(4);
    
    % Use a parabola instead of a cubic curve, if the reconstructed curve goes
    % beyond Clmax, which falls on a local minimum instead of the maximum
    if round(max(clNonLinear),2) > round(localClMax(i),2)
        A = [localAlfaStar(i)^2, localAlfaStar(i), 1; ...
            localAlfaStall(i)^2, localAlfaStall(i), 1; ...
            2*localAlfaStall(i), 1, 0];
        b = [localClStar(i), localClMax(i), 0]';
        x = A\b;
        clNonLinear = x(1)*alfaNonLinear.^2 + x(2)*alfaNonLinear + x(3);
        disp('Using a parabola instead of a cubic curve')
    end
    
    % Cut the curve if in post-stall decrease too much
    while clNonLinear(end) < localClStar(i)
        alfaNonLinear = alfaNonLinear(1:end-1);
        clNonLinear = clNonLinear(1:end-1);
    end
    
    alfaArray = [alfaLinear, alfaNonLinear];
    clArray = [clLinear, clNonLinear];
    
    % Drag polar
    cdArray = localCdMin(i) + localK(i) * (clArray - localCli(i)).^2;
    
    % Plot
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1)  % Lift curve
    plot(alfaArray,clArray,'k','LineWidth',2)
    grid on, xlabel('Angle of attack, deg'), ylabel('Lift Coefficient')
    title(['Lift curve of section ', num2str(i), ', Re = ', num2str(localReynolds(i))])
    
    subplot(1,2,2)  % Drag polar
    plot(cdArray,clArray,'k','LineWidth',2)
    ax = gca;   ax.XLim(1) = 0;
    grid on, xlabel('Drag coefficient'), ylabel('Lift Coefficient')
    title(['Lift curve of section ', num2str(i), ', Re = ', num2str(localReynolds(i))])
    
end

% Export all figures (if requested)
if saveFiguresFlag == 1
    outputFiguresFolder = 'outputFiguresMatlab';   % Destination folder
    % If folder does not exist, create it
    if ~isfolder(outputFiguresFolder)
        mkdir(outputFiguresFolder)
        % If it does exist, delete content before exporting new figures
    else
        delete outputFiguresFolder/*.png
    end
    
    % List all figures and save them
    FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
    for iFig = 1:length(FigList)
        FigHandle = FigList(iFig);
        FigNumber   = get(FigHandle, 'Number');
        saveas(FigHandle, fullfile(outputFiguresFolder, ['fig', num2str(FigNumber),'.png']));
    end
end
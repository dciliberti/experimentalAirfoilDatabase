% This code returns the lift curve and drag polar of an airfoil from
% experimental data. Input data are airfoil type (chosen among 4-digits,
% 5-digits, 6-series, and supercritical, the first three can be symmetric
% or asymmetric), Reynolds number and relative thickness.
%
%     Copyright (C) 2020  Danilo Ciliberti danilo.ciliberti@unina.it
% 
%     This program is free software: you can redistribute it and/or modify
%     it under the terms of the GNU General Public License as published by
%     the Free Software Foundation, either version 3 of the License, or
%     (at your option) any later version.
% 
%     This program is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with this program.  If not, see <https://www.gnu.org/licenses/>

close all; clear; clc

% Input data
saveFiguresFlag = 1;        % write png figures on disk (yes = 1; no = 0)
numberOfSections = 4;       % scalar, how many section to analyze
airfoilType = {'4a', '5a', '6a', 'sc'};       % cell array of char arrays
localReynolds = [6E6, 6E6, 6E6, 6E6];      % numeric array, Reynolds number of each section
thicknessRatio = [12, 15, 10, 8];       % numeric array, percentage relative thickness
bezierFlag = 1;             % switch to 1 to plot Bezier curve control points

% airfoilType may be one of the following:
%   '4s'    symmetric 4-digit NACA airfoil
%   '4a'    asymmetric 4-digit NACA airfoil
%   '5s'    symmetric 5-digit NACA airfoil
%   '5a'    asymmetric 5-digit NACA airfoil
%   '6s'    symmetric 6-series NACA airfoil
%   '6a'    asymmetric 6-series NACA airfoil
%   'sc'    NASA supercritical airfoil

% Call airfoil database
[localClMax, localClAlfa, localAlfaStar, localAlfaStall, localClZero,...
    localAlfaZeroLift, localCdMin, localK, localCli, localCmc4] = ...
    airfoilDatabase(numberOfSections,airfoilType,localReynolds,thicknessRatio);
localClStar = localClAlfa .* (localAlfaStar - localAlfaZeroLift);

% Generate figures
for i = 1:numberOfSections
    
    % Lift curve: linear range
    alfaLinear = linspace(localAlfaZeroLift(i),localAlfaStar(i));
    clLinear = localClAlfa(i) * (alfaLinear - localAlfaZeroLift(i));
    
    % Lift curve: non-linear range
    alfa1 = (localClMax(i) - localClStar(i)) / localClAlfa(i) + localAlfaStar(i);
    if alfa1 > localAlfaStall(i)
        localAlfaStall(i) = alfa1; % otherwise slope in the non-linear range increases!
    end
    cl1 = localClMax(i);
    
    c = 0;
    for t = 0:0.1:1     % reconstruction with a quadratic Bezier curve
        c = c + 1;
        alfaNonLinear(c) = (1-t)^2*localAlfaStar(i) + 2*t*(1-t)*alfa1 + t^2*localAlfaStall(i); %#ok<*SAGROW>
        clNonLinear(c) = (1-t)^2*localClStar(i) + 2*t*(1-t)*cl1 + t^2*localClMax(i);
    end
    
    alfaArray = [alfaLinear, alfaNonLinear];
    clArray = [clLinear, clNonLinear];
    
    % Drag polar
    cdArray = localCdMin(i) + localK(i) * (clArray - localCli(i)).^2;
    
    % Plot charts
    figure('units','normalized','outerposition',[0 0 1 1])
    subplot(1,2,1)  % Lift curve
    plot(alfaArray,clArray,'k','LineWidth',2)
    grid on, xlabel('Angle of attack, deg'), ylabel('Lift Coefficient')
    title(['Lift curve of section ', num2str(i), ', Re = ', num2str(localReynolds(i))])
    
    if bezierFlag == 1
       hold on
       scatter([localAlfaStar(i),alfa1,localAlfaStall(i)], [localClStar(i),cl1,localClMax(i)], ...
           'Marker','o', 'MarkerFaceColor', 'k', 'MarkerEdgeColor', 'r', 'SizeData', 24)
       plot([localAlfaStar(i),alfa1,localAlfaStall(i)], [localClStar(i),cl1,localClMax(i)], 'k--')
       hold off
    end
    
    subplot(1,2,2)  % Drag polar
    plot(cdArray,clArray,'k','LineWidth',2)
    ax = gca;   ax.XLim(1) = 0;
    grid on, xlabel('Drag coefficient'), ylabel('Lift Coefficient')
    title(['Drag polar of section ', num2str(i), ', Re = ', num2str(localReynolds(i))])
    
    sgtitle(['Airfoil type: ', airfoilType{i}, ...
        '     Relative thickness: ', num2str(thicknessRatio(i)), '%']);
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
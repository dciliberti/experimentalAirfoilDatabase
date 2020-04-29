function [localClMax, localClAlfa, localAlfaStar, localAlfaStall, localClZero,...
    localAlfaZeroLift, localCdMin, localK, localCli, localCmc4] = ...
    airfoilDatabase(numberOfSections,airfoilType,localReynolds,thicknessRatio)
% AIRFOILDATABASE calls the HDF database of airfoil experimental data. 
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

%% database load
Cl_max_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/Cl_max/data')';
tc_on_Cl_max_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/Cl_max/var_1')';
alfa_star_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/alpha_star/data')';
tc_on_alfa_star_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/alpha_star/var_1')';
alfa_stall_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/alpha_stall/data')';
tc_on_alfa_stall_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/alpha_stall/var_1')';
alfa_zero_lift_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/alpha_zl/data')';
tc_on_alfa_zero_lift_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/alpha_zl/var_1')';
Cl_alfa_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/Cl_alpha/data')';
tc_on_Cl_alfa_naca = h5read('Database/AerodinamicParameters_vs_t_vs_FamilyOfWingSection.h5','/Cl_alpha/var_1')';

Cl_max_Re_corr_4digit_sym = h5read('Database/Re_correction_for_cat_4_digit_simm.h5','/Cl_max/data')';
tc_on_Re_corr_4digit_sym = h5read('Database/Re_correction_for_cat_4_digit_simm.h5','/Cl_max/var_1')';
% alfa_star_ReCorr_4digit_sym = [];
% alfa_stall_ReCorr_4digit_sym = [];

Cl_max_Re_corr_4digit_camb = h5read('Database/Re_correction_for_cat_4_digit_no_simm.h5','/Cl_max/data')';
tc_on_Re_corr_4digit_camb = h5read('Database/Re_correction_for_cat_4_digit_no_simm.h5','/Cl_max/var_1')';
% alfa_star_ReCorr_4digit_camb = [];
% alfa_stall_ReCorr_4digit_camb = [];

Cl_max_Re_corr_5digit_camb = h5read('Database/Re_correction_for_cat_5_digit.h5','/Cl_max/data')';
tc_on_Re_corr_5digit_camb = h5read('Database/Re_correction_for_cat_5_digit.h5','/Cl_max/var_1')';
alfa_star_Re_corr_5digit_camb = h5read('Database/Re_correction_for_cat_5_digit.h5','/alpha_star/data')';
alfa_stall_Re_corr_5digit_camb = h5read('Database/Re_correction_for_cat_5_digit.h5','/alpha_stall/data')';

Cl_max_Re_corr_6digit_sym = h5read('Database/Re_correction_for_6th_series_simm.h5','/Cl_max/data')';
tc_on_Re_corr_6digit_sym = h5read('Database/Re_correction_for_6th_series_simm.h5','/Cl_max/var_1')';
% alfa_star_Re_corr_6digit_sym = [];
% alfa_stall_Re_corr_6digit_sym = [];

Cl_max_Re_corr_6digit_camb = h5read('Database/Re_correction_for_6th_series_no_simm.h5','/Cl_max/data')';
tc_on_Re_corr_6digit_camb = h5read('Database/Re_correction_for_6th_series_no_simm.h5','/Cl_max/var_1')';
% alfa_star_Re_corr_6digit_camb = [];
alfa_stall_Re_corr_6digit_camb = h5read('Database/Re_correction_for_6th_series_no_simm.h5','/alpha_stall/data')';

% Cl min drag (ideal) has only thickness effect
Cl_i_naca = h5read('Database/DragParameters_vs_t_vs_FamilyOfWingSection.h5','/Cl_i/data')';
tc_on_Cl_i_naca = h5read('Database/DragParameters_vs_t_vs_FamilyOfWingSection.h5','/Cl_i/var_1')';

% Cd
Cd_min_naca = h5read('Database/DragParameters_vs_t_vs_FamilyOfWingSection.h5','/Cd_min/data')';
tc_on_Cd_min_naca = h5read('Database/DragParameters_vs_t_vs_FamilyOfWingSection.h5','/Cd_min/var_1')';
Cd_min_Re_corr_4digit_sym = h5read('Database/Re_correction_for_cat_4_digit_simm.h5','/Cd_min/data')';
Cd_min_Re_corr_4digit_camb = h5read('Database/Re_correction_for_cat_4_digit_no_simm.h5','/Cd_min/data')';
Cd_min_Re_corr_5digit_camb = h5read('Database/Re_correction_for_cat_5_digit.h5','/Cd_min/data')';
Cd_min_Re_corr_6digit_sym = h5read('Database/Re_correction_for_6th_series_simm.h5','/Cd_min/data')';
Cd_min_Re_corr_6digit_camb = h5read('Database/Re_correction_for_6th_series_no_simm.h5','/Cd_min/data')';

% viscous induced drag factor k
k_naca = h5read('Database/DragParameters_vs_t_vs_FamilyOfWingSection.h5','/k/data')';
tc_on_k_naca = h5read('Database/DragParameters_vs_t_vs_FamilyOfWingSection.h5','/k/var_1')';
k_Re_corr_4digit_sym = h5read('Database/Re_correction_for_cat_4_digit_simm.h5','/k/data')';
k_Re_corr_4digit_camb = h5read('Database/Re_correction_for_cat_4_digit_no_simm.h5','/k/data')';
k_Re_corr_5digit_camb = h5read('Database/Re_correction_for_cat_5_digit.h5','/Cd_min/data')';
k_Re_corr_6digit_sym = h5read('Database/Re_correction_for_6th_series_simm.h5','/k/data')';
k_Re_corr_6digit_camb = h5read('Database/Re_correction_for_6th_series_no_simm.h5','/k/data')';

% Cm c/4 has only thickness effect
Cm_c4_naca = h5read('Database/MomentParameters_vs_t_vs_FamilyOfWingSection.h5','/Cm_c4/data')';
tc_on_Cm_c4_naca = h5read('Database/MomentParameters_vs_t_vs_FamilyOfWingSection.h5','/Cm_c4/var_1')';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Supercritical airfoil lack of data. I have to mix results of different databases
% Cl max is function of the thickness ratio for the DC-8 family
Cl_max_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/Cl_max_DC8/data')';
tc_on_Cl_max_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/Cl_max_DC8/var_0')';

% Cl alfa is function of the thickness ratio and Reynolds number
Cl_alfa_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/Cl_alpha/data')';
tc_on_Cl_alfa_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/Cl_alpha/var_0')';
Cl_alfa_Re_corr_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cl_alpha/data')';
Re_corr_on_Cl_alfa_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cl_alpha/var_0')' * 1e6;

% Cl max is corrected for the Reynolds number for a reference airfoil with t/c = 14%
Cl_max_Re_corr_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cl_max/data')';
Re_corr_on_Cl_max_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cl_max/var_0')' * 1e6;
% Cl_max_sc_ref = 2.158;

% Zero lift angle of attack is function of the thickness ratio for the DC-8 family
alfa_zero_lift_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/alpha_zl/data')';
tc_on_alfa_zero_lift_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/alpha_zl/var_0')';

% Zero lift angle of attack is corrected for the Reynolds number for a reference airfoil with t/c = 14%
alfa_zero_lift_Re_corr_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/alpha_zl/data')';
Re_corr_on_alfa_zero_lift_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/alpha_zl/var_0')' * 1e6;

% End-of-linearity angle of attack is only corrected for Reynolds number
alfa_star_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/alpha_star/data')';
Re_corr_on_alfa_star_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/alpha_star/var_0')' * 1e6;
alfa_star_sc_ref = 9;

% Angle of stall is only corrected for Reynolds number
alfa_stall_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/alpha_stall/data')';
Re_corr_on_alfa_stall_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/alpha_stall/var_0')' * 1e6;
alfa_stall_sc_ref = 19;

% Cd min is function of the thickness ratio
Cd_min_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/Cd_min/data')';
tc_on_Cd_min_sc = h5read('Database/SC_Parameters_vs_t_on_c.h5','/Cd_min/var_0')';

% Cd min is corrected for the Reynolds number for a reference airfoil with t/c = 14%
Cd_min_Re_corr_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cd_min/data')';
Re_corr_on_Cd_min_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cd_min/var_0')' * 1e6;

% k factor is only corrected for Reynolds number
k_Re_corr_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/k/data')';
Re_corr_on_k_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/alpha_zl/var_0')' * 1e6;
k_sc_ref = 0.004844;

% Cm c/4 is only corrected for Reynolds number
Cm_c4_Re_corr_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cm_c4/data')';
Re_corr_on_Cm_c4_sc = h5read('Database/Re_correction_of_SC_Parameters_vs.h5','/Cm_c4/var_0')' * 1e6;
Cm_c4_ref = -0.1236;

% Semi-empirical method for evaluation of wing aerodynamic characteristics
Sratio = zeros(numberOfSections,1);

%% Wing section data
for i = 1:numberOfSections
    switch airfoilType{i}
        case '4s'
            dataCol(i) = 1;
            % Correction due to the Reynolds number
            ClMaxReInterp = interp1(tc_on_Re_corr_4digit_sym,...
                Cl_max_Re_corr_4digit_sym, thicknessRatio(i),'linear','extrap');
            ClMaxReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                ClMaxReInterp, localReynolds(i));
            alfaStarReCorr(i) = 1;
            alfaStallReCorr(i) = 1;
            CdMinReInterp = interp1(tc_on_Re_corr_4digit_sym,...
                Cd_min_Re_corr_4digit_sym, thicknessRatio(i),'linear','extrap');
            CdMinReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                CdMinReInterp, localReynolds(i));
            kReInterp = interp1(tc_on_Re_corr_4digit_sym,...
                k_Re_corr_4digit_sym, thicknessRatio(i),'linear','extrap');
            kReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                kReInterp, localReynolds(i));
            
            % Section leading edge radius
            %localLeRad(i) = leRadCalc(thicknessRatio(i),4);
            
        case '4a'
            dataCol(i) = 2;
            % Correction due to the Reynolds number
            ClMaxReInterp = interp1(tc_on_Re_corr_4digit_camb,...
                Cl_max_Re_corr_4digit_camb, thicknessRatio(i),'linear','extrap');
            ClMaxReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                ClMaxReInterp, localReynolds(i));
            alfaStarReCorr(i) = 1;
            alfaStallReCorr(i) = 1;
            CdMinReInterp = interp1(tc_on_Re_corr_4digit_camb,...
                Cd_min_Re_corr_4digit_camb, thicknessRatio(i),'linear','extrap');
            CdMinReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                CdMinReInterp, localReynolds(i));
            kReInterp = interp1(tc_on_Re_corr_4digit_camb,...
                k_Re_corr_4digit_camb, thicknessRatio(i),'linear','extrap');
            kReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                kReInterp, localReynolds(i));
            
            % Section leading edge radius
            %localLeRad(i) = leRadCalc(thicknessRatio(i),4);
            
        case '5s'
            dataCol(i) = 1; % 5 digits sym data unavailable, read 4 sym
            % Correction due to the Reynolds number
            ClMaxReInterp = interp1(tc_on_Re_corr_4digit_sym,...
                Cl_max_Re_corr_4digit_sym, thicknessRatio(i),'linear','extrap');
            ClMaxReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                ClMaxReInterp, localReynolds(i));
            alfaStarReCorr(i) = 1;
            alfaStallReCorr(i) = 1;
            CdMinReInterp = interp1(tc_on_Re_corr_4digit_sym,...
                Cd_min_Re_corr_4digit_sym, thicknessRatio(i),'linear','extrap');
            CdMinReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                CdMinReInterp, localReynolds(i));
            kReInterp = interp1(tc_on_Re_corr_4digit_sym,...
                k_Re_corr_4digit_sym, thicknessRatio(i),'linear','extrap');
            kReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                kReInterp, localReynolds(i));
            
            % Section leading edge radius
            %localLeRad(i) = leRadCalc(thicknessRatio(i),5);
            
        case '5a'
            dataCol(i) = 3;
            % Correction due to the Reynolds number
            ClMaxReInterp = interp1(tc_on_Re_corr_5digit_camb,...
                Cl_max_Re_corr_5digit_camb, thicknessRatio(i),'linear','extrap');
            ClMaxReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                ClMaxReInterp, localReynolds(i));
            % Correction due to the Reynolds number
            alfaStarReInterp = interp1(tc_on_Re_corr_5digit_camb,...
                alfa_star_Re_corr_5digit_camb, thicknessRatio(i),'linear','extrap');
            alfaStarReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                alfaStarReInterp, localReynolds(i));
            alfaStallReInterp = interp1(tc_on_Re_corr_5digit_camb,...
                alfa_stall_Re_corr_5digit_camb, thicknessRatio(i),'linear','extrap');
            alfaStallReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                alfaStallReInterp, localReynolds(i));
            alfaStallReCorr(i) = 1;
            CdMinReInterp = interp1(tc_on_Re_corr_5digit_camb,...
                Cd_min_Re_corr_5digit_camb, thicknessRatio(i),'linear','extrap');
            CdMinReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                CdMinReInterp, localReynolds(i));
            kReInterp = interp1(tc_on_Re_corr_5digit_camb,...
                k_Re_corr_5digit_camb, thicknessRatio(i),'linear','extrap');
            kReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                kReInterp, localReynolds(i));
            
            % Section leading edge radius
            %localLeRad(i) = leRadCalc(thicknessRatio(i),5);
            
        case '6s'
            dataCol(i) = 4;
            % Correction due to the Reynolds number
            ClMaxReInterp = interp1(tc_on_Re_corr_6digit_sym,...
                Cl_max_Re_corr_6digit_sym, thicknessRatio(i),'linear','extrap');
            ClMaxReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                ClMaxReInterp, localReynolds(i));
            alfaStarReCorr(i) = 1;
            alfaStallReCorr(i) = 1;
            CdMinReInterp = interp1(tc_on_Re_corr_6digit_sym,...
                Cd_min_Re_corr_6digit_sym, thicknessRatio(i),'linear','extrap');
            CdMinReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                CdMinReInterp, localReynolds(i));
            kReInterp = interp1(tc_on_Re_corr_6digit_sym,...
                k_Re_corr_6digit_sym, thicknessRatio(i),'linear','extrap');
            kReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                kReInterp, localReynolds(i));
            
            % Section leading edge radius
            %localLeRad(i) = leRadCalc(thicknessRatio(i),6);
            
        case '6a'
            dataCol(i) = 5;
            % Correction due to the Reynolds number
            ClMaxReInterp = interp1(tc_on_Re_corr_6digit_camb,...
                Cl_max_Re_corr_6digit_camb, thicknessRatio(i),'linear','extrap');
            ClMaxReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                ClMaxReInterp, localReynolds(i));
            alfaStarReCorr(i) = 1;
            alfaStallReInterp = interp1(tc_on_Re_corr_6digit_camb,...
                alfa_stall_Re_corr_6digit_camb, thicknessRatio(i),'linear','extrap');
            alfaStallReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                alfaStallReInterp, localReynolds(i));
            CdMinReInterp = interp1(tc_on_Re_corr_6digit_camb,...
                Cd_min_Re_corr_6digit_camb, thicknessRatio(i),'linear','extrap');
            CdMinReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                CdMinReInterp, localReynolds(i));
            kReInterp = interp1(tc_on_Re_corr_6digit_camb,...
                k_Re_corr_6digit_camb, thicknessRatio(i),'linear','extrap');
            kReCorr(i) = LinearInterpWithClipExtrap([3e6,6e6,9e6],...
                kReInterp, localReynolds(i));
            
            % Section leading edge radius
            %localLeRad(i) = leRadCalc(thicknessRatio(i),6);
            
        case 'sc'
            ClMaxReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_Cl_max_sc,...
                Cl_max_Re_corr_sc, localReynolds(i));
            ClAlfaReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_Cl_alfa_sc,...
                Cl_alfa_Re_corr_sc, localReynolds(i));
            alfaZeroLiftReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_alfa_zero_lift_sc,...
                alfa_zero_lift_Re_corr_sc, localReynolds(i));
            AlfaStarReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_alfa_star_sc,...
                alfa_star_sc, localReynolds(i));
            AlfaStallReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_alfa_stall_sc,...
                alfa_stall_sc, localReynolds(i));
%             CdMinReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_Cd_min_sc,...
%                 Cd_min_Re_corr_sc, localReynolds(i));
    % New correction for Reynolds from smooth airfoil data of NASA TM 81912
            CdMinReCorr(i) = 0.13263*log(localReynolds(i)/1e6) + 0.68917;
            kReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_k_sc,...
                k_Re_corr_sc, localReynolds(i));
            CmReCorr(i) = LinearInterpWithClipExtrap(Re_corr_on_Cm_c4_sc,...
                Cm_c4_Re_corr_sc, localReynolds(i));
            
            % Section leading edge radius
            %localLeRad(i) = leRadCalc(thicknessRatio(i),7);
    end

    % a supercritical airfoil requires a different database
    if strcmp('sc',airfoilType{i})
        % Section Cl max with Reynolds correction
        localClMax(i) = LinearInterpWithClipExtrap(tc_on_Cl_max_sc,...
            Cl_max_sc, thicknessRatio(i));
        localClMax(i) = localClMax(i) * ClMaxReCorr(i);
        
        % Section lift curve slope with thickness and Reynolds number
        localClAlfa(i) = LinearInterpWithClipExtrap(tc_on_Cl_alfa_sc,...
            Cl_alfa_sc, thicknessRatio(i));
        localClAlfa(i) = localClAlfa(i) * ClAlfaReCorr(i);
        
        % Section zero lift angle of attack with Reynolds correction
        localAlfaZeroLift(i) = LinearInterpWithClipExtrap(tc_on_alfa_zero_lift_sc,...
            alfa_zero_lift_sc, thicknessRatio(i));
        localAlfaZeroLift(i) = localAlfaZeroLift(i) * alfaZeroLiftReCorr(i);
        
        % Lift coefficient at zero angle of attack
        localClZero(i) = localClAlfa(i) * -localAlfaZeroLift(i);
        
        % Section end-of-linearity angle of attack has only Reynolds correction
        localAlfaStar(i) = AlfaStarReCorr(i) * alfa_star_sc_ref;
        
        % Section angle of stall has only Reynolds correction
        localAlfaStall(i) = AlfaStallReCorr(i) * alfa_stall_sc_ref;
        
        % Section minimum drag coefficient with Reynolds correction
%         localCdMin(i) = LinearInterpWithClipExtrap(tc_on_Cd_min_sc,...
%             Cd_min_sc, thicknessRatio(i));
% New correction for Reynolds from smooth airfoil data of NASA TM 81912
        localCdMin(i) = 0.00704*log(thicknessRatio(i)) - 0.00881;
        localCdMin(i) = localCdMin(i) * CdMinReCorr(i);
        if localCdMin(i) < 0.0035
            localCdMin(i) = 0.0035;
        end
        if localCdMin(i) > 0.0100
            localCdMin(i) = 0.0100;
        end
        
        % Section k factor has only Reynolds correction
        localK(i) = kReCorr(i) * k_sc_ref;
        
        % Section ideal lift coefficient (min drag) not provided
        localCli(i) = 0.40;  % nasasc2-0714 , whitcomb
        
        % Korn factor for wave drag calculation
        % localKorn(i) = 0.95;
        
        % Section pitching moment has only Reynolds correction
        localCmc4(i) = CmReCorr(i) * Cm_c4_ref;
    else
        % Section Cl max with Reynolds correction
        localClMax(i) = LinearInterpWithClipExtrap(tc_on_Cl_max_naca(:,dataCol(i)),...
            Cl_max_naca(:,dataCol(i)), thicknessRatio(i));
        localClMax(i) = localClMax(i) * ClMaxReCorr(i);
        
        % Section Cl alfa with thickness ratio
        localClAlfa(i) = LinearInterpWithClipExtrap(tc_on_Cl_alfa_naca(:,dataCol(i)),...
            Cl_alfa_naca(:,dataCol(i)), thicknessRatio(i));
        
        % Section end-of-linearity angle of attack with Reynolds correction
        localAlfaStar(i) = LinearInterpWithClipExtrap(tc_on_alfa_star_naca(:,dataCol(i)),...
            alfa_star_naca(:,dataCol(i)), thicknessRatio(i));
        localAlfaStar(i) = localAlfaStar(i) * alfaStarReCorr(i);
        
        % Section angle of stall with Reynolds correction
        localAlfaStall(i) = LinearInterpWithClipExtrap(tc_on_alfa_stall_naca(:,dataCol(i)),...
            alfa_stall_naca(:,dataCol(i)), thicknessRatio(i));
        localAlfaStall(i) = localAlfaStall(i) * alfaStallReCorr(i);
        
        % Section zero lift angle of attack (no correction available)
        localAlfaZeroLift(i) = LinearInterpWithClipExtrap(tc_on_alfa_zero_lift_naca(:,dataCol(i)),...
            alfa_zero_lift_naca(:,dataCol(i)), thicknessRatio(i));
        
        % Lift coefficient at zero angle of attack
        localClZero(i) = localClAlfa(i) * -localAlfaZeroLift(i);
        
        % Section minimum drag coefficient with Reynolds correction
        localCdMin(i) = LinearInterpWithClipExtrap(tc_on_Cd_min_naca(:,dataCol(i)),...
            Cd_min_naca(:,dataCol(i)), thicknessRatio(i));
        localCdMin(i) = localCdMin(i) * CdMinReCorr(i);
        
        % Section k factor with Reynolds correction
        localK(i) = LinearInterpWithClipExtrap(tc_on_k_naca(:,dataCol(i)),...
            k_naca(:,dataCol(i)), thicknessRatio(i));
        localK(i) = localK(i) * kReCorr(i);
        
        % Section ideal lift coefficient (min drag) has only thickness effect
        localCli(i) = LinearInterpWithClipExtrap(tc_on_Cl_i_naca(:,dataCol(i)),...
            Cl_i_naca(:,dataCol(i)), thicknessRatio(i));
        
        % Korn factor for wave drag calculation
%         localKorn(i) = 0.87;
        
        % Section pitching moment coefficient (min drag) has only thickness effect
        localCmc4(i) = LinearInterpWithClipExtrap(tc_on_Cm_c4_naca(:,dataCol(i)),...
            Cm_c4_naca(:,dataCol(i)), thicknessRatio(i));
    end
    
end
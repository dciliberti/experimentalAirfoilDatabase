[![View Airfoil experimental database on File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://it.mathworks.com/matlabcentral/fileexchange/75051-airfoil-experimental-database)

This code is listed on MATLAB File Exchange here: [Airfoil experimental database](https://it.mathworks.com/matlabcentral/fileexchange/75051-airfoil-experimental-database)

# Airfoil experimental database

Get airfoil characteristics from an experimental database.

This app includes NACA 4, 5, and 6 series, and NASA supercritical airfoil database. Most of the data comes from the book Theory of Wing Sections, by Abbott and Von Doenhoff. It reports airfoil characteristics, lift curve and drag polar with a few inputs. The user has only to select airfoil family and assign relative thickness and Reynolds number. The characteristics of the curves are reported in a table, which can be exported on a spreadsheet file. Very useful in preliminary aircraft design, when the user needs a reliable source of data but has only few global parameters to play with.

## Usage
Open `main.m` to use the program from the main script. This will allow to plot data for many airfoils. This is not interactive and requires a minimum of MATLAB knowledge, although most of the user only should change input data.

Alternatively, you can use the MATLAB app to execute the program interactively with a GUI or the standalone executable (only for Windows), which does not need MATLAB installed, but may require to download about 800 Mb of data for the MATLAB runtime compiler. Check the binaries on the [releases page](https://github.com/dciliberti/experimentalAirfoilDatabase/releases).

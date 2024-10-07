function gridSettings = loadGridSettings(subjectID, planID)
%LOADGRIDSETTINGS Load grid settings from k-Plan results file.
%
% DESCRIPTION:
%     loadGridSettings loads the grid settings (e.g., domain position) from
%     a k-Plan results file. This function must be executed on the PC where
%     k-Plan is installed.
%
%     See kplan.loadResults for a description of how to determine the
%     subjectID and planID from k-Plan.
%
% USAGE:
%     gridSettings = kplan.loadGridSettings(subjectID, planID)
%
% INPUTS:
%     subjectID         - Subject ID from k-Plan.
%     planID            - Plan ID from k-Plan.
%
% OUTPUTS:
%     gridSettings      - Structure containing the following fields:
%
%     .domainPosition   - Position of the LPI corner of the simulation
%                         domain in k-Plan world coordinates [m]. If using
%                         these values to align with the primary planning
%                         image outside of k-Plan, note that k-Plan
%                         directly applies the transformation matrix
%                         (including rotations and shear) stored in the
%                         header of the primary planning image before
%                         display. The LPI corner of the transformed image
%                         data is then aligned to (0, 0, 0) in k-Plan world
%                         coordinates.
%     .pointsPerWavelength
%                       - Number of spatial grid points per wavelength used
%                         for the simulation assuming a reference sound
%                         speed of 1540 m/s.
%     .numberSonications
%                       - Number of sonication results stored in the file.

% Copyright (C) 2023- University College London (Bradley Treeby).

arguments
    subjectID (1,1) {mustBePositive, mustBeInteger}
    planID (1,1) {mustBePositive, mustBeInteger}
end

% Get file path.
filePath = getResultsFilePath(subjectID, planID);

% Load datasets.
try
    gridSettings.domainPosition = h5read(filePath, '/settings/grid/domain_position');
    gridSettings.pointsPerWavelength = h5read(filePath, '/settings/grid/points_per_wavelength');
    gridSettings.numberSonications = h5readatt(filePath, '/sonications', 'number_sonications');
catch
    error('Specified dataset not found in results file.');
end

function [data, gridSpacing] = loadResults(subjectID, planID, sonicationNumber, datasetName)
%LOADRESULTS Load dataset from k-Plan results file.
%
% DESCRIPTION:
%     loadResults loads a simulated dataset (pressure, temperature, etc)
%     from a k-Plan results file. This function must be executed on the PC
%     where k-Plan is installed.
% 
%     The subject and plan IDs are shown in the "Add Images" tab of the
%     plan developer dialog under "k-Dispatch ID". The first number is the
%     subjectID, and the second number is the planID.
%
%     The sonication number is the number shown on the left hand side of
%     the sonication table in the "Planning" tab of the plan developer
%     dialog.
%
%     The datasetName is specified using the SimulatedDatasets enum class,
%     e.g., kplan.SimulatedDatasets.PressureAmplitude.
%
% USAGE:
%     [data, gridSpacing] = kplan.loadResults(subjectID, planID, sonicationNumber, datasetName)
%
% EXAMPLES:
%     [data, gridSpacing] = kplan.loadResults(1, 1, 1, kplan.SimulatedDatasets.PressureAmplitude);
%
% INPUTS:
%     subjectID         - Subject ID from k-Plan.
%     planID            - Plan ID from k-Plan.
%     sonicationNumber  - Sonication number from k-Plan.
%     datasetName       - Dataset name, specified as a member of the
%                         kplan.SimulatedDatasets enum class.
%
% OUTPUTS:
%     data              - Loaded data.
%     gridSpacing       - Grid spacing [m].

% Copyright (C) 2023- University College London (Bradley Treeby).

arguments
    subjectID (1,1) {mustBePositive, mustBeInteger}
    planID (1,1) {mustBePositive, mustBeInteger}
    sonicationNumber (1,1) {mustBePositive, mustBeInteger}
    datasetName (1,1) kplan.SimulatedDatasets
end

% Get file path.
filePath = getResultsFilePath(subjectID, planID);

% Get path to dataset within file.
datasetPath = datasetName.getDatasetH5Path(sonicationNumber);

% Check the dataset exists.
try
    h5info(filePath, datasetPath);
catch
    error('Specified dataset not found in results file.');
end

% Load dataset.
data = h5read(filePath, datasetPath);

% Apply scaling if the attributes are present.
try
    scaleSlope = h5readatt(filePath, datasetPath, 'scale_slope');
    scaleIntercept = h5readatt(filePath, datasetPath, 'scale_intercept');
    data = single(data) * scaleSlope + scaleIntercept;
catch
    disp('No scaling applied.')
end

% Read dimensions.
if nargout == 2
    try
        gridSpacing = h5readatt(filePath, datasetPath, 'grid_spacing');
    catch
        error('Specified dataset does not contain the grid spacing attribute.');
    end
end

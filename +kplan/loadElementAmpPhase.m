function [amp, phase] = loadElementAmpPhase(subjectID, planID, sonicationNumber)
%LOADRESULTS Load dataset from k-Plan results file.
%
% DESCRIPTION:
%     loadElementAmpPhase loads the driving amplitude and phase for the
%     transducer used for the forward planning simulation in k-Plan.
%
%     If the transducer is an annular array or multi-element array, the
%     amplitude and phase for each physical element are returned. The
%     values are ordered in the same order as the k-Plan transducer file.
%     For annular arrays, this starts with the inner-most element.
%
%     See kplan.loadResults for a description of how to determine the
%     subjectID, planID, and sonicationNumber from k-Plan.
%
% USAGE:
%     [amp, phase] = kplan.loadElementAmpPhase(subjectID, planID, sonicationNumber)
%
% EXAMPLES:
%     [amp, phase] = kplan.loadElementAmpPhase(1, 1, 1);
%
% INPUTS:
%     subjectID         - Subject ID from k-Plan.
%     planID            - Plan ID from k-Plan.
%     sonicationNumber  - Sonication number from k-Plan.
%
% OUTPUTS:
%     amp               - Vector of amplitudes for each element [Pa].
%     phase             - vector of phases for each element [rad].

% Copyright (C) 2023- University College London (Bradley Treeby).

arguments
    subjectID (1,1) {mustBePositive, mustBeInteger}
    planID (1,1) {mustBePositive, mustBeInteger}
    sonicationNumber (1,1) {mustBePositive, mustBeInteger}
end

% Get file path.
filePath = getResultsFilePath(subjectID, planID);

% Get path to dataset within file.
ampPath = ['/sonications/' num2str(sonicationNumber) '/element_parameters/element_amplitude'];
phasePath = ['/sonications/' num2str(sonicationNumber) '/element_parameters/element_phase'];

% Check the dataset exists.
try
    h5info(filePath, ampPath);
    h5info(filePath, phasePath);
catch
    error('Specified dataset not found in results file.');
end

% Load datasets.
amp = h5read(filePath, ampPath);
phase = h5read(filePath, phasePath);

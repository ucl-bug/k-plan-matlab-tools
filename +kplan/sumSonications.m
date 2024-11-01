function sumSonications(subjectID, planID, outputFilename)
%SUMSONICATIONS Sum all pressure fields in a k-Plan results file.
%
% DESCRIPTION:
%     sumSonications sums the simulated pressure fields from all
%     sonications in a k-Plan results file, and saves this to a new .h5
%     planning image which can be loaded into k-Plan.
%
% USAGE:
%     sumSonications(subjectID, planID, outputFilename)
%
% INPUTS:
%     subjectID         - Subject ID from k-Plan.
%     planID            - Plan ID from k-Plan.
%     outputFilename    - .h5 filename to save combined field to.

% Copyright (C) 2023- University College London (Bradley Treeby).

% Load the settings
gridSettings = kplan.loadGridSettings(subjectID, planID);

% Load and sum results
combinedSonications = 0 ;
for sonicationIndex = 1:gridSettings.numberSonications
    [amplitude, gridSpacing] = kplan.loadResults(subjectID, planID, sonicationIndex, kplan.SimulatedDatasets.PressureAmplitude);
    try
        phase = kplan.loadResults(subjectID, planID, sonicationIndex, kplan.SimulatedDatasets.PressurePhase);
    catch ME
        warning('Phase data must be saved to sum sonications. This can be selected in the settings tab of k-Plan.')
        rethrow(ME)
    end
    combinedSonications = combinedSonications + amplitude .* exp(1i .* phase);
end
combinedSonications = abs(combinedSonications);

% Write to a new image file
kplan.savePlanningImageH5(outputFilename, combinedSonications, gridSpacing, 'Summed Image', gridSettings.domainPosition);

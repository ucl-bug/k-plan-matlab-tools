function segmentation = loadSegmentation(subjectID, planID)
%LOADSEGMENTATION Load segmentation from k-Plan results file.
%
% DESCRIPTION:
%     loadSegmentation loads the medium segmentation from a k-Plan results
%     file. This function must be executed on the PC where k-Plan is
%     installed.
%
%     See kplan.loadResults for a description of how to determine the
%     subjectID and planID from k-Plan.
%
% USAGE:
%     segmentation = loadSegmentation(subjectID, planID)
%
% INPUTS:
%     subjectID         - Subject ID from k-Plan.
%     planID            - Plan ID from k-Plan.
%
% OUTPUTS:
%     segmentation      - Structure containing the following fields:
%
%     .mask   - Labelled mask matrix, with each mask region within the
%               matrix labelled using an integer id. The masks are
%               generated as part of the conversion of the primary planning
%               image to material properties, and thus cover the same
%               domain as the simulated field parameters.
%     .ids    - Array of integer ids for the mask types within the mask.
%     .labels - Array of string labels for each integer given in ids.

% Copyright (C) 2025- University College London (Bradley Treeby).

arguments
    subjectID (1,1) {mustBePositive, mustBeInteger}
    planID (1,1) {mustBePositive, mustBeInteger}
end

% Get file path.
filePath = getResultsFilePath(subjectID, planID);

% Load datasets.
try
    segmentation.mask = h5read(filePath, '/medium_properties/medium_mask');
    segmentation.ids = h5read(filePath, '/medium_properties/medium_mask_ids');
    segmentation.labels = h5read(filePath, '/medium_properties/medium_mask_labels');
catch
    error('Specified dataset not found in results file.');
end

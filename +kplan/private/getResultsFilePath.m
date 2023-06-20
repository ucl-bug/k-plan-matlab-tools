function path = getResultsFilePath(subjectID, planID)
%GETRESULTSPATH Get path to k-Plan results file.
%
% DESCRIPTION:
%     getResultsFilePath gets the file path for the results file for the
%     specified subject and plan IDs. If the file doesn't exist, an error
%     is thrown.
%
% USAGE:
%     path = getResultsFilePath(subjectID, planID)
%
% INPUTS:
%     subjectID         - Subject ID from k-Plan.
%     planID            - Plan ID from k-Plan.
%
% OUTPUTS:
%     path              - Path to results file.

% Copyright (C) 2023- University College London (Bradley Treeby).

% Only Windows is supported.
if ~ispc
    error('k-Plan MATLAB tools is only supported on Windows.');
end

% Get path to AppData local.
path = winqueryreg('HKEY_CURRENT_USER', ...
            ['Software\Microsoft\Windows\CurrentVersion\' ...
            'Explorer\Shell Folders'], 'Local AppData');

% Check for k-Plan path.
path = [path filesep 'k-Plan'];
if ~exist(path, "dir")
    error('k-Plan application data not found. k-Plan MATLAB tools must be used on the same PC as k-Plan.');
end

% Get path to dataset and check for existance.
path = [path filesep 'UserData' filesep 'Subjects' filesep ...
    num2str(subjectID) filesep 'Plans' filesep num2str(planID) filesep ...
    'PlanResults' filesep 'PLAN-' num2str(subjectID) '-' num2str(planID) '-RESULTS.h5'];
if ~exist(path, "file")
    error('Specified results file not found. Check the subject and plan IDs.');
end

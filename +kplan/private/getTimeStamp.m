function time_stamp = getTimeStamp()
%GETTIMESTAMP Return current date and time stamp in ISO 8601 format
%YYYY-MM-DDThh:mmZ.
%
% USAGE:
%     time_stamp = getTimeStamp()
%                   
% OUTPUTS:
%     time_stamp    - String containing the current time stamp.

% Copyright (C) 2024- University College London (Bradley Treeby).

% get time stamp in required format
time_stamp = char(datetime('now', 'TimeZone', 'local', 'Format', 'yyyy-MM-dd''T''HH:mm:ssz'));

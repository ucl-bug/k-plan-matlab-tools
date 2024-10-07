function savePlanningImageH5(filename, imageData, imageSpacing, imageLabel, imagePosition)
%SAVEPLANNINGIMAGEH5 Save image data to H5 file.
%
% DESCRIPTION:
%     savePlanningImageH5 saves an image dataset to a .h5 file that can be
%     loaded in k-Plan.
%
% USAGE:
%     savePlanningImageH5(filename, imageData, imageSpacing, imageLabel, imagePosition)
%
% INPUTS:
%     filename         - Filename to save image to.
%     imageData        - Image data to save
%     imageSpacing     - Image voxel spacing [m].
%     imageLabel       - Image name or label.
%
% OPTIONAL INPUTS
%     imagePosition    - Position of image relative to primary planning
%                        image [m]. Defaults to [0, 0, 0] so that image is
%                        aligned with the primary planning image.

% Copyright (C) 2024- University College London (Bradley Treeby).

arguments
    filename char
    imageData {mustBeNumeric, mustBeFinite, mustBeReal}
    imageSpacing (1,3) {mustBePositive, mustBeFinite}
    imageLabel char
    imagePosition (1,3) = [0, 0, 0]
end

% check for file
if exist(filename, "file")
    error('File already exists.');
end

% write dataset
dataset_sz = size(imageData);
dataset_name = '/1/image_data';
h5create(filename, dataset_name, dataset_sz, 'Datatype', class(imageData));
h5write(filename, dataset_name, imageData);

% write dataset attributes
h5writeatt(filename, dataset_name, 'scale_slope', single(1));
h5writeatt(filename, dataset_name, 'scale_intercept', single(0));
h5writeatt(filename, dataset_name, 'grid_dims', uint64(dataset_sz));
h5writeatt(filename, dataset_name, 'grid_spacing', single(imageSpacing(:).'));
h5writeatt(filename, dataset_name, 'image_label', imageLabel);

% write domain offset
h5create(filename, '/settings/grid/domain_position', [1, 3, 1], 'Datatype', 'single')
h5write(filename, '/settings/grid/domain_position', single(imagePosition(:).'))

% set file attributes
h5writeatt(filename, '/', 'application_name', 'k-Plan', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'file_type', 'k-Plan Planning Image', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'file_description', 'k-Plan Planning Image', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'major_version', uint64(1));
h5writeatt(filename, '/', 'minor_version', uint64(2));
h5writeatt(filename, '/', 'created_by', 'k-Plan MATLAB tools', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'creation_date', getTimeStamp, 'TextEncoding', 'system');
h5writeatt(filename, '/', 'number_planning_images', uint64(1));

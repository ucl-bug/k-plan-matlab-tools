function saveMaterialLabelledMatrix(filename, imageLabelledMatrix, imageLookupTable, imageSpacing, imageLabel, imagePosition)
%SAVEMATERIALLABELLEDMATRIX Save image data to .kim file as a labelled matrix.
%
% DESCRIPTION:
%     saveMaterialLabelledMatrix saves an image dataset as a .kim file
%     that can be loaded in k-Plan, where the material properties and
%     geometry are explicitly defined using a labelled matrix.
%
%     The labelled matrix format is defined by (1) a 3D matrix containing a
%     set of labels (e.g., 0, 1, 2, ...), and (2) a set of look-up tables
%     that specifies the material properties for each of these labels.
%
%     The individual lookup tables must be specified as 2 x N arrays,
%     where the first row specifies the label (e.g., 0, 1, 2) and the
%     second row specifies the values for that label (e.g., 1500, 1600,
%     2000).
%
% USAGE:
%     saveMaterialLabelledMatrix(filename, imageLabelledMatrix, imageLookupTable, imageSpacing, imageLabel, imagePosition)
%
% INPUTS:
%     filename            - Filename to save image to.
%     imageLabelledMatrix - 3D matrix containing N integer material labels.
%     imageLookupTable    - Structure containing a 2 x N lookup table for
%                           each acoustic and thermal parameter:
%       
%                           .sound_speed_compression    [m/s]
%                           .density                    [kg/m^3]
%                           .alpha_coeff_compression    [dB/(MHz.cm)^y]
%                           .alpha_power_compression    [y]
%                           .specific_heat              [J/(kg.K)]
%                           .thermal_conductivity       [W/(m.K)]
%
%     imageSpacing        - Image voxel spacing of imageLabelledMatrix [m].
%     imageLabel          - Image name or label.
%
% OPTIONAL INPUTS
%     imagePosition       - Position of image relative to primary planning
%                           image [m]. Defaults to [0, 0, 0] so that image
%                           is aligned with the primary planning image.

% Copyright (C) 2024- University College London (Bradley Treeby).

arguments
    filename char
    imageLabelledMatrix (:,:,:) {mustBeInteger, mustBeNonnegative}
    imageLookupTable struct
    imageSpacing (3,1) {mustBePositive, mustBeFinite}
    imageLabel char
    imagePosition (3,1) = [0, 0, 0]   
end

labels = unique(imageLabelledMatrix).';
numLabels = length(labels);
fields = {...
    'sound_speed_compression', ...
    'density', ...
    'alpha_coeff_compression', ...
    'alpha_power_compression', ...    
    'specific_heat', ...
    'thermal_conductivity'};

% force .kim extension
[pathPart, name, ~] = fileparts(filename);
filename = fullfile(pathPart, sprintf('%s.kim', name));

% check for file
if exist(filename, "file")
    error('File already exists.');
end

% set data types
if numLabels <= intmax('uint8')
    dataType = @uint8;
elseif numLabels <= intmax('uint16')
    dataType = @uint16;
elseif numLabels <= intmax('uint32')
    dataType = @uint32;
else
    dataType = @uint64;
end

% write labelled matrix dataset
dataset_sz = size(imageLabelledMatrix);
dataset_name = '/1/image_data';
h5create(filename, dataset_name, dataset_sz, 'Datatype', class(dataType(1)));
h5write(filename, dataset_name, dataType(imageLabelledMatrix));

% write dataset attributes
h5writeatt(filename, dataset_name, 'scale_slope', single(1));
h5writeatt(filename, dataset_name, 'scale_intercept', single(0));
h5writeatt(filename, dataset_name, 'grid_dims', uint64(dataset_sz));
h5writeatt(filename, dataset_name, 'grid_spacing', single(imageSpacing(:)));

% write domain offset
h5create(filename, '/settings/grid/domain_position', [3, 1, 1], 'Datatype', 'single')
h5write(filename, '/settings/grid/domain_position', single(imagePosition(:)))

% write image type
h5create(filename, '/1/image_type', [1, 1, 1], 'Datatype', 'uint64')
h5write(filename, '/1/image_type', uint64(1)); % 1 specifies labelled matrix

% write lookup tables
for field_ind = 1:length(fields)
    field_name = fields{field_ind};

    if ~isfield(imageLookupTable, field_name)
        error(['imageLookupTable.' field_name ' must be defined.']);
    end 
    validateattributes(imageLookupTable.(field_name), {'numeric'}, {'nonnegative', 'nonempty', 'real'});

    if ~isequal(imageLookupTable.(field_name)(1, :), labels)
        error(['imageLookupTable.' field_name ' must be a 2 x N matrix, where the first row matches the labels defined in imageLabelledMatrix']);
    end

    h5create(filename, ['/1/' field_name], [2, numLabels, 1], 'Datatype', 'single');
    h5write(filename, ['/1/' field_name], single(imageLookupTable.(field_name)));
end

% write reference values
h5create(filename, '/1/sound_speed_compression_ref', [1, 1, 1], 'Datatype', 'single');
h5write(filename, '/1/sound_speed_compression_ref', single(imageLookupTable.sound_speed_compression_ref));

% set file attributes
h5writeatt(filename, '/1', 'image_label', imageLabel, 'TextEncoding', 'system');
h5writeatt(filename, '/', 'application_name', 'k-Plan', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'file_type', 'k-Plan Planning Image', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'file_description', 'k-Plan Labelled Matrix Planning Image', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'major_version', uint64(1));
h5writeatt(filename, '/', 'minor_version', uint64(2));
h5writeatt(filename, '/', 'created_by', 'k-Plan MATLAB tools', 'TextEncoding', 'system');
h5writeatt(filename, '/', 'creation_date', getTimeStamp, 'TextEncoding', 'system');
h5writeatt(filename, '/', 'number_planning_images', uint64(1));

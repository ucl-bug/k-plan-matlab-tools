# k-Plan MATLAB tools

## Overview

MATLAB toolbox for working with the input and output files used by the k-Plan treatment planning software. This toolbox assumes familiarity with the k-Plan software and terminology.

:warning: *This repository is still under development. Breaking changes may occur!*

## Setup

Download and add the root folder of this toolbox to the MATLAB path. The tools must be used on the same computer on which k-Plan is installed.

## Subject and Plan IDs

Datasets from the k-Plan results file can be loaded into MATLAB using the subject and plan IDs, and the sonication number from k-Plan. The subject and plan IDs are shown in the "Add Images" tab next to "k-Dispatch ID". The first number is the `subjectID`, and the second number is the `planID`. The sonication number is the number shown on the left hand side of the sonication table in the "Planning" tab.

## Load a simulated dataset

The simulated pressure and temperature fields can be loaded using:

```matlab
[data, gridSpacing] = kplan.loadResults(subjectID, planID, sonicationNum, datasetName);
```

For example, to load the pressure from subject 1, plan 2, sonication 3, call:

```matlab
[data, gridSpacing] = kplan.loadResults(1, 2, 3, kplan.SimulatedDatasets.PressureAmplitude);
```

To load the position of the simulation domain in k-Plan world coordinates, call:

```matlab
gridSettings = kplan.loadGridSettings(subjectID, planID)
```

For further details type:

```matlab
help kplan.loadResults
```

## Load element amplitudes and phases

The driving amplitude and phase for the transducer used for the forward planning simulation can be loaded using:

```matlab
[amp, phase] = kplan.loadElementAmpPhase(subjectID, planID, sonicationNumber)
```

## Sum sonications

The simulated pressure field from all sonications in a treatment plan can be summed (if simulating a cross-beam approach, for example), and then saved as a new .h5 image dataset which can be loaded into k-Plan using:

```matlab
outputFilename = 'combined_sonications.h5'
kplan.sumSonications(subjectID, planID, outputFilename)
```

## Labelled matrix material properties

By default, k-Plan maps the materials properties used in the simulation from a CT or pseudo-CT image of the head. k-Plan also allows the material properties used in the simulation to be specified directly using a labelled matrix. This format uses a single 3D matrix where each grid point is given an integer label, and then a set of look-up tables which specify the material properties for each label.

This file can be generated using `kplan.saveMaterialLabelledMatrix` and then loaded into k-Plan. The loaded image must be selected as the primary planning image. Nearest neighbour interpolation is used to re-sample the image to the simulation resolution, so the labelled matrix should have sufficient resolution to avoid stair-casing artefacts (typically > 6 PPW).

The example below shows how to create a labelled matrix with a skull slab assigned the properties of cortical bone, matching the [modelling intercomparison benchmark 3](https://doi.org/10.1121/10.0013426).

```matlab
% define image structure at 6 PPW
dx = 0.5e-3;
imageSize = [241, 300, 300];

skull_thickness = round(6.5e-3/dx);
skull_position = 1 + round(30e-3/dx);

imageLabelledMatrix = zeros(imageSize);
imageLabelledMatrix(skull_position:skull_position + skull_thickness - 1, :, :) = 1;

% define material properties of water and cortical bone
imageLookupTable.sound_speed_compression = ...
    [0       1;
     1500    2800];
imageLookupTable.density = ...
    [0       1;
     1000    1850];
imageLookupTable.alpha_coeff_compression = ...
    [0       1;
     0       8];
imageLookupTable.alpha_power_compression = ...
    [0       1;
     1       1];
imageLookupTable.specific_heat = ...
    [0       1;
     4200    1300];
imageLookupTable.thermal_conductivity = ...
    [0       1;
     0.6     0.32];

imageLookupTable.sound_speed_compression_ref = 1500;

% define image attributes
imageSpacing = [dx, dx, dx];
imageLabel = 'Modelling Intercomparison - Benchmark 3';

% save as image
kplan.saveMaterialLabelledMatrix(imageLabel, imageLabelledMatrix, imageLookupTable, imageSpacing, imageLabel)
```

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

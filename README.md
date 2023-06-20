# k-Plan MATLAB tools

## Overview

MATLAB toolbox for working with the input and output files used by the k-Plan treatment planning software. This toolbox assumes familiarity with the k-Plan software and terminology.

:warning: *This repository is still under development. Breaking changes may occur!*

## Setup

Download and add the root folder of this toolbox to the MATLAB path. The tools must be used on the same computer on which k-Plan is installed.

## Loading a simulated dataset

The simulated pressure and temperature fields can be loaded into MATLAB using the subject and plan IDs, and the sonication number from k-Plan. The subject and plan IDs are shown in the "Add Images" tab next to "k-Dispatch ID". The first number is the `subjectID`, and the second number is the `planID`. The sonication number is the number shown on the left hand side of the sonication table in the "Planning" tab.

The syntax is:

```matlab
[data, gridSpacing] = kplan.loadResults(subjectID, planID, sonicationNum, datasetName);
```

For example, to load the pressure from subject 1, plan 2, sonication 3, call:

```matlab
[data, gridSpacing] = kplan.loadResults(1, 2, 3, kplan.SimulatedDatasets.PressureAmplitude);
```

For further details type:

```matlab
help kplan.loadResults
```




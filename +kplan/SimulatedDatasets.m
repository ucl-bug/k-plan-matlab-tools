%SimulatedDatasets Class definition for dataset names in k-Plan results file.
%
% DESCRIPTION:
%     SimulatedDatasets specifies the dataset names that can be loaded from
%     the k-Plan results file. This name is passed to other functions,
%     e.g., kplan.loadDataset.
%
% USAGE:
%     datasetName = kplan.SimulatedDatasets.PressureAmplitude;
%     datasetName = kplan.SimulatedDatasets.PressurePhase;
%     datasetName = kplan.SimulatedDatasets.Temperature;
%     datasetName = kplan.SimulatedDatasets.ThermalDose;
%     datasetName = kplan.SimulatedDatasets.ThermalDoseSptp;

% Copyright (C) 2023- University College London (Bradley Treeby).

classdef SimulatedDatasets
    enumeration
        PressureAmplitude, PressurePhase, Temperature, ThermalDose, ThermalDoseSptp
    end
    methods
        function datasetName = getDatasetH5Path(obj, sonicationNum)
            import kplan.*
            datasetName = ['/sonications/' num2str(sonicationNum) '/simulated_field/'];
            switch obj
                case SimulatedDatasets.PressureAmplitude
                    datasetName = [datasetName 'pressure_amplitude'];
                case SimulatedDatasets.PressurePhase
                    datasetName = [datasetName 'pressure_phase'];
                case SimulatedDatasets.Temperature
                    datasetName = [datasetName 'temperature_maximum'];
                case SimulatedDatasets.ThermalDose
                    datasetName = [datasetName 'thermal_dose'];
                case SimulatedDatasets.ThermalDoseSptp
                    datasetName = [datasetName 'thermal_dose_sptp'];
            end
        end
    end
end

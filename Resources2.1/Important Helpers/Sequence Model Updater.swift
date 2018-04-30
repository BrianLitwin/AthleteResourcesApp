//
//  Keyboard Tf Manager.swift
//  Resources2.1
//
//  Created by B_Litwin on 2/5/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

import Resources_View2_1


class SequenceModelUpdater: ModelUpdater {
    
    typealias TextField = EditExerciseMetricTextField
    
    var textfields: [TextField] = []
    var textfieldLabels: [String] = []
    var nonstandardKeyboardButtons: [KeyboardButtonType : KeyboardButton] = [:]
    
    init(exerciseMetric: Exercise_Metrics) {
        loadTextFieldContainers(exerciseMetric: exerciseMetric)
    }
    
    init(exerciseMetrics: [Exercise_Metrics]) {
        loadTextFieldContainers(exerciseMetrics: exerciseMetrics)
    }
    
    func loadTextFieldContainers(exerciseMetrics: [Exercise_Metrics]) {
        
        guard !exerciseMetrics.isEmpty else { return }
        
        //mark: for compound exercises
        
        //save weight to all exercise metrics
        
        let weightTextField = TextField()
        
        weightTextField.setTextForEditingState = setTextFieldText(weightTextField, metric: .Weight)
        
        weightTextField.saveValue = {
            text in
            
            guard let weight = Double(text) else { return }
            
            exerciseMetrics.forEach({
              $0.save(double: weight, metric: .Weight)
            })
            
        }
        
        weightTextField.text = exerciseMetrics[0].value(for: .Weight).displayString
        textfields.append(weightTextField)
        textfieldLabels.append("Weight")
        
        //Input Reps for each individual exercise
        
        for (index, exerciseMetric) in exerciseMetrics.enumerated() {
            
            let repsTextField = TextField()
            repsTextField.saveValue = {
                text in
                guard let reps = Double(text) else { return }
                exerciseMetric.save(double: reps, metric: .Reps)
            }
            
            repsTextField.setTextForEditingState = setTextFieldText(repsTextField, metric: .Reps)
            
            textfields.append(repsTextField)
            
            let header = (exerciseMetric.exercise?.name ?? "") + " Reps"
            textfieldLabels.append(header)
            repsTextField.text = exerciseMetrics[index].value(for: .Reps).displayString
            
        }
        
        //Mark:Save sets to all exerciseMetrics
        
        let setsTextField = TextField()
        
        setsTextField.setTextForEditingState = setTextFieldText(setsTextField, metric: .Sets)
        
        setsTextField.saveValue = {
            text in
            
            guard let sets = Double(text) else { return }
            
            exerciseMetrics.forEach({
                $0.save(double: sets, metric: .Sets)
            })
            
        }
        
        textfields.append(setsTextField)
        textfieldLabels.append("Sets")
        setsTextField.text = exerciseMetrics[0].value(for: .Sets).displayString
        
    }
    
    

    func loadTextFieldContainers(exerciseMetric: Exercise_Metrics) {
        
        for metricInfo in exerciseMetric.metricInfos {
                setTextFieldFunctions(metricInfo: metricInfo, exerciseMetric: exerciseMetric)
            }
        
    }
    
    func setTextFieldFunctions( metricInfo: Metric_Info,
                                exerciseMetric: Exercise_Metrics) {
            
            //TODO: CHeck for retain cycles using self
            
            let textField = TextField()
        
            textField.setTextForEditingState = setTextFieldText(textField, metric: metricInfo.metric)
        
            setTextFieldSaveValue(textField,
                                 exerciseMetric: exerciseMetric,
                                 metricInfo: metricInfo)
            
        }
    
        func setTextFieldSaveValue(_ textField: TextField,
                                   exerciseMetric: Exercise_Metrics,
                                   metricInfo: Metric_Info)
        {
            
            
            switch metricInfo.unitOfMeasurement {
                
            case UnitLength.feet:
                
                textField.saveValue =
                metricInfo.saveExerciseMetricValue(exerciseMetric, nonStandardValue: .feet(.feet))
                textField.text = String(exerciseMetric.wholeFeet)
                textfieldLabels.append(UnitLength.feet.symbol)
                textfields.append(textField)
                
                let textField2 = TextField()

                textField2.saveValue =
                metricInfo.saveExerciseMetricValue(exerciseMetric, nonStandardValue: .feet(.inches))
                textField2.text = String(exerciseMetric.remainderInches)
                textfieldLabels.append(UnitLength.inches.symbol)
                textfields.append(textField2)
                
            case UnitDuration.minutes:
                
                textField.saveValue =
                metricInfo.saveExerciseMetricValue(exerciseMetric, nonStandardValue: .minutes(.minutes))
                textField.text = String(exerciseMetric.wholeMinutes)
                textfieldLabels.append(UnitDuration.minutes.symbol)
                textfields.append(textField)
                
                let textField2 = TextField()
                
                textField2.saveValue =
                metricInfo.saveExerciseMetricValue(exerciseMetric, nonStandardValue: .minutes(.seconds))
                textField2.text = String(exerciseMetric.remainderSeconds)
                textfieldLabels.append(UnitDuration.seconds.symbol)
                textfields.append(textField2)
                
            default:
                
                textField.saveValue = metricInfo.saveExerciseMetricValue(exerciseMetric)
                textField.text = exerciseMetric.displayValue(for: metricInfo)
                textfieldLabels.append( metricInfo.unitOfMeasurement.symbol )
                textfields.append(textField)
                
        }
     
    }
    

    
    func setTextFieldText(_ textField: UITextField, metric: Metric) -> (TextFieldEditingState) -> String {
        
        func setState(editingState: TextFieldEditingState) -> String {
            
            let text = textField.text ?? ""
            
            switch editingState {
                
            case .beginning:
                
                setButtonStates(for: metric)
                
                switch text {
                case "0": return ""
                default: return text
                }
                
            case .ending:
                
                switch text {
                case "": return "0"
                default: return text
                    
                }
            }
        }
        
        return setState
    }
    
    func setButtonStates(for metric: Metric) {
        
        if let bwBtn = nonstandardKeyboardButtons[KeyboardButtonType.bodyweight] {
            bwBtn.isEnabled = metric == .Weight
        }
        
        if let addMissedRepBtn = nonstandardKeyboardButtons[KeyboardButtonType.addMissedRep] {
            addMissedRepBtn.isEnabled = metric == .Reps
        }
        
    }
    
    
}










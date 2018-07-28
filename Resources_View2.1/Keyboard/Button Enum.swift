//
//  Button Enum.swift
//  Collection View Framework
//
//  Created by B_Litwin on 2/18/18.
//  Copyright © 2018 B_Litwin. All rights reserved.
//

import UIKit

public enum KeyboardButtonType: Hashable {
    
    case number(Int)
    case decimal
    case backspace
    case bodyweight
    case addMissedRep
    
    func editTextField(_ textField: UITextField) {
        
        if textField.text == nil {
            textField.text = ""
        }
        
        //editing a textfield that contains characters instead of numbers
        if let nonStandardReturn =
            handleTextContainingBodyweightOrMissedReps(text: textField.text!) {
            textField.text = nonStandardReturn.text
            if !nonStandardReturn.Continue { return }
        }
        
        switch self {
            
        case .number(let number):
            textField.text! += String(number)
            
        case .decimal:
            guard !textField.text!.characters.contains(".") else { return }
            textField.text! += "."
            
        case .backspace:
            
            guard !textField.text!.isEmpty else { return }
            
            let endIndex = textField.text!.index(before: textField.text!.endIndex)
            textField.text!.remove(at: endIndex)
            
        case .bodyweight:
            textField.text = bw
            
        case .addMissedRep:
            
            if textField.text!.IsEmptyString {
                textField.text = "X"
            } else {
                textField.text = textField.text! + " + X"
            }
            
        }
        
    }
    
    func handleTextContainingBodyweightOrMissedReps(text: String) -> (text: String, Continue: Bool)? {
        
        switch text {
            
        case let t where t.characters.first == "0":
            return ("", true)
        
        case let t where t == "BW":
            
            switch self {
            case .bodyweight: return (text, false)
            default: return ("", true)
            }
            
        //textfield value contains missed reps
        // eiether; "X" or "1 + X" 
            
        case let t where t.characters.contains("X"):
            
            switch self {
               
            //same value as that already in textfield - missed r
            case .addMissedRep:
                return (text, false)
                
            default:
                
                var returnString = ""
                
                if let s = text.removeNonNumericValues() {
                    returnString = String(s.displayString())
                }
                
                switch self {
                    
                case .backspace:
                    return (returnString, false)
                default:
                    return (returnString, true)
                }
            
            }
        
        default:
            break
            
        }

        return nil
    }
    
    
    
    var bw: String {
        return "BW"
    }
    
    public var hashValue: Int {
        switch self {
        case .number(let number):
            return number.hashValue
        default:
            return "\(self)".hashValue
        }
    }
    
    public static func ==(lhs: KeyboardButtonType, rhs: KeyboardButtonType) -> Bool {
        switch (lhs, rhs) {
        case (.number(let num1),.number(let num2)):
            return num1 == num2
        case (.decimal, .decimal):
            return true
        case (.backspace, .backspace):
            return true
        case (.bodyweight, .bodyweight):
            return true
        case (.addMissedRep, .addMissedRep):
            return true
        default:
            return false
        }
    }
    
}


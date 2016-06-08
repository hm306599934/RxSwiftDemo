//
//  CalculateState.swift
//  RxSwiftDemo
//
//  Created by Jimmy on 6/6/2016.
//  Copyright © 2016 Jimmy. All rights reserved.
//

import Foundation

struct CalculatState {
    let previousNumber: String!
    let action: CalculateAction
    let currentNumber: String!
    let inScreen: String
    let replace: Bool
    
    static let CLEAR_STATE = CalculatState(previousNumber: nil, action: .Clear, currentNumber: "0", inScreen: "0", replace: true)
}

extension CalculatState {

    func tranformState(x: CalculateAction) -> CalculatState {
        switch x {
        case .Clear:
            return .CLEAR_STATE
        case .AddNumber(let c):
            return addNumber(c)
        case .AddDot:
            return self.addDot()
        case .ChangeSign:
            let d = "\(-Double(self.inScreen)!)"
            return CalculatState(previousNumber: previousNumber, action: action, currentNumber: d, inScreen: d, replace: true)
        case .Percent:
            let d = "\(Double(self.inScreen)!/100)"
            return CalculatState(previousNumber: previousNumber, action: action, currentNumber: d, inScreen: d, replace: true)
        case .Operation(let o):
            return performOperation(o)
        case .Equal:
            return performEqual()
        }
    }
    
    func addNumber(char: Character) -> CalculatState {
        let cn = currentNumber == nil || currentNumber == "0" || replace ? String(char) : inScreen + String(char)
        return CalculatState(previousNumber: previousNumber, action: action, currentNumber: cn, inScreen: cn, replace: false)
    }
    
    func addDot() -> CalculatState {
        let cn = inScreen.rangeOfString(".") == nil ? currentNumber + "." : currentNumber
        return CalculatState(previousNumber: previousNumber, action: action, currentNumber: cn, inScreen: cn, replace: false)
    }
    
    func performOperation(o: Operator) -> CalculatState {
        
        if previousNumber == nil {
            return CalculatState(previousNumber: currentNumber, action: .Operation(o), currentNumber: nil, inScreen: currentNumber, replace: true)
        }
        else {
            let previous = Double(previousNumber)!
            let current = Double(inScreen)!
            
            switch action {
            case .Operation(let op):
                switch op {
                case .Plus:
                    let result = "\(previous + current)"
                    return CalculatState(previousNumber: result, action: .Operation(o), currentNumber: nil, inScreen: result, replace: true)
                case .Minus:
                    let result = "\(previous - current)"
                    return CalculatState(previousNumber: result, action: .Operation(o), currentNumber: nil, inScreen: result, replace: true)
                case .Multiply:
                    let result = "\(previous * current)"
                    return CalculatState(previousNumber: result, action: .Operation(o), currentNumber: nil, inScreen: result, replace: true)
                case .Divide:
                    let result = "\(previous / current)"
                    return CalculatState(previousNumber: result, action: .Operation(o), currentNumber: nil, inScreen: result, replace: true)
                }
            default:
                return CalculatState(previousNumber: nil, action: .Operation(o), currentNumber: currentNumber, inScreen: inScreen, replace: true)
            }
            
        }
        
    }
    
    func performEqual() -> CalculatState {
        let previous = Double(previousNumber ?? "0")
        let current = Double(inScreen)!
        
        switch action {
        case .Operation(let op):
            switch op {
            case .Plus:
                let result = "\(previous! + current)"
                return CalculatState(previousNumber: nil, action: .Clear, currentNumber: result, inScreen: result, replace: true)
            case .Minus:
                let result = "\(previous! - current)"
                return CalculatState(previousNumber: nil, action: .Clear, currentNumber: result, inScreen: result, replace: true)
            case .Multiply:
                let result = "\(previous! * current)"
                return CalculatState(previousNumber: nil, action: .Clear, currentNumber: result, inScreen: result, replace: true)
            case .Divide:
                let result = previous! / current
                let resultText = result == Double.infinity ? "0" : "\(result)"
                return CalculatState(previousNumber: nil, action: .Clear, currentNumber: resultText, inScreen: resultText, replace: true)
            }
        default:
            return CalculatState(previousNumber: nil, action: .Clear, currentNumber: currentNumber, inScreen: inScreen, replace: true)
        }
    }
}
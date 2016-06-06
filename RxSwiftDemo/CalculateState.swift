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
    let currentNumber: String
    let inScreen: String
    let repleace: Bool
    
    static let CLEAR_STATE = CalculatState(previousNumber: nil, action: .Clear, currentNumber: "0", inScreen: "0", repleace: true)
}

extension CalculatState {

    func tranformState(x: CalculateAction) -> CalculatState {
        
    }
}
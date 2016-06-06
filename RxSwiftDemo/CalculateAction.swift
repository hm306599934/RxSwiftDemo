//
//  CalculateAction.swift
//  RxSwiftDemo
//
//  Created by Jimmy on 6/6/2016.
//  Copyright © 2016 Jimmy. All rights reserved.
//

import Foundation

enum CalculateAction {
    case Clear
    case ChangeSign
    case Percent
    case Operation(Operator)
    case Equal
    case AddNumber(Character)
    case AddDot
}
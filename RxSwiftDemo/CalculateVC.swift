//
//  CalculateVC.swift
//  RxSwiftDemo
//
//  Created by Jimmy on 6/6/2016.
//  Copyright © 2016 Jimmy. All rights reserved./Users/Jimmy/Desktop/Demo/RxSwiftDemo/RxSwiftDemo
//

import UIKit
import RxSwift
import RxCocoa

class CalculateVC: UIViewController {
    
    @IBOutlet weak var mLabelResult: UILabel!
    @IBOutlet weak var mLabelSign: UILabel!
    
    @IBOutlet weak var mButtonZero: UIButton!
    @IBOutlet weak var mButtonOne: UIButton!
    @IBOutlet weak var mButtonTwo: UIButton!
    @IBOutlet weak var mButtonThree: UIButton!
    @IBOutlet weak var mButtonFour: UIButton!
    @IBOutlet weak var mButtonFive: UIButton!
    @IBOutlet weak var mButtonSix: UIButton!
    @IBOutlet weak var mButtonSeven: UIButton!
    @IBOutlet weak var mButtonEight: UIButton!
    @IBOutlet weak var mButtonNine: UIButton!
    
    @IBOutlet weak var mButtonEqual: UIButton!
    @IBOutlet weak var mButtonPlus: UIButton!
    @IBOutlet weak var mButtonMultiply: UIButton!
    @IBOutlet weak var mButtonMinus: UIButton!
    @IBOutlet weak var mButtonDivide: UIButton!
    
    @IBOutlet weak var mButtonDot: UIButton!
    @IBOutlet weak var mButtonAllClear: UIButton!
    @IBOutlet weak var mButtonSign: UIButton!
    @IBOutlet weak var mButtonPercent: UIButton!
    
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let commands:[Observable<CalculateAction>] = [
            mButtonZero.rx_tap.map{ .AddNumber("0") },
            mButtonOne.rx_tap.map { .AddNumber("1") },
            mButtonTwo.rx_tap.map{ .AddNumber("2") },
            mButtonThree.rx_tap.map{ .AddNumber("3") },
            mButtonFour.rx_tap.map{ .AddNumber("4") },
            mButtonFive.rx_tap.map{ .AddNumber("5") },
            mButtonSix.rx_tap.map{ .AddNumber("6") },
            mButtonSeven.rx_tap.map{ .AddNumber("7") },
            mButtonEight.rx_tap.map{ .AddNumber("8") },
            mButtonNine.rx_tap.map{ .AddNumber("9") },
            
            mButtonEqual.rx_tap.map{ .Equal },
            mButtonPlus.rx_tap.map{ .Operation(.Plus) },
            mButtonMinus.rx_tap.map{ .Operation(.Minus) },
            mButtonMultiply.rx_tap.map{ .Operation(.Multiply) },
            mButtonDivide.rx_tap.map{ .Operation(.Divide) },
            
            mButtonAllClear.rx_tap.map{ .Clear },
            mButtonSign.rx_tap.map{ .ChangeSign },
            mButtonPercent.rx_tap.map{ .Percent },
            mButtonDot.rx_tap.map{ .AddDot }
        ]
        
        commands.toObservable()
                .merge()
                .scan(CalculatState.CLEAR_STATE) { a, x in
                    return a.tranformState(x)
                }
                .subscribeNext { [weak self] calState in
                    self?.mLabelResult.text = self?.prettyFormat(calState.inScreen)
                }
                .addDisposableTo(disposeBag)
    }
    
    func prettyFormat(str: String) -> String {
        if str.hasSuffix(".0") {
            return str.substringToIndex(str.endIndex.predecessor().predecessor())
        }
        return str
    }

}

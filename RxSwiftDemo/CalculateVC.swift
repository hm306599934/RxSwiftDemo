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
    
    @IBOutlet weak var mButtonOne: UIButton!
    @IBOutlet weak var mButtonTwo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let commands:[Observable<CalculateAction>] = [
            
        ]
        
        commands.toObservable()
                .merge()
        
    }

}

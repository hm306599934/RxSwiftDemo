//
//  LoginVC.swift
//  RxSwiftDemo
//
//  Created by Jimmy on 11/6/2016.
//  Copyright © 2016 Jimmy. All rights reserved.
//

import UIKit
import RxSwift

class LoginVC: UIViewController {
    
    @IBOutlet weak var mImageView: UIImageView!
    @IBOutlet weak var mLoginButton: UIButton!
    @IBOutlet weak var mUserTextField: UITextField!
    @IBOutlet weak var mPasswordTextField: UITextField!
    
    var disposeBag = DisposeBag()
    let minimalUsernameLength = 11
    let minimalPasswordLength = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let userValid = mUserTextField.rx_text
            .map{ $0.characters.count >= self.minimalUsernameLength }
            .shareReplay(1)

        let passwordValid = mPasswordTextField.rx_text
            .map{ $0.characters.count >= self.minimalPasswordLength }
            .shareReplay(1)
        
        let loginValid = Observable
            .combineLatest(userValid, passwordValid) { $0 && $1 }
            .shareReplay(1)
        
        userValid.bindTo(mPasswordTextField.rx_enabled)
            .addDisposableTo(disposeBag)
        
        loginValid.subscribeNext {[weak self] isLogin in
            if (isLogin && self?.mLoginButton.enabled == false) {
                self?.mLoginButton.alpha = 1.0
                self?.mLoginButton.enabled = true
            } else if (!isLogin && self?.mLoginButton.enabled == true){
                self?.mLoginButton.alpha = 0.5
                self?.mLoginButton.enabled = false
            }
        }.addDisposableTo(disposeBag)
        
        mLoginButton.rx_tap
            .subscribeNext{ [weak self] in self?.login() }
            .addDisposableTo(disposeBag)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func login() {
        
    }
    
}

//
//  ViewController.swift
//  Reactor
//
//  Created by Alex Fayzullov on 3/22/18.
//  Copyright © 2018 Techery. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController, View {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = LoginReactor()
    }
    
    func bind(reactor: LoginReactor) {
        phoneField.rx.text
            .filter { $0 != nil }
            .map { LoginReactor.Action.typing($0!) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.phoneNumber }
            .bind(to: phoneField.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.phoneValid }
            .bind(to: sendButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    typealias Reactor = LoginReactor
    
    @IBOutlet var phoneField: UITextField!
    @IBOutlet var sendButton: UIButton!
    
    var disposeBag: DisposeBag = DisposeBag()
}

extension Reactive where Base: LoginViewController {
    
    var send: ControlEvent<String> {
        let source = base.sendButton.rx.controlEvent(UIControlEvents.touchUpInside)
            .withLatestFrom(base.reactor!.state)
            .map {
                $0.phoneNumber
            }
        return ControlEvent(events: source)
    }
}

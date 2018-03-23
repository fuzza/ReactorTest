//
//  SignupController.swift
//  Reactor
//
//  Created by Alex Fayzullov on 3/23/18.
//  Copyright © 2018 Techery. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit
import SnapKit
import RxFlow

class SignupController: UIViewController,Stepper, View {
    var disposeBag: DisposeBag = DisposeBag()
    
    typealias Reactor = SignupReactor
    
    func bind(reactor: SignupReactor) {
        reactor.state
            .map { $0.transactionId }
            .filter { $0 != nil }
            .map { SignupFlow.Steps.confirm($0!) }
            .bind(to: step)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isLoading }
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    let activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    
    let phone: LoginViewController
    
    required init(login: LoginViewController) {
        self.phone = login
        super.init(nibName: nil, bundle: nil)
        self.reactor = SignupReactor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        addChildViewController(phone)
        view.addSubview(phone.view)
        phone.didMove(toParentViewController: self)
        
        phone.view.snp.makeConstraints { make -> Void in
            make.top.equalTo(self.view).offset(100)
            make.left.equalTo(self.view).offset(10)
            make.right.equalTo(self.view).offset(-10)
            make.height.equalTo(200)
        }
        
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(self.view)
        }
        
        phone.rx.send
            .map { Reactor.Action.sendPhone($0) }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
}

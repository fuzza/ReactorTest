//
//  SignupFlow.swift
//  Reactor
//
//  Created by Alex Fayzullov on 3/23/18.
//  Copyright © 2018 Techery. All rights reserved.
//

import Foundation
import RxFlow

class SignupFlow: Flow {
    
    var root: Presentable {
        return self.navigation
    }
    
    let navigation: UINavigationController

    init(navigation: UINavigationController) {
        self.navigation = navigation
    }
    
    enum Steps: Step {
        case start
        case login
        case confirm(String)
    }
    
    func navigate(to step: Step) -> NextFlowItems {
        guard let step = step as? Steps else { return .none }
        
        switch step {
        case .start:
            return navigate(to: Steps.login)
        case .login:
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let login = storyboard.instantiateInitialViewController() as! LoginViewController
            let signup = SignupController(login: login)
            navigation.setViewControllers([signup], animated: false)
            return NextFlowItems.one(flowItem: NextFlowItem(nextPresentable: signup, nextStepper: signup))
        case let .confirm(code):
            print("Confirm \(code)")
            return .none
        }
    }
}

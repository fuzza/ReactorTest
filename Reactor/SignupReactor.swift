//
//  SignupReactor.swift
//  Reactor
//
//  Created by Alex Fayzullov on 3/23/18.
//  Copyright © 2018 Techery. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

class SignupReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case sendPhone(String)
        case setFacebookToken(String)
    }
    
    enum Mutation {
        case sendPhone(Operation<String>)
        case setFacebookToken(String)
        case facebookLogin(Operation<String>)
    }
    
    struct State {
        var isLoading: Bool {
            return isSendingPhone || isLoggingIn
        }
        
        var loggedIn: Bool = false
        
        var isSendingPhone: Bool = false
        var isLoggingIn: Bool = false
        
        var errorMessage: String?
        
        var facebookToken: String?
        var transactionId: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .sendPhone(_):
            let start = Observable.just(Mutation.sendPhone(.loading))
            let result = Observable.just(Mutation.sendPhone(.success("test_code"))).delay(2, scheduler: MainScheduler.instance)
            return .concat([start, result])
            
        case let .setFacebookToken(token):
            let token = Observable.just(Mutation.setFacebookToken(token))
            let start = Observable.just(Mutation.facebookLogin(.loading))
            let result = Observable.just(Mutation.facebookLogin(.success("authorization token"))).delay(2, scheduler: MainScheduler.instance)
            let clear = Observable.just(Mutation.facebookLogin(.none))
            return .concat([token, start, result, clear])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setFacebookToken(token):
            state.facebookToken = token
            
        case let .sendPhone(operation):
            state.isSendingPhone = operation.isLoading
            state.errorMessage = operation.error
            state.facebookToken = operation.result
            
        case let .facebookLogin(operation):
            state.isLoggingIn = operation.isLoading
            state.errorMessage = operation.error
            state.loggedIn = true
        }
        return state
    }
    
    func transform(action: Observable<SignupReactor.Action>) -> Observable<SignupReactor.Action> {
        return action.do(onNext: { action in
            print(action)
        })
    }
}

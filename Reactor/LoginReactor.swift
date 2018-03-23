//
//  LoginReactor.swift
//  Reactor
//
//  Created by Alex Fayzullov on 3/22/18.
//  Copyright © 2018 Techery. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

enum Operation<T> {
    case none
    case loading
    case success(T)
    case failure(String)
    
    var isLoading: Bool {
        switch self {
        case .loading: return true
        default: return false
        }
    }
    
    var result: T? {
        switch self {
        case let .success(result): return result
        default: return nil
        }
    }
    
    var error: String? {
        switch self {
        case let .failure(error): return error
        default: return nil
        }
    }
}


class LoginReactor: Reactor {
    var initialState: State = State()
    
    enum Action {
        case typing(String)
    }
    
    enum Mutation {
        case setPhoneNumber(String)
    }
    
    struct State {
        var phoneNumber: String = ""
        var phoneValid: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case let .typing(phone):
            return Observable.just(Mutation.setPhoneNumber(phone))
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        
        switch mutation {
        case let .setPhoneNumber(phone):
            state.phoneNumber = phone.truncate(length: 10)
            state.phoneValid = !phone.isEmpty
        }
        
        return state
    }
    
    func transform(state: Observable<LoginReactor.State>) -> Observable<LoginReactor.State> {
        return state.do(onNext: { state in
            print(state)
        })
    }
}

extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncate(length: Int, trailing: String = "") -> String {
        if count > length {
            return String(prefix(length)) + trailing
        } else {
            return self
        }
    }
}

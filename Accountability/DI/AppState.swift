//
//  AppState.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/21/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

class AppState: ObservableObject {
    
    @Published var user: User!
    @Published var goals = [Goal]()
    
    private let fetchUserUseCase = UseCaseProvider().fetchUserUseCase
    private let fetchAllGoalsUseCase = UseCaseProvider().fetchAllGoalsUseCase

    init() {
        fetchUser()
        fetchAllGoals()
    }
    
    func fetchUser() {
        fetchUserUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userResponse):
                self.user = userResponse
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchAllGoals() {
        fetchAllGoalsUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let goals):
                self.goals = goals
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
}

extension AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.user == rhs.user &&
            lhs.goals == rhs.goals
    }
}


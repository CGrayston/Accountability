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
    @Published var goals: [Goal]?

    @Published var group: AccountabilityGroup?
    @Published var groupGoals: [Goal]?
    var memberNames: [String: String]?
    
    private let fetchUserUseCase = UseCaseProvider().fetchUserUseCase
    private let fetchAllGoalsUseCase = UseCaseProvider().fetchAllGoalsUseCase
    private let fetchGroupUseCase = UseCaseProvider().fetchGroupUseCase
    private let fetchLeaderboardGoalsThisWeekUseCase = UseCaseProvider().fetchGroupGoalsThisWeekUseCase
    private let fetchGroupMemberNamesUseCase = UseCaseProvider().fetchGroupMemberNamesUseCase
    
    init() {
        fetchUser()
        fetchAllGoals()
        fetchAccountabilityGroupAndLeaderboardGoals()
    }
    
    private func fetchUser() {
        fetchUserUseCase.execute { result in
            switch result {
            case .success(let userResponse):
                self.user = userResponse
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func fetchAllGoals() {
        fetchAllGoalsUseCase.execute { result in
            switch result {
            case .success(let goals):
                self.goals = goals
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func fetchAccountabilityGroupAndLeaderboardGoals() {
        fetchGroupUseCase.execute { [self] result in
            switch result {
            case .success(let accountabilityGroup):
                self.group = accountabilityGroup

                if let memberIds = accountabilityGroup?.members.map({ $0.key }) {
                    fetchLeaderboardGoals(memberIds: memberIds)
                    fetchMemberNames(memberIds: memberIds)
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    private func fetchLeaderboardGoals(memberIds: [String]) {
        fetchLeaderboardGoalsThisWeekUseCase.execute(request: memberIds) { [weak self] result in
            switch result {
            case .success(let groupGoals):
                self?.groupGoals = groupGoals
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    // TODO: Take this out of app state - If someone's name changes we need to take care of that
    private func fetchMemberNames(memberIds: [String]) {
        fetchGroupMemberNamesUseCase.execute(request: memberIds) { [weak self] result in
            switch result {
            case .success(let groupMembers):
                self?.memberNames = groupMembers
            case .failure(let error):
                fatalError("Error fetching member names: \(error.localizedDescription)")
            }
        }
    }
}

extension AppState: Equatable {
    static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.user == rhs.user &&
            lhs.goals == rhs.goals &&
            lhs.group == rhs.group &&
            lhs.groupGoals == rhs.groupGoals
    }
}


//
//  GoalRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol GoalRepository {
    
    func fetchGoalsThisWeek(completion: @escaping (Result<[Goal], Error>) -> Void)
    
    func createThisWeeksGoalsFromTemplate(goalsTemplate: [String: Int], completion: @escaping (Result<Void, Error>) -> Void)
    
    func addGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateGoal(requestModel: UpdateGoalRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteGoal(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func incrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func decrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func fetchGroupGoalsThisWeek(memberIds: [String], completion: @escaping (Result<[Goal], Error>) -> Void)
}

final class GoalDataRepository: GoalRepository {
    
    let remoteDataSource: GoalDataSource
    
    init(remoteDataSource: GoalDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - Default Goal Implementation
    
    func fetchGoalsThisWeek(completion: @escaping (Result<[Goal], Error>) -> Void) {
        remoteDataSource.fetchGoalsThisWeek { result in
            completion(result)
        }
    }
    
    func createThisWeeksGoalsFromTemplate(goalsTemplate: [String: Int], completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.createThisWeeksGoalsFromTemplate(goalsTemplate: goalsTemplate) { result in
            completion(result)
        }
    }
    
    func addGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.addGoal(goal: goal) { result in
            completion(result)
        }
    }
    
    func updateGoal(requestModel: UpdateGoalRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.updateGoal(requestModel: requestModel) { result in
            completion(result)
        }
    }
    
    func deleteGoal(goalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.deleteGoal(goalId: goalId) { result in
            completion(result)
        }
    }
    
    func incrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.incrementGoalTimesThisWeek(goalId: goalId) { result in
            completion(result)
        }
    }
    
    func decrementGoalTimesThisWeek(goalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.decrementGoalTimesThisWeek(goalId: goalId) { result in
            completion(result)
        }
    }
}

// MARK: - Leaderboard Goal Implementation
extension GoalDataRepository {
    
    func fetchGroupGoalsThisWeek(memberIds: [String], completion: @escaping (Result<[Goal], Error>) -> Void) {
        remoteDataSource.fetchGroupGoalsThisWeek(memberIds: memberIds) { result in
            completion(result)
        }
    }
}

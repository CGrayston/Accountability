//
//  GoalRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol GoalRepository {
    
    func fetchAllGoals(completion: @escaping (Result<[Goal], Error>) -> Void)
    
    func addGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteGoal(goalId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class GoalDataRepository: GoalRepository {
    
    let remoteDataSource: GoalDataSource
    
    init(remoteDataSource: GoalDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func fetchAllGoals(completion: @escaping (Result<[Goal], Error>) -> Void) {
        remoteDataSource.fetchAllGoals { result in
            completion(result)
        }
    }
    
    func addGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.addGoal(goal: goal) { result in
            completion(result)
        }
    }
    
    func updateGoal(goal: Goal, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.updateGoal(goal: goal) { result in
            completion(result)
        }
    }
    
    func deleteGoal(goalId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.deleteGoal(goalId: goalId) { result in
            completion(result)
        }
    }
}

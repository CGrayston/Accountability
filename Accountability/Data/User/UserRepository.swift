//
//  UserRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/29/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol UserRepository {
    
    // MARK: - User CRUD Methods

    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
    
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func logOutUser(completion: @escaping (Result<Void, Error>) -> Void)
    
    // MARK: - Goal Template CRUD Methods

    func fetchGoalsTemplate(completion: @escaping (Result<[String: Int]?, Error>) -> Void)

    func addGoalTemplateEntry(request: GoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateGoalTemplateEntry(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void)

    func deleteGoalTemplateEntry(goalTitle: String, completion: @escaping (Result<Void, Error>) -> Void)

    func clearGoalsTemplate(completion: @escaping (Result<Void, Error>) -> Void)
    
    // MARK: - Username/Title Verification Methods

    func isUniqueUserName(username: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func isValidNewGoalTitle(newTitle: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func isValidUpdatedGoalTitle(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserDataRepository: UserRepository {
    
    let remoteDataSource: UserDataSource
    
    init(remoteDataSource: UserDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    // MARK: - User CRUD Methods
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void) {
        remoteDataSource.fetchUser { result in
            completion(result)
        }
    }
    
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.createUser(user: user) { result in
            completion(result)
        }
    }
    
    func updateUser(user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.updateUser(user: user) { result in
            completion(result)
        }
    }
    
    func logOutUser(completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.logOutUser { result in
            completion(result)
        }
    }
    
    // MARK: - Goal Template CRUD Methods
    
    func fetchGoalsTemplate(completion: @escaping (Result<[String: Int]?, Error>) -> Void) {
        remoteDataSource.fetchGoalsTemplate { result in
            completion(result)
        }
    }
    
    func addGoalTemplateEntry(request: GoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.addGoalTemplateEntry(request: request) { result in
            completion(result)
        }
    }
    
    func updateGoalTemplateEntry(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.updateGoalTemplateEntry(requestModel: requestModel) { result in
            completion(result)
        }
    }
    
    func deleteGoalTemplateEntry(goalTitle: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.deleteGoalTemplateEntry(goalTitle: goalTitle) { result in
            completion(result)
        }
    }
    
    func clearGoalsTemplate(completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.clearGoalsTemplate { result in
            completion(result)
        }
    }
    
    // MARK: - Username/Title Verification Methods
    
    func isUniqueUserName(username: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.isUniqueUserName(username: username) { result in
            completion(result)
        }
    }
    
    func isValidNewGoalTitle(newTitle: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.isValidNewGoalTitle(newTitle: newTitle) { result in
            completion(result)
        }
    }

    func isValidUpdatedGoalTitle(requestModel: UpdateGoalTemplateRequestModel, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.isValidUpdatedGoalTitle(requestModel: requestModel) { result in
            completion(result)
        }
    }
}

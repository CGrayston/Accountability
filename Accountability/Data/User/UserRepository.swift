//
//  UserRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/29/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol UserRepository {
    
    func fetchUser(completion: @escaping (Result<User, Error>) -> Void)
    
    func createUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func updateUser(user: User, completion: @escaping (Result<Void, Error>) -> Void)
    
    func logOutUser(completion: @escaping (Result<Void, Error>) -> Void)
}

final class UserDataRepository: UserRepository {
    
    let remoteDataSource: UserDataSource
    
    init(remoteDataSource: UserDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
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
}

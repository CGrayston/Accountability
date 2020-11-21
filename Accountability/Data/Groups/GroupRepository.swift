//
//  GroupsRepository.swift
//  Accountability
//
//  Created by Christopher Grayston on 11/11/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

protocol GroupRepository {

    func joinGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func createGroup(name: String, completion: @escaping (Result<String, Error>) -> Void)
    
    func leaveGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

final class GroupDataRepository: GroupRepository {
    
    let remoteDataSource: GroupDataSource
    
    init(remoteDataSource: GroupDataSource) {
        self.remoteDataSource = remoteDataSource
    }
    
    func joinGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.joinGroup(groupId: groupId) { result in
            completion(result)
        }
    }
    
    func createGroup(name: String, completion: @escaping (Result<String, Error>) -> Void) {
        remoteDataSource.createGroup(name: name) { result in
            completion(result)
        }
    }
    
    func leaveGroup(groupId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        remoteDataSource.leaveGroup(groupId: groupId) { result in
            completion(result)
        }
    }
}

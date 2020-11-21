//
//  RepositoryProvider.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class RepositoryProvider {
    
    //MARK: - Goal
    
    lazy var goalRepository: GoalRepository = {
        let goalRemoteDataSource = DataSourceProvider().goalRemoteDataSource
        return GoalDataRepository(remoteDataSource: goalRemoteDataSource)
    }()
    
    //MARK: - Task
    
    lazy var taskRepository: TaskRepository = {
        let taskRemoteDataSource = DataSourceProvider().taskRemoteDataSource
        return TaskDataRepository(remoteDataSource: taskRemoteDataSource)
    }()
    
    //MARK: - Entry
    
    lazy var entryRepository: EntryRepository = {
        let entryRemoteDataSource = DataSourceProvider().entryRemoteDataSource
        return EntryDataRepository(remoteDataSource: entryRemoteDataSource)
    }()
    
    //MARK: - User
    
    lazy var userRepository: UserRepository = {
        let userRemoteDataSource = DataSourceProvider().userRemoteDataSource
        return UserDataRepository(remoteDataSource: userRemoteDataSource)
    }()
    
    //MARK: - Group
    
    lazy var groupRepository: GroupRepository = {
        let groupRemoteDataSource = DataSourceProvider().groupRemoteDataSource
        return GroupDataRepository(remoteDataSource: groupRemoteDataSource)
    }()
}

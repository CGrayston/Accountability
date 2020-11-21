//
//  DataSourceProvider.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class DataSourceProvider {
    
    // MARK: - Goal
    
    lazy var goalRemoteDataSource: GoalDataSource = {
        return GoalRemoteDataSource()
    }()
    
    // MARK: - Task
    
    lazy var taskRemoteDataSource: TaskDataSource = {
        return TaskRemoteDataSource()
    }()
    
    // MARK: - Entry
    
    lazy var entryRemoteDataSource: EntryDataSource = {
        return EntryRemoteDataSource()
    }()
    
    // MARK: - User
    
    lazy var userRemoteDataSource: UserDataSource = {
        return UserRemoteDataSource()
    }()
    
    // MARK: - Group
    
    lazy var groupRemoteDataSource: GroupDataSource = {
        return GroupRemoteDataSource()
    }()
}

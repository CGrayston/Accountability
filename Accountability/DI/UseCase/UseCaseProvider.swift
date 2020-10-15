//
//  UseCaseProvider.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation

class UseCaseProvider {

    // MARK: - Goal
    
    lazy var fetchAllGoalsUseCase: FetchAllGoalsUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return FetchAllGoalsUseCase(goalRepository: goalRepository)
    }()
    
    lazy var addGoalUseCase: AddGoalUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return AddGoalUseCase(goalRepository: goalRepository)
    }()
    
    lazy var updateGoalUseCase: UpdateGoalUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return UpdateGoalUseCase(goalRepository: goalRepository)
    }()
    
    lazy var deleteGoalUseCase: DeleteGoalUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return DeleteGoalUseCase(goalRepository: goalRepository)
    }()
    
    // MARK: - Task
    
    lazy var fetchAllTasksUseCase: FetchAllTasksUseCase = {
        let taskRepository = RepositoryProvider().taskRepository
        return FetchAllTasksUseCase(taskRepository: taskRepository)
    }()
    
    lazy var addTaskUseCase: AddTaskUseCase = {
        let taskRepository = RepositoryProvider().taskRepository
        return AddTaskUseCase(taskRepository: taskRepository)
    }()
    
    lazy var updateTaskUseCase: UpdateTaskUseCase = {
        let taskRepository = RepositoryProvider().taskRepository
        return UpdateTaskUseCase(taskRepository: taskRepository)
    }()

    // MARK: - Entry
    
    lazy var fetchAllEntriesUseCase: FetchAllEntriesUseCase = {
        let entryRepository = RepositoryProvider().entryRepository
        return FetchAllEntriesUseCase(entryRepository: entryRepository)
    }()
    
    lazy var createEntryUseCase: CreateEntryUseCase = {
        let entryRepository = RepositoryProvider().entryRepository
        return CreateEntryUseCase(entryRepository: entryRepository)
    }()
    
    lazy var updateEntryUseCase: UpdateEntryUseCase = {
        let entryRepository = RepositoryProvider().entryRepository
        return UpdateEntryUseCase(entryRepository: entryRepository)
    }()
    
    // MARK: - User
    
    lazy var fetchUserUseCase: FetchUserUseCase = {
        let userRepository = RepositoryProvider().userRepository
        return FetchUserUseCase(userRepository: userRepository)
    }()
    
    lazy var createUserUseCase: CreateUserUseCase = {
        let userRepository = RepositoryProvider().userRepository
        return CreateUserUseCase(userRepository: userRepository)
    }()
    
    lazy var updateUserUseCase: UpdateUserUseCase = {
        let userRepository = RepositoryProvider().userRepository
        return UpdateUserUseCase(userRepository: userRepository)
    }()
    
    lazy var logOutUserUseCase: LogOutUserUseCase = {
        let userRepository = RepositoryProvider().userRepository
        return LogOutUserUseCase(userRepository: userRepository)
    }()
}

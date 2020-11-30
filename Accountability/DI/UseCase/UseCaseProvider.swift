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
    
    lazy var fetchAllGoalsUseCase: FetchGoalsThisWeekUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return FetchGoalsThisWeekUseCase(goalRepository: goalRepository)
    }()
    
    lazy var createThisWeeksGoalsFromTemplateUseCase: CreateThisWeeksGoalsFromTemplateUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        let userRepository = RepositoryProvider().userRepository
        let errorMapper = GoalsTemplateToErrorMapper()
        return CreateThisWeeksGoalsFromTemplateUseCase(goalRepository: goalRepository, userRepository: userRepository)
    }()
    
    lazy var addGoalUseCase: AddGoalUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        let userRepository = RepositoryProvider().userRepository
        return AddGoalUseCase(goalRepository: goalRepository, userRepository: userRepository)
    }()
    
    lazy var updateGoalUseCase: UpdateGoalUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        let userRepository = RepositoryProvider().userRepository
        return UpdateGoalUseCase(goalRepository: goalRepository, userRepository: userRepository)
    }()
    
    lazy var deleteGoalUseCase: DeleteGoalUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        let userRepository = RepositoryProvider().userRepository
        return DeleteGoalUseCase(goalRepository: goalRepository, userRepository: userRepository)
    }()
    
    lazy var incrementGoalTimesThisWeekUseCase: IncrementGoalTimesThisWeekUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return IncrementGoalTimesThisWeekUseCase(goalRepository: goalRepository)
    }()
    
    lazy var decrementGoalTimesThisWeekUseCase: DecrementGoalTimesThisWeekUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return DecrementGoalTimesThisWeekUseCase(goalRepository: goalRepository)
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
    
    // MARK: - UserTemplate
    
    lazy var fetchTemplateStatusUseCase: FetchTemplateStatusUseCase = {
        let userRepository = RepositoryProvider().userRepository
        return FetchTemplateStatusUseCase(userRepository: userRepository)
    }()
    
    // MARK: - Groups
    
    lazy var fetchGroupUseCase: FetchGroupUseCase = {
        let groupRepository = RepositoryProvider().groupRepository
        return FetchGroupUseCase(groupRepository: groupRepository)
    }()
    
    lazy var joinGroupUseCase: JoinGroupUseCase = {
        let groupRepository = RepositoryProvider().groupRepository
        let userRepository = RepositoryProvider().userRepository
        return JoinGroupUseCase(groupRepository: groupRepository, userRepository: userRepository)
    }()
    
    lazy var createGroupUseCase: CreateGroupUseCase = {
        let groupRepository = RepositoryProvider().groupRepository
        let userRepository = RepositoryProvider().userRepository
        return CreateGroupUseCase(groupRepository: groupRepository, userRepository: userRepository)
    }()
    
    lazy var leaveGroupUseCase: LeaveGroupUseCase = {
        let groupRepository = RepositoryProvider().groupRepository
        let userRepository = RepositoryProvider().userRepository
        return LeaveGroupUseCase(groupRepository: groupRepository, userRepository: userRepository)
    }()
    
    // MARK: - Leaderboard
    
    lazy var fetchGroupGoalsThisWeekUseCase: FetchGroupGoalsThisWeekUseCase = {
        let goalRepository = RepositoryProvider().goalRepository
        return FetchGroupGoalsThisWeekUseCase(goalRepository: goalRepository)
    }()
    
    lazy var fetchGroupMemberNamesUseCase: FetchGroupMemberNamesUseCase = {
        let userRepository = RepositoryProvider().userRepository
        return FetchGroupMemberNamesUseCase(userRepository: userRepository)
    }()
}

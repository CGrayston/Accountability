//
//  GoalEditorViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/7/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Combine

class GoalEditorViewModel: ObservableObject {
    
    @Published var goal: Goal
    
    private let addGoalUseCase = UseCaseProvider().addGoalUseCase
    private let updateGoalUseCase = UseCaseProvider().updateGoalUseCase
    private let deleteGoalUseCase = UseCaseProvider().deleteGoalUseCase
    private let decrementGoalTimesThisWeekUseCase = UseCaseProvider().decrementGoalTimesThisWeekUseCase
        
    var id = ""
    private var cancellables = Set<AnyCancellable>()
    private let originalTitle: String
    
    init(goal: Goal) {
        self.goal = goal
        self.originalTitle = goal.title
        
        $goal
            .compactMap { goal in
                goal.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func addNewGoal(completion: @escaping (Result<Void, Error>) -> Void) {
        if goal.title.isEmpty {
            completion(.failure(InputError.blankTitle))
            return
        }
        
        addGoalUseCase.execute(request: goal) { result in
            completion(result)
        }
    }
    
    func updateCurrentGoal(completion: @escaping (Result<Void, Error>) -> Void) {
        if goal.title.isEmpty ||
            originalTitle.isEmpty {
            completion(.failure(InputError.blankTitle))
            return
        }
        
        guard let goalId = goal.id else {
            completion(.failure(InputError.nilGoalId))
            return
        }
        
        let requestModel = UpdateGoalRequestModel(originalTitle: originalTitle, newTitle: goal.title, timesPerWeek: goal.timesPerWeek, goalId: goalId)
        updateGoalUseCase.execute(request: requestModel) { result in
            completion(result)
        }
    }
    
    func deleteCurrentGoal(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let goalId = goal.id else {
            completion(.failure(InputError.nilGoalId))
            return
        }
        
        let requestModel = DeleteGoalRequestModel(goalId: goalId, goalTitle: goal.title)
        deleteGoalUseCase.execute(request: requestModel) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func decrementGoalTimesThisWeek(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let goalId = goal.id else {
            completion(.failure(InputError.nilGoalId))
            return
        }
        
        decrementGoalTimesThisWeekUseCase.execute(request: goalId) { result in
            completion(result)
        }
    }
}

// TODO: Own file once error handling is addressed
enum InputError: Error {
    case unknown
    case blankTitle
    case nilGoalId
 }

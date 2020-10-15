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
    
    var alertTitle: String?
    var alertMessage: String?
    
    var id = ""
    private var cancellables = Set<AnyCancellable>()
    
    init(goal: Goal) {
        self.goal = goal
        
        $goal
            .compactMap { goal in
                goal.id
            }
            .assign(to: \.id, on: self)
            .store(in: &cancellables)
    }
    
    func addNewGoal(completion: @escaping (Result<Void, Error>) -> Void) {
        // If goal
        if goal.title.isEmpty {
            alertTitle = "No Goal Title"
            alertMessage = "Please enter a title between 8 and 28 characters"
            completion(.failure(InputError.blankTitle))
            return
        }
        
        addGoalUseCase.execute(request: goal) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func updateCurrentGoal(completion: @escaping (Result<Void, Error>) -> Void) {
        updateGoalUseCase.execute(request: goal) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func deleteCurrentGoal(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let goalId = goal.id else {
            completion(.failure(InputError.nilGoalId))
            return
        }
        
        deleteGoalUseCase.execute(request: goalId) { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum InputError: Error {
    case unknown
    case blankTitle
    case nilGoalId
 }

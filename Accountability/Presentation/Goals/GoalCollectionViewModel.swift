//
//  GoalCollectionViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

class GoalCollectionViewModel: ObservableObject {

    @Published var goalProgressViewModels = [GoalProgressViewModel]()
    @Published var goals = [Goal]()

    private let fetchAllGoalsUseCase = UseCaseProvider().fetchAllGoalsUseCase
    private let fetchTemplateStatusUseCase = UseCaseProvider().fetchTemplateStatusUseCase
    private let createThisWeeksGoalsFromTemplateUseCase = UseCaseProvider().createThisWeeksGoalsFromTemplateUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var totalProgress: Double {
        let totalTimesThisWeek = goals.map { $0.timesThisWeek }.reduce(0, +)
        let totalTimesPerWeek = goals.map { $0.timesPerWeek }.reduce(0, +)
        
        return totalTimesPerWeek == 0 ? 0 : Double(totalTimesThisWeek)/Double(totalTimesPerWeek)
    }
    
    var hasGoals: Bool {
        return goals.count > 0
    }
    
    init(goals: [Goal]?) {
        guard let goals = goals else {
            return
        }
        
        self.goals = goals
        
//        if goals.count == 0 {
//            fetchTemplateStatusUseCase.execute(completion: { result in
//                self.fetchTemplateStatus(result)
//            })
//        }
        
        self.$goals
            .map { goals in
                goals.map { goal in
                    GoalProgressViewModel(goal: goal)
                }
        }
        .assign(to: \.goalProgressViewModels, on : self)
        .store(in: &self.cancellables)
    }
    
    func newWeekButtonPressed(completion: @escaping (Result<Void, Error>) -> Void) {
        createThisWeeksGoalsFromTemplateUseCase.execute { result in
            completion(result)
        }
    }
    
    func recievedEmptyAppStateGoals(completion: @escaping (Result<TemplateStatus, Error>) -> Void) {
        fetchTemplateStatusUseCase.execute(completion: { result in
            completion(result)
        })
    }
}

//
//  GoalProgressViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/23/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

// Observe any changes we make to properties in this view models
class GoalProgressViewModel: ObservableObject, Identifiable {
    
    @Published var goal: Goal
    
    var id = ""
    private var cancellables = Set<AnyCancellable>()
    private let updateGoalUseCase = UseCaseProvider().updateGoalUseCase
        
    init(goal: Goal) {
        self.goal = goal
        
        $goal
            .compactMap { goal in
                goal.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $goal
            .dropFirst()
            .debounce(for: 0.3, scheduler: RunLoop.main)
            .sink { [weak self] goal in
                self?.updateGoalUseCase.execute(request: goal) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print("Error updating goal: \(error.localizedDescription)")
                    }
                }
        }
        .store(in: &cancellables)
    }
    
    func increment() {
        goal.timesThisWeek += 1
    }
    
    func reset() {
        goal.timesThisWeek = 0
    }
        
    func progress() -> Double {
        if goal.timesThisWeek <= 0 {
            return 0.0
        }
        
        return Double(goal.timesThisWeek) / Double(goal.timesPerWeek)
    }
}

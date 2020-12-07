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
    private let incrementGoalTimesThisWeekUseCase = UseCaseProvider().incrementGoalTimesThisWeekUseCase
        
    var completedTodayOrForTheWeek: Bool {
        guard let some: [Date] = goal.completions?.map({ Date(timeIntervalSinceReferenceDate: $0) }) else {
            return false
        }
        
        let completedToday = !some.allSatisfy({ $0.isDateToday() == false })
        let finishedForWeek = goal.timesThisWeek == goal.timesPerWeek
        return completedToday || finishedForWeek
    }
    
    var completedForWeek: Bool {
        return goal.timesThisWeek == goal.timesPerWeek
    }
    
    init(goal: Goal) {
        self.goal = goal
        
        $goal
            .compactMap { goal in
                goal.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
    }
    
    func incrementGoalTimesThisWeek(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let goalId = goal.id else {
            completion(.failure(InputError.nilGoalId))
            return
        }
        
        incrementGoalTimesThisWeekUseCase.execute(request: goalId) { result in
            completion(result)
        }
    }
        
    func progress() -> Double {
        if goal.timesThisWeek <= 0 {
            return 0.0
        }
        
        if goal.timesPerWeek == 0 {
            return 0.0
        }
        
        return Double(goal.timesThisWeek) / Double(goal.timesPerWeek)
    }
}

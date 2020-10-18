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
    @Published private var goals = [Goal]()

    private let fetchAllGoalsUseCase = UseCaseProvider().fetchAllGoalsUseCase
    private var cancellables = Set<AnyCancellable>()
    
    var totalProgress: Double {
        let totalTimesThisWeek = goals.map { $0.timesThisWeek }.reduce(0, +)
        let totalTimesPerWeek = goals.map { $0.timesPerWeek }.reduce(0, +)
        
        return totalTimesPerWeek == 0 ? 0 : Double(totalTimesThisWeek)/Double(totalTimesPerWeek)
    }
    
    var hasGoals: Bool {
        return goals.count > 0
    }
    
    init() {
        fetchAllGoals()
    }
    
    init(goals: [Goal]) {
        self.goals = goals
        
        self.$goals
            .map { goals in
                goals.map { goal in
                    GoalProgressViewModel(goal: goal)
                }
        }
        .assign(to: \.goalProgressViewModels, on : self)
        .store(in: &self.cancellables)
    }
    
    private func fetchAllGoals() {
        fetchAllGoalsUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let goals):
                self.goals = goals
                
                self.$goals
                    .map { goals in
                        goals.map { goal in
                            GoalProgressViewModel(goal: goal)
                        }
                }
                .assign(to: \.goalProgressViewModels, on : self)
                .store(in: &self.cancellables)
                
            case .failure(let error):
                fatalError("TODO: Handle error here for fetching goals \(error.localizedDescription)")
            }
        }
    }
}

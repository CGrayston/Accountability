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
    private let fetchTemplateStatusUseCase = UseCaseProvider().fetchTemplateStatusUseCase
    private let createThisWeeksGoalsFromTemplate = UseCaseProvider().createThisWeeksGoalsFromTemplate
    private var cancellables = Set<AnyCancellable>()
    
    var totalProgress: Double {
        let totalTimesThisWeek = goals.map { $0.timesThisWeek }.reduce(0, +)
        let totalTimesPerWeek = goals.map { $0.timesPerWeek }.reduce(0, +)
        
        return totalTimesPerWeek == 0 ? 0 : Double(totalTimesThisWeek)/Double(totalTimesPerWeek)
    }
    
    var fetchTemplateStatus: ((Result<TemplateStatus, Error>) -> Void) = { _ in }
        
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
    
    func fetchAllGoals() {
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
                
                if goals.count == 0 {
                    self.fetchTemplateStatusUseCase.execute { result in
                        self.fetchTemplateStatus(result)
                    }
                }
            case .failure(let error):
                fatalError(error.localizedDescription)
            }
        }
    }
    
    func createThisWeeksGoalsFromTemplate(completion: @escaping (Result<Void, Error>) -> Void) {
        createThisWeeksGoalsFromTemplate.execute { result in
            completion(result)
        }
    }
}

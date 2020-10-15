//
//  TaskCellViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/3/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

// Observe any changes we make to properties in this view models
class TaskCellViewModel: ObservableObject, Identifiable {
    
    @Published var task: Task
    @Published var completionStateIconName = ""
    
    var id = ""
    private var cancellables = Set<AnyCancellable>()
    private let updateTaskUseCase = UseCaseProvider().updateTaskUseCase
    
    init(task: Task) {
        self.task = task
        
        $task
            .map { task in
                task.completed ? "checkmark.circle.fill" : "circle"
        }
        .assign(to: \.completionStateIconName, on: self)
        .store(in: &cancellables)
        
        $task
            .compactMap { task in
                task.id
        }
        .assign(to: \.id, on: self)
        .store(in: &cancellables)
        
        $task
            .dropFirst()
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .sink { [weak self] task in
                self?.updateTaskUseCase.execute(request: task) { result in
                    switch result {
                    case .success(_):
                        break
                    case .failure(let error):
                        print("Error updating task: \(error.localizedDescription)")
                    }
                }
        }
        .store(in: &cancellables)
    }
}

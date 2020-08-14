//
//  TaskListViewModel.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/5/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import Foundation
import Combine

class TaskListViewModel: ObservableObject {
    @Published var taskRepository = TaskRepository()
    @Published var taskCellViewModels = [TaskCellViewModel]()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        taskRepository.$tasks
            .map { tasks in
                tasks.map { task in
                    TaskCellViewModel(task: task)
                }
        }
        .assign(to: \.taskCellViewModels, on : self)
        .store(in: &cancellables)
    }
    
    func addTask(task: Task) {
        taskRepository.addTask(task)
    }
}

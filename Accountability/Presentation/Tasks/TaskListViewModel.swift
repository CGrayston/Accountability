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

    @Published var taskCellViewModels = [TaskCellViewModel]()
    @Published var tasks = [Task]()

    private let fetchAllTasksUseCase = UseCaseProvider().fetchAllTasksUseCase
    private let addTaskUseCase = UseCaseProvider().addTaskUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchAllTasks()
    }
    
    fileprivate func fetchAllTasks() {
        
        fetchAllTasksUseCase.execute { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let tasks):
                self.tasks = tasks
                
                self.$tasks
                    .map { tasks in
                        tasks.map { task in
                            TaskCellViewModel(task: task)
                        }
                }
                .assign(to: \.taskCellViewModels, on : self)
                .store(in: &self.cancellables)
                
            case .failure(let error):
                fatalError("TODO: Handle error here for fetching tasks \(error.localizedDescription)")
            }
        }
    }
    
    func addTask(task: Task) {
        addTaskUseCase.execute(request: task) { result in
            switch result {
            case .success(_):
                print("success")
                break
                
            case .failure(let error):
                fatalError("TODO: Handle error here for adding task \(error.localizedDescription)")
            }
        }
    }
}

//
//  ContentView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/3/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI
import Firebase

struct TaskListView: View {
    
    @ObservedObject var taskListVM = TaskListViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    @State var presentAddNewItem = false
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                VStack(alignment: .leading) {
                    List {
                        ForEach(taskListVM.taskCellViewModels) { taskCellVM in
                            TaskCell(taskCellVM: taskCellVM)
                        }
                        if presentAddNewItem {
                            TaskCell(taskCellVM: TaskCellViewModel(task: Task(title: "", completed: false))) { task in
                                self.taskListVM.addTask(task: task)
                                self.presentAddNewItem.toggle()
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    
                    Button(action: { self.presentAddNewItem.toggle() }) {
                        ZStack {
                            Circle().fill()
                                .frame(width: 48, height: 48)
                                .foregroundColor(colorScheme == .light ? .white : .black)

                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .opacity(1.0)
                                .frame(width: 48, height: 48)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 20))
                }
                .navigationBarTitle("Tasks")
                .navigationBarItems(trailing:
                    NavigationLink(destination: SettingsView(), label: {
                        Image("gearshape")
                            .font(.system(size: 24, weight: .regular))
                            .accentColor(.red)
                    })
                )
            }
        }
        .accentColor(.red)
    }
}

struct TaskCell: View {
    @ObservedObject var taskCellVM: TaskCellViewModel
    
    var onCommit: (Task) -> () = { _ in }
    
    var body: some View {
        HStack {
            Image(systemName: taskCellVM.task.completed ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 20, height: 20)
                .onTapGesture {
                    self.taskCellVM.task.completed.toggle()
            }
            TextField("Enter your task title", text: $taskCellVM.task.title, onCommit: {
                self.onCommit(self.taskCellVM.task)
            })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TaskListView().previewDevice("iPhone 11")
    }
}

//
//  GoalEditorView.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/3/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct GoalEditorView: View {
    
    @ObservedObject var viewModel: GoalEditorViewModel
    
    @State private var showingAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var isEditingMode: Bool

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                ZStack(alignment: .bottom) {
                    VStack {
                        let goalProgressVM = GoalProgressViewModel(goal: viewModel.goal)
                        GoalProgressView(goalProgressViewModel: goalProgressVM, isUIEnabled: false)
                            .padding(.top)
                        
                        List {
                            Section(header: Text("Title").font(.body)) {
                                TextField("New Goal Title", text: $viewModel.goal.title)
                            }
                            
//                            Section(header: Text("Title").font(.body)) {
//                                TextField("New Goal Title", text: $viewModel.goal.title)
//                            }
                            
                            Section(header: Text("Times Per Week").font(.body)) {
                                let timesThisWeek = viewModel.goal.timesThisWeek
                                let timesPerWeek = $viewModel.goal.timesPerWeek
                                
                                let lowerBound = isEditingMode ? (timesThisWeek > 1 ? timesThisWeek : 1) : 1
                                let upperBound = 50
                                
                                Stepper(value: timesPerWeek, in: lowerBound...upperBound) {
                                    
                                    Label("\(timesPerWeek.wrappedValue) \(timesPerWeek.wrappedValue == 1 ? "time" : "times") per week", systemImage: "circle.dashed")
                                }
                                
                                if isEditingMode {
                                    Button(action: {
                                        if timesThisWeek > 0 {
                                            viewModel.goal.timesThisWeek -= 1
                                        } else {
                                            let generator = UINotificationFeedbackGenerator()
                                            generator.notificationOccurred(.error)
                                        }
                                    }) {
                                        Label("Decrement", systemImage: "arrow.uturn.backward")
                                    }
                                }
                            }
                            
                            if isEditingMode {
                                Section(header: Text("Delete").font(.body)) {
                                    Button(action: {
                                        viewModel.deleteCurrentGoal { result in
                                            switch result {
                                            case .success:
                                                presentationMode.wrappedValue.dismiss()
                                            case .failure(_):
                                                showingAlert = true
                                            }
                                        }
                                    }) {
                                        Label("Delete Goal", systemImage: "trash")
                                    }
                                }
                            }
                        }
                        Spacer()
                    }
                    
                    // Save Button
                    Button(action: {
                        if isEditingMode {
                            viewModel.updateCurrentGoal { result in
                                switch result {
                                case .success:
                                    presentationMode.wrappedValue.dismiss()
                                case .failure(_):
                                    showingAlert = true
                                }
                            }
                        } else {
                            viewModel.addNewGoal { result in
                                switch result {
                                case .success:
                                    presentationMode.wrappedValue.dismiss()
                                case .failure(_):
                                    showingAlert = true
                                }
                            }
                        }
                    }) {
                        Text("Save")
                            .fontWeight(.heavy)
                            .frame(width: geometry.size.width * 0.8, height: 30, alignment: .center)
                            .padding(8)
                            .foregroundColor(Color.white)
                            .background(Color.secondary)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("\(viewModel.alertTitle ?? "Error")"), message: Text("\(viewModel.alertMessage ?? "Something went wrong")"), dismissButton: .default(Text("Okay")))
                    }
                }
                .navigationBarTitle(isEditingMode ? "Edit Goal" : "Add New Goal", displayMode: .inline)
            }
        }
    }
}

struct GoalEditorView_Previews: PreviewProvider {
    static var previews: some View {
        let goal = Goal(id: "111", title: "Workout Mock Title", timesThisWeek: 0, timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), userId: "1111")
        let goalEditorVM = GoalEditorViewModel(goal: goal)
        GoalEditorView(viewModel: goalEditorVM, isEditingMode: true)
    }
}

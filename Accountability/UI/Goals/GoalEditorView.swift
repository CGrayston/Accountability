//
//  GoalEditorView.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/3/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

enum GoalEditorActiveAlert {
    case blankTitle
    case duplicatePassword
    case deletingGoal
    case decrementTimesThisWeek
    case generic
}

struct GoalEditorView: View {
    
    @ObservedObject var viewModel: GoalEditorViewModel
    
    @State private var showingAlert = false
    @State private var activeAlert: GoalEditorActiveAlert = .generic

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
                            // Title
                            Section(header: Text("Title").font(.body)) {
                                TextField("New Goal Title", text: $viewModel.goal.title)
                            }
                            
                            // Times Per Week
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
                                        guard timesThisWeek > 0 else {
                                            let generator = UINotificationFeedbackGenerator()
                                            generator.notificationOccurred(.error)
                                            return
                                        }
                                        
                                        activeAlert = .decrementTimesThisWeek
                                        showingAlert = true
                                    }) {
                                        Label("Decrement", systemImage: "arrow.uturn.backward")
                                    }
                                    .disabled(timesThisWeek == 0)
                                }
                            }
                            
                            // Delete
                            if isEditingMode {
                                Section(header: Text("Delete").font(.body)) {
                                    Button(action: {
                                        activeAlert = .deletingGoal
                                        showingAlert = true
                                    }) {
                                        Label("Delete Goal", systemImage: "trash")
                                    }
                                }
                            }
                            

                        }
                        //Spacer()
                    }
                    
                    // Save/Update Button
                    Button(action: {
                        if isEditingMode {
                            handleUpdateCurrentGoal()
                        } else {
                            handleAddNewGoal()
                        }
                    }) {
                        Text(isEditingMode ? "Update" : "Save")
                            .fontWeight(.heavy)
                            .frame(width: geometry.size.width * 0.8, height: 30, alignment: .center)
                            .padding(8)
                            .foregroundColor(Color.white)
                            .background(Color.secondary)
                            .cornerRadius(8)
                    }
                }
                .navigationBarTitle(isEditingMode ? "Edit Goal" : "Add New Goal", displayMode: .inline)
                .alert(isPresented: $showingAlert) {
                    var title = ""
                    var message = ""
                    var cancelButton: Alert.Button?
                    var confirmButton: Alert.Button?
                    
                    switch activeAlert {
                    case .blankTitle:
                        title = "Blank Title"
                        message = "Please enter a title for your goal."
                    case .duplicatePassword:
                        title = "Duplicate Goal Title"
                        message = "Title is already in use. Please enter a unique title for your goal."
                    case .generic:
                        title = "Oops!"
                        message = "Something went wrong, please try again."
                    case .deletingGoal:
                        title = "Delete Goal?"
                        message = "Deleting this goal is permanent and can't be undone. Are you sure you want to continue?"
                        
                        cancelButton = Alert.Button.default(Text("Cancel"))
                        confirmButton = Alert.Button.destructive(Text("Delete")) {
                            handleDeleteCurrentGoal()
                        }
                    case .decrementTimesThisWeek:
                        title = "Decrement Progress?"
                        message = "Are you sure you want to decrement your progress this week?"
                        
                        cancelButton = Alert.Button.default(Text("Cancel"))
                        confirmButton = Alert.Button.destructive(Text("Decrement")) {
                            handleDecrementGoalTimesThisWeek()
                        }
                    }
                    
                    let alertTitle = Text(title)
                    let alertMessage = Text(message)
                    
                    if let cancelButton = cancelButton,
                       let confirmButton = confirmButton {
                        return Alert(title: alertTitle, message: alertMessage, primaryButton: cancelButton, secondaryButton: confirmButton)
                    } else {
                        return Alert(title: alertTitle, message: alertMessage)
                    }
                }
            }
        }
    }
    
    private func handleUpdateCurrentGoal() {
        viewModel.updateCurrentGoal { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                if case UserDataError.duplicateGoalTitle = error {
                    activeAlert = .duplicatePassword
                } else if case InputError.blankTitle = error {
                    activeAlert = .blankTitle
                } else {
                    activeAlert = .generic
                }
                showingAlert = true
            }
        }
    }
    
    private func handleAddNewGoal() {
        viewModel.addNewGoal { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                if case UserDataError.duplicateGoalTitle = error {
                    activeAlert = .duplicatePassword
                } else if case InputError.blankTitle = error {
                    activeAlert = .blankTitle
                } else {
                    activeAlert = .generic
                }
                showingAlert = true
            }
        }
    }
    
    private func handleDecrementGoalTimesThisWeek() {
        let generator = UINotificationFeedbackGenerator()

        viewModel.decrementGoalTimesThisWeek { result in
            switch result {
            case .success:
                generator.notificationOccurred(.success)
            case .failure:
                // TODO: Figure out how to send back to back alerts if there was another error
                generator.notificationOccurred(.warning)
                activeAlert = .generic
                showingAlert = true
            }
        }
    }
    
    private func handleDeleteCurrentGoal() {
        viewModel.deleteCurrentGoal { result in
            switch result {
            case .success:
                presentationMode.wrappedValue.dismiss()
            case .failure(let error):
                // TODO: Figure out how to send back to back alerts if there was another error
                print("Error trying to delete goal: \(error.localizedDescription)")
                return
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

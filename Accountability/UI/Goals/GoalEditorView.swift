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
    case decrementTimesThisWeek(completionTimeInterval: TimeInterval)
    case generic
}

struct GoalEditorView: View {
    
    @ObservedObject var viewModel: GoalEditorViewModel
    
    @State private var showingAlert = false
    @State private var activeAlert: GoalEditorActiveAlert = .generic
    @State private var goalsCompletedExpanded = true

    @Environment(\.presentationMode) var presentationMode
    
    var isEditingMode: Bool

    var body: some View {
        GeometryReader { geometry in
            NavigationView {
                VStack {
                    let goalProgressVM = GoalProgressViewModel(goal: viewModel.goal)
                    GoalProgressView(goalProgressViewModel: goalProgressVM, showingEditingMode: .constant(false), isUIEnabled: false)
                        .padding(.top).padding(.top)
                    
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
                                    .accentColor(.red)
                            }
                            
                            if isEditingMode {
                                
                            }
                        }
                        
                        // Times This Week
                        if let completions = viewModel.goal.completions,
                           completions.isEmpty == false,
                           isEditingMode {
                            Section(header: Text("Times This Week").font(.body)) {
                                DisclosureGroup("Goals Completed This Week", isExpanded: $goalsCompletedExpanded) {
                                    ForEach(completions, id: \.self) { completion in
                                        let date = Date(timeIntervalSinceReferenceDate: completion)
                                        Text("\(date.fullTimeShortFormatter())")
                                    }
                                    .onDelete(perform: { indexSet in
                                        if let first = indexSet.first {
                                            let completion = completions[first]
                                            removeCompletion(completion: completion)
                                        }
                                    })
                                }
                                
                                Button(action: {
                                    if let lastCompletion = completions.last {
                                        activeAlert = .decrementTimesThisWeek(completionTimeInterval: lastCompletion)
                                        showingAlert = true
                                    }
                                }) {
                                    Label("Decrement Last Completion", systemImage: "arrow.uturn.backward")
                                        .accentColor(.red)
                                }
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
                                        .accentColor(.red)
                                }
                            }
                        }
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
                    .background(Color.background)
                }
                .ignoresSafeArea(.keyboard)
                .navigationBarTitle(isEditingMode ? "Edit Goal" : "Add New Goal", displayMode: .inline)
                .navigationBarItems(
                    leading:
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.red)
                        })
                )
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
                    case .decrementTimesThisWeek(let dateToDelete):
                        title = "Decrement Progress?"
                        message = "Are you sure you want to remove your last completed goal this week?"
                        
                        cancelButton = Alert.Button.default(Text("Cancel"))
                        confirmButton = Alert.Button.destructive(Text("Remove")) {
                            removeCompletion(completion: dateToDelete)
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
    
    private func removeCompletion(completion: TimeInterval) {
        let generator = UINotificationFeedbackGenerator()
        
        viewModel.decrementGoalTimesThisWeek(completionDate: completion) { result in
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
        let goal = Goal(id: "111", title: "Workout Mock Title", timesThisWeek: 0, timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), completions: [601887343.438227, 628886316.438227, 628387316.438227, 628887386.438227], userId: "1111")
        let goalEditorVM = GoalEditorViewModel(goal: goal)
        GoalEditorView(viewModel: goalEditorVM, isEditingMode: true)
    }
}

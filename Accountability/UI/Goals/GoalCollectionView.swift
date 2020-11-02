//
//  GoalCollectionView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/22/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

enum GoalCollectionActiveAlert {
    case goalFTUX
    case noGoals
    case newWeek
    case generic
    case customError(errorMessage: String)
}

struct GoalCollectionView: View {
    
    @ObservedObject var viewModel = GoalCollectionViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    @State private var showingAlert = false
    @State var showingAddGoal = false
    @State private var activeAlert: GoalCollectionActiveAlert = .generic {
        didSet {
            showingAlert = true
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 32) {
                        if viewModel.hasGoals {
                            PersonalGoalsProgressBar(totalProgress: viewModel.totalProgress)
                                .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.06, alignment: .center)
                                .padding(.bottom)
                        }
                        
                        let columns = [GridItem(.adaptive(minimum: 150, maximum: 200))]
                        
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(viewModel.goalProgressViewModels) { goalProgressVM in
                                GoalProgressView(goalProgressViewModel: goalProgressVM)
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: { self.showingAddGoal.toggle() }) {
                        if viewModel.hasGoals == false {
                            Text("Add Goal")
                                .font(.title)
                        }
                        
                        ZStack {
                            Circle().fill()
                                .foregroundColor(colorScheme == .light ? .white : .black)
                            
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .opacity(1.0)
                        }
                        .frame(width: 48, height: 48)
                    }
                    .foregroundColor(.red)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 24, trailing: 20))
                }
                .sheet(isPresented: $showingAddGoal, content: {
                    let goal = Goal(title: "", timesThisWeek: 0, timesPerWeek: 1, weekStart: Date(), weekEnd: Date())
                    let goalEditorViewModel = GoalEditorViewModel(goal: goal)
                    GoalEditorView(viewModel: goalEditorViewModel, isEditingMode: false)
                })
            }
        }
        .alert(isPresented: $showingAlert) {
            var title = ""
            var message = ""
            var primaryButton: Alert.Button?
            var secondaryButton: Alert.Button?
            var dismissButton: Alert.Button?
            
            switch activeAlert {
            case .generic:
                title = "Oops!"
                message = "Something went wrong, please try again."
                
            case.customError(errorMessage: let errorMessage):
                title = "Error"
                message = "Something went wrong, please try again because of error: \(errorMessage)"
                
            case .newWeek:
                title = "New Week"
                message = "It's a new week so your goals have been reset. Keep up the good work!"

                dismissButton = Alert.Button.default(Text("Let's go")) {
                    createThisWeeksGoalsFromTemplate()
                }
                
                // TODO: Version 2.0 - Alert with Edit Goals and Save Goals
//                primaryButton = Alert.Button.default(Text("Same Goals")) {
//                    // TODO: CreateGoalsFromTemplateUseCase
//                }
//                secondaryButton = Alert.Button.destructive(Text("Edit Goals")) {
//                    // TODO: Navigate to EditGoalTemplateView
//                }
            
            case .goalFTUX:
                title = "Welcome!"
                message = "Create a goal and start tracking. \nOnce you create a goal, long press to increment goal progress and single tap to enter goal editor."
                
                primaryButton = Alert.Button.default(Text("Cancel"))
                secondaryButton = Alert.Button.default(Text("Ok")) {
                    // TODO: Go to primary goals view
                    showingAlert = false
                    showingAddGoal = true
                }
                
            case .noGoals:
                title = "No Goals Yet"
                message = "Create a goal and start tracking!"
                
                primaryButton = Alert.Button.default(Text("Cancel"))
                secondaryButton = Alert.Button.default(Text("Ok")) {
                    // TODO: Go to primary goals view
                    showingAlert = false
                    showingAddGoal = true
                }
            }
            
            let alertTitle = Text(title)
            let alertMessage = Text(message)
            
            if let primaryButton = primaryButton,
               let secondaryButton = secondaryButton {
                return Alert(title: alertTitle, message: alertMessage, primaryButton: primaryButton, secondaryButton: secondaryButton)
            } else if let dismissButton = dismissButton {
                return Alert(title: alertTitle, message: alertMessage, dismissButton: dismissButton)
            } else {
                return Alert(title: alertTitle, message: alertMessage)
            }
        }
        .onAppear {
            if !viewModel.hasGoals {
                checkTemplateStatusForAlert()
            }
        }
    }
    
    func createThisWeeksGoalsFromTemplate() {
        viewModel.createThisWeeksGoalsFromTemplate { result in
            switch result {
            case .success:
                showingAlert = false
            case .failure(_):
                activeAlert = .generic
            }
        }
    }
    
    func checkTemplateStatusForAlert() {
        viewModel.fetchTemplateStatus { result in
            switch result {
            case .success(let templateStatus):
                switch templateStatus {
                case .nilTemplate:
                    activeAlert = .goalFTUX
                case .emptyTemplate:
                    activeAlert = .noGoals
                case .hasTemplate:
                    activeAlert = .newWeek
                }
            case .failure(let error):
                activeAlert = .customError(errorMessage: error.localizedDescription)
            }
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let goals: [Goal] = [
            Goal(id: "111", title: "Drink Water", timesThisWeek: 5, timesPerWeek: 7, weekStart: Date(), weekEnd: Date(), userId: "1111"),
            Goal(id: "222", title: "Outdoor 45 Minute Workout", timesThisWeek: 0, timesPerWeek: 4, weekStart: Date(), weekEnd: Date(), userId: "2222"),
            Goal(id: "333", title: "Eat Healthy Meal", timesThisWeek: 2, timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), userId: "3333"),
            Goal(id: "444", title: "Drink Water", timesThisWeek: 5, timesPerWeek: 7, weekStart: Date(), weekEnd: Date(), userId: "1111"),
            Goal(id: "555", title: "Outdoor 45 Minute Workout", timesThisWeek: 0, timesPerWeek: 4, weekStart: Date(), weekEnd: Date(), userId: "2222"),
            Goal(id: "666", title: "Eat Healthy Meal", timesThisWeek: 5, timesPerWeek: 8, weekStart: Date(), weekEnd: Date(), userId: "3333"),
            Goal(id: "777", title: "Eat Healthy Meal", timesThisWeek: 5, timesPerWeek: 8, weekStart: Date(), weekEnd: Date(), userId: "3333"),
        ]
        
        let viewModel = GoalCollectionViewModel(goals: goals)
        GoalCollectionView(viewModel: viewModel)
    }
}

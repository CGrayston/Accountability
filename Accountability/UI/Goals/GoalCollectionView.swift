//
//  GoalCollectionView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/22/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct GoalCollectionView: View {
    
    @ObservedObject var viewModel = GoalCollectionViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State var showingAddGoal = false
        
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

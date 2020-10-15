//
//  GoalCollectionView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/22/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct GoalCollectionView: View {
    
    @ObservedObject var goalCollectionVM = GoalCollectionViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State var showingAddGoal = false
        
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .bottom) {
                ScrollView {
                    VStack(spacing: 32) {
                        
                        PersonalGoalsProgressBar(totalProgress: goalCollectionVM.totalProgress)
                            .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.06, alignment: .center)
                            .padding(.bottom)
                        
                        let columns = [GridItem(.adaptive(minimum: 150, maximum: 200))]
                        
                        LazyVGrid(columns: columns, spacing: 40) {
                            ForEach(goalCollectionVM.goalProgressViewModels) { goalProgressVM in
                                GoalProgressView(goalProgressViewModel: goalProgressVM)
                            }
                        }
                    }
                }
                
                HStack {
                    Spacer()
                    Button(action: { self.showingAddGoal.toggle() }) {
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
                .sheet(isPresented: $showingAddGoal, content: {
                    let goal = Goal(title: "", timesThisWeek: 0, timesPerWeek: 1, weekStart: Date(), weekEnd: Date())
                    let goalEditorViewModel = GoalEditorViewModel(goal: goal)
                    GoalEditorView(viewModel: goalEditorViewModel, isEditingMode: false)
                })
            }
            
            //            .frame(width: geometry.size.width, height: geometry.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
    }
}

// MARK: - GoalProgressView

struct GoalProgressView: View {
    
    @ObservedObject var goalProgressViewModel: GoalProgressViewModel
    
    @State var showingGoalEditor = false

    var isUIEnabled = true
    
    private let strokeWidth: CGFloat = 30.0
    
    private var circleColor: Color {
        Color.greenRedProgress(progress: goalProgressViewModel.progress())
    }
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: strokeWidth)
                    .opacity(0.5)
                    .foregroundColor(Color.red)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(min(goalProgressViewModel.progress(), 1.0)))
                    .stroke(style: StrokeStyle(lineWidth: strokeWidth, lineCap: .round, lineJoin: .round))
                    .foregroundColor(circleColor)
                    .rotationEffect(Angle(degrees: 270.0))
                
                VStack {
                    Text(String(format: "%.0f%%", min(goalProgressViewModel.progress(), 1.0)*100.0))
                        .font(.largeTitle)
                        .bold()
                    Text("\(goalProgressViewModel.goal.timesThisWeek) of \(goalProgressViewModel.goal.timesPerWeek)")
                        .foregroundColor(.gray)
                }
                .animation(.none)
            }
            .frame(width: 150, height: 150, alignment: .center)
            .contentShape(Circle())
            // FIXME: Use .easeInOut(duration: 0.9) when Apple bug is fixed
            .animation(.default)
            .onTapGesture {
                guard isUIEnabled else { return }
                showingGoalEditor.toggle()
            }
            .onLongPressGesture {
                guard isUIEnabled else { return }

                let generator = UINotificationFeedbackGenerator()

                if goalProgressViewModel.progress() >= 1 {
                    generator.notificationOccurred(.error)
                } else {
                    generator.notificationOccurred(.success)
                    goalProgressViewModel.increment()
                }
            }
            .sheet(isPresented: $showingGoalEditor, content: {
                let goal = goalProgressViewModel.goal
                let goalEditorViewModel = GoalEditorViewModel(goal: goal)
                GoalEditorView(viewModel: goalEditorViewModel, isEditingMode: true)

            })
            
            Text(goalProgressViewModel.goal.title.capitalized)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding([.top, .leading, .trailing])
                .frame(height: 70, alignment: .top)
        }
    }
}

struct GoalsView_Previews: PreviewProvider {
    static var previews: some View {
        let goals = [
            Goal(id: "111", title: "Drink Water", timesThisWeek: 5, timesPerWeek: 7, weekStart: Date(), weekEnd: Date(), userId: "1111"),
            Goal(id: "222", title: "Outdoor 45 Minute Workout", timesThisWeek: 0, timesPerWeek: 4, weekStart: Date(), weekEnd: Date(), userId: "2222"),
            Goal(id: "333", title: "Eat Healthy Meal", timesThisWeek: 2, timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), userId: "3333"),
            Goal(id: "444", title: "Drink Water", timesThisWeek: 5, timesPerWeek: 7, weekStart: Date(), weekEnd: Date(), userId: "1111"),
            Goal(id: "555", title: "Outdoor 45 Minute Workout", timesThisWeek: 0, timesPerWeek: 4, weekStart: Date(), weekEnd: Date(), userId: "2222"),
            Goal(id: "666", title: "Eat Healthy Meal", timesThisWeek: 5, timesPerWeek: 8, weekStart: Date(), weekEnd: Date(), userId: "3333"),
            Goal(id: "777", title: "Eat Healthy Meal", timesThisWeek: 5, timesPerWeek: 8, weekStart: Date(), weekEnd: Date(), userId: "3333"),
        ]
        
        let viewModel = GoalCollectionViewModel(goals: goals)
        GoalCollectionView(goalCollectionVM: viewModel)
    }
}

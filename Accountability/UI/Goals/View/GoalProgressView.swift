//
//  GoalProgressView.swift
//  Accountability
//
//  Created by Christopher Grayston on 10/17/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct GoalProgressView: View {
    
    @ObservedObject var goalProgressViewModel: GoalProgressViewModel
    
    @State var showingGoalEditor = false

    @Binding var showingEditingMode: Bool
    
    var isUIEnabled = true
    
    private let strokeWidth: CGFloat = 30.0
    
    private var circleColor: Color {
        Color.greenRedProgress(progress: goalProgressViewModel.progress())
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                ZStack {
                    Circle()
                        .stroke(lineWidth: strokeWidth)
                        .opacity(0.5)
                        .foregroundColor(.barBackground)
                    
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
                .onLongPressGesture {
                    guard isUIEnabled else { return }
                    
                    let generator = UINotificationFeedbackGenerator()
                    
                    if goalProgressViewModel.progress() >= 1 ||
                        showingEditingMode {
                        generator.notificationOccurred(.error)
                    } else {
                        goalProgressViewModel.incrementGoalTimesThisWeek { result in
                            switch result {
                            case .success:
                                generator.notificationOccurred(.success)
                            case .failure(let error):
                                generator.notificationOccurred(.error)
                                print("TODO: Add error alert here \(error.localizedDescription)")
                            }
                        }
                    }
                }
                .sheet(isPresented: $showingGoalEditor, content: {
                    let goal = goalProgressViewModel.goal
                    let goalEditorViewModel = GoalEditorViewModel(goal: goal)
                    GoalEditorView(viewModel: goalEditorViewModel, isEditingMode: true)
                })
                
                // Editing Bubble
                if showingEditingMode {
                    ZStack {
                        Circle().fill()
                            .foregroundColor(.background)
                            
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .opacity(1.0)
                            .foregroundColor(.gray)
                    }
                    .frame(width: 48, height: 48)
                    .offset(x: 7, y: 7)
                    .onTapGesture {
                        guard isUIEnabled, showingEditingMode else { return }
                        showingGoalEditor.toggle()
                    }
                }
            }
            
            Text(goalProgressViewModel.goal.title)
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding([.top, .leading, .trailing])
                .frame(height: 60, alignment: .top)
        }
    }
}


struct GoalProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let goal = Goal(id: "111", title: "Workout Mock Title", timesThisWeek: 0, timesPerWeek: 5, weekStart: Date(), weekEnd: Date(), userId: "1111")
        let viewModel = GoalProgressViewModel(goal: goal)
        GoalProgressView(goalProgressViewModel: viewModel, showingEditingMode: .constant(true))
    }
}

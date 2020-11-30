//
//  TabBarView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/11/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    
    @EnvironmentObject var appState: AppState
    @State var selectedView = 0
    
    private let tabFont: Font = .system(size: 24, weight: .regular)
    
    var body: some View {
        
        TabView(selection: $selectedView) {
            // Goals tab
            let goals = appState.goals
            let goalCollectionViewModel = GoalCollectionViewModel(goals: goals)
            GoalCollectionView(viewModel: goalCollectionViewModel)
                .tabItem {
                    Image(systemName: "bolt.circle.fill")
                        .font(tabFont)
                }.tag(0)
            
            // Tasks tab
            TaskListView()
                .tabItem {
                    Image(systemName: "checkmark.circle.fill")
                        .font(tabFont)
            }.tag(1)
            
            // Journal tab
            EntryListView()
                .tabItem {
                    Image(systemName: "book.fill")
                        .font(tabFont)
            }.tag(3)
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .systemGray
        }
        .accentColor(.red)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

//
//  TabBarView.swift
//  Accountability
//
//  Created by Christopher Grayston on 8/11/20.
//  Copyright © 2020 Christopher Grayston. All rights reserved.
//

import SwiftUI

struct TabBarView: View {
    
    private let tabFont: Font = .system(size: 24, weight: .regular)
    
    @State var selectedView = 0
    
    var body: some View {
        
        TabView(selection: $selectedView) {
            // Goals tab
            GoalCollectionView()
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

            // Group Chat tab
//            Text("TODO: Group Chat")
//                .tabItem {
//                    Image(systemName: "bubble.middle.bottom.fill")
//                        .font(tabFont)
//            }.tag(2)
            
            // Journal tab
            EntryListView()
                .tabItem {
                    Image(systemName: "book.fill")
                        .font(tabFont)
            }.tag(3)
        }
        .accentColor(.red)
    }
}

struct TabBarView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarView()
    }
}

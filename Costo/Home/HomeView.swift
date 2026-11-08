//
//  HomeView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/20.
//

import SwiftUI

struct HomeView: View {
    @State private var selection: TabType = .stockList
    @Environment(\.editMode) private var editMode
    
    var body: some View {
        TabView(selection: $selection) {
            Group {
                StockListView()
                    .tabItem {
                        Label(TabType.stockList.title, systemImage: TabType.stockList.imageName)
                    }
                    .tag(TabType.stockList)
                CookingView()
                    .tabItem {
                        Label(TabType.cooking.title, systemImage: TabType.cooking.imageName)
                    }
                    .tag(TabType.cooking)
                TrashListView()
                    .tabItem {
                        Label(TabType.trashList.title, systemImage: TabType.trashList.imageName)
                    }
                    .tag(TabType.trashList)
                HistoryView()
                    .tabItem {
                        Label(TabType.history.title, systemImage: TabType.history.imageName)
                    }
                    .tag(TabType.history)
            }
            .toolbarBackground(.white, for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
        }
        .accentColor(.black)
        .onAppear {
            UITabBar.appearance().unselectedItemTintColor = .lightGray
        }
        .onChange(of: selection) { _, _ in
            editMode?.wrappedValue = .inactive
        }
    }
}

#Preview {
    HomeView()
}

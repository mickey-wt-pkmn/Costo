//
//  HistoryView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftUI
import SwiftData

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    @State private var selectedHistoryInfo: HistoryInfo?
    @Query(sort: \History.createdAt, order: .reverse)
    private var histories: [History]
    
    // @Model を getメソッドで常に参照することが重要
    // こうすることで [Grocery] が更新された際に view の値も更新される
    private var historyList: [HistoryInfo] {
        let infoList = histories.map { HistoryInfo(history: $0) }
        return infoList
    }
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Image(systemName: TabType.history.imageName)
                        .font(.title)
                }
                ForEach(historyList) { info in
                    HStack {
                        Text(info.displayModel.historyId)
                        Text(info.displayModel.allCost)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedHistoryInfo = info
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(historyList[index].history)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(TabType.history.title)
            .animation(.none, value: editMode?.wrappedValue)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, editMode)
            .toolbarBackground(.white, for: .navigationBar)
            .sheet(item: $selectedHistoryInfo) { info in
                HistoryDetailView(historyInfo: info)
            }
        }
    }
}

#Preview {
    return HistoryView()
        .modelContainer(PreviewSampleData.historyContainer)
}

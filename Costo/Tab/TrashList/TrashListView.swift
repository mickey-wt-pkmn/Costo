//
//  TrashListView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/21.
//

import SwiftUI
import SwiftData

struct TrashListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    @Query(filter: #Predicate<Grocery> { $0.inTrash })
    private var groceries: [Grocery]
    
    // @Model を getメソッドで常に参照することが重要
    // こうすることで [Grocery] が更新された際に view の値も更新される
    private var groceryList: [GroceryInfo] {
        let infoList = groceries.map { GroceryInfo(grocery: $0) }
        return infoList
    }
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Image(systemName: TabType.trashList.imageName)
                        .font(.title)
                }
                ForEach(groceryList) { info in
                    NavigationLink {
                        StockDetailView(info: info, viewType: .trash)
                    } label: {
                        HStack {
                            Text(info.displayModel.name)
                            Spacer()
                            Text(info.displayModel.remainingAmount)
                        }
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        modelContext.delete(groceryList[index].grocery)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(TabType.trashList.title)
            .animation(.none, value: editMode?.wrappedValue)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, editMode)
            .toolbarBackground(.white, for: .navigationBar)
        }
    }
}

#Preview {
    TrashListView()
        .modelContainer(PreviewSampleData.groceryContainer)
}

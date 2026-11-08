//
//  StockListView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/21.
//

import SwiftUI
import SwiftData

struct StockListView: View {
    
    @State private var showingAddView = false
    @Query(filter: #Predicate<Grocery> { !$0.inTrash })
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
                    Image(systemName: TabType.stockList.imageName)
                        .font(.title)
                }
                ForEach(groceryList) { info in
                    NavigationLink {
                        StockDetailView(info: info, viewType: .list)
                    } label: {
                        HStack {
                            Text(info.displayModel.name)
                            Spacer()
                            Text(info.displayModel.remainingAmount)
                        }
                        .foregroundStyle(info.grocery.remainingAmount > 0 ? .black : .red)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(TabType.stockList.title)
            .toolbar {
                Button {
                    showingAddView = true
                } label: {
                    Image(systemName: "plus.circle")
                }
            }
            .toolbarBackground(.white, for: .navigationBar)
            .sheet(
                isPresented: $showingAddView,
                content: {
                    EditStockView(viewType: .add)
                }
            )
        }
    }
}

#Preview {
    StockListView()
        .modelContainer(PreviewSampleData.groceryContainer)
}

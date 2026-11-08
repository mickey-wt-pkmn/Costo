//
//  IngredientListView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftUI
import SwiftData

struct IngredientListView: View {
    private let ingredientInfo: IngredientInfo
    
    @State private var addModel: IngredientInfo.IngredientModel?
    @Binding private var path: NavigationPath
    @Binding private var useIngredientList: [UseIngredientModel]
    
    init(groceries: [Grocery], useIngredientList: Binding<[UseIngredientModel]>, navigationPath: Binding<NavigationPath>) {
        let availableModelList = groceries.filter { $0.remainingAmount > 0 }
            .map { IngredientInfo.IngredientModel.convertToModel($0, useAmount: 0) }
        self.ingredientInfo = IngredientInfo(modelList: availableModelList)
        self._path = navigationPath
        self._useIngredientList = useIngredientList
    }
    
    var body: some View {
        List {
            VStack {
                Image(systemName: TabType.stockList.imageName)
                    .font(.title)
            }
            ForEach(ingredientInfo.modelList) { model in
                HStack {
                    Text(model.displayModel.name)
                    Spacer()
                    Text(model.displayModel.availableAmount)
                    Image(systemName: "arrow.up.bin")
                }
                .foregroundStyle(model.valueModel.availableAmount > 0 ? .black : .red)
                .contentShape(Rectangle())
                .allowsHitTesting(model.valueModel.availableAmount > 0)
                .onTapGesture {
                    addModel = model
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle(TabType.stockList.title)
        .sheet(item: $addModel) { model in
            EditIngredientView(
                ingredientModel: model,
                useIngredientList: $useIngredientList,
                viewType: .add,
                navigationPath: $path)
        }
    }
}

#Preview {
    IngredientListView(
        groceries: PreviewSampleData.list,
        useIngredientList: .constant([]),
        navigationPath: .constant(.init()))
}

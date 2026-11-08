//
//  CookingView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/21.
//

import SwiftUI
import SwiftData

struct CookingView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.editMode) private var editMode
    
    @State private var path: NavigationPath = .init()
    @State private var viewModel = CookingViewModel()
    @Query(filter: #Predicate<Grocery> { !$0.inTrash })
    private var groceries: [Grocery]
    private var ingredientInfo: IngredientInfo {
        let modelList: [IngredientInfo.IngredientModel] = viewModel.useIngredientList.compactMap { model in
            guard let grocery = groceries.filter({ $0.persistentModelID == model.modelId }).first else {
                return nil
            }
            return .convertToModel(grocery, useAmount: model.useAmount)
        }
        return IngredientInfo(modelList: modelList)
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                VStack {
                    Image(systemName: TabType.cooking.imageName)
                        .font(.title)
                }
                ForEach(ingredientInfo.modelList) { model in
                    VStack(alignment: .leading) {
                        Group {
                            HStack {
                                Text("Name")
                                    .padding(.trailing)
                                Text(model.displayModel.name)
                                    .foregroundStyle(.black)
                            }
                            HStack {
                                Text("UseAmount")
                                    .padding(.trailing)
                                Text(model.displayModel.useAmount)
                                    .foregroundStyle(.black)
                            }
                            HStack {
                                Text("AvailableAmount")
                                    .padding(.trailing)
                                Text(model.displayModel.availableAmount)
                                    .foregroundStyle(.black)
                            }
                            HStack {
                                Text("Cost")
                                    .padding(.trailing)
                                Text(model.displayModel.cost)
                                    .foregroundStyle(.black)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .foregroundStyle(.gray)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.ingredientModel = model
                    }
                }
                .onDelete(perform: deleteItem)
                VStack {
                    if let allCost = ingredientInfo.allCost {
                        HStack {
                            Text("All Cost")
                                .padding(.trailing)
                            Text(allCost)
                                .foregroundStyle(.black)
                        }
                        .font(.title2)
                        Divider()
                    }
                    Button("Add ingredient") {
                        path.append(CookingPathType.ingredientList)
                    }
                    .buttonStyle(.primary(
                        .init(padding: 10, font: .title2, image: Image(systemName: "carrot"))))
                    Spacer()
                        .frame(minHeight: 40)
                }
                .frame(maxWidth: .infinity)
            }
            .overlay(alignment: .bottom) {
                ZStack {
                    Color.white.opacity(0.9)
                        .frame(maxWidth: .infinity, maxHeight: 70)
                    VStack {
                        Button("Cooking") {
                            viewModel.isShowConfirmationDialog = true
                        }
                        .buttonStyle(.primary(.init(foregroundColor: viewModel.isEnableCooking ?  .black : Color(.lightGray), padding: 10, font: .title2, image: Image(systemName: "frying.pan"))))
                        .disabled(!viewModel.isEnableCooking)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .navigationTitle(TabType.cooking.title)
            .animation(.none, value: editMode?.wrappedValue)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
            .environment(\.editMode, editMode)
            .toolbarBackground(.white, for: .navigationBar)
            .navigationDestination(for: CookingPathType.self, destination: { pathType in
                switch pathType {
                case .ingredientList:
                    let modelIds = viewModel.useIngredientList.map { $0.modelId }
                    let availableGroceries: [Grocery] = groceries.filter { !modelIds.contains($0.id) }
                    IngredientListView(groceries: availableGroceries, useIngredientList: $viewModel.useIngredientList, navigationPath: $path)
                        .onDisappear {
                            viewModel.checkEnableCooking()
                        }
                }
            })
            .sheet(item: $viewModel.ingredientModel, content: { model in
                EditIngredientView(ingredientModel: model, useIngredientList: $viewModel.useIngredientList, viewType: .edit, navigationPath: $path)
            })
            .alert("", isPresented: $viewModel.isShowAlert, presenting: viewModel.alertType) { _ in
                Button("OK") {}
            } message: { type in
                switch type {
                case .error(let error):
                    Text(error.localizedDescription)
                case .useSuccess:
                    Text("Success")
                }
            }
            .confirmationDialog("Can I use the ingredients?", isPresented: $viewModel.isShowConfirmationDialog, titleVisibility: .visible) {
                Button("OK") {
                    viewModel.useItem(ingredientInfo, modelContext: modelContext)
                }
            }
        }
    }
    
    private func deleteItem(_ indexSet: IndexSet) {
        for index in indexSet {
            let model = ingredientInfo.modelList[index]
            let removeIdx = viewModel.useIngredientList.enumerated()
                .filter { $0.element.modelId == model.grocery.persistentModelID }
                .first.map { $0.offset }
            guard let removeIdx = removeIdx else {
                continue
            }
            viewModel.useIngredientList.remove(at: removeIdx)
        }
        viewModel.checkEnableCooking()
    }
}

#Preview {
    return CookingView()
        .modelContainer(PreviewSampleData.groceryContainer)
}

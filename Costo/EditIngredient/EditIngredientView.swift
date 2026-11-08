//
//  EditIngredientView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftUI
import SwiftData

struct EditIngredientView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: EditIngredientViewModel
    
    @Binding private var path: NavigationPath
    @Binding private var useIngredientList: [UseIngredientModel]
    
    init(ingredientModel: IngredientInfo.IngredientModel, useIngredientList: Binding<[UseIngredientModel]>, viewType: EditIngredientViewModel.ViewType, navigationPath: Binding<NavigationPath>) {
        self.viewModel = .init(ingredientModel: ingredientModel, viewType: viewType)
        self._path = navigationPath
        self._useIngredientList = useIngredientList
    }
    
    var body: some View {
        NavigationStack {
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Group {
                        HStack {
                            Text("Name")
                                .padding(.trailing)
                            Text(viewModel.ingredientModel.displayModel.name)
                                .foregroundStyle(.black)
                        }
                        HStack {
                            Text("Remaining Amount")
                                .padding(.trailing)
                            Text(viewModel.ingredientModel.displayModel.availableAmount)
                                .foregroundStyle(.black)
                        }
                        VStack {
                            HStack {
                                Text("Use Amount")
                                    .padding(.trailing)
                                TextField("", value: $viewModel.useAmount, format: .number)
                                    .onChange(of: viewModel.useAmount) { old, new in
                                        viewModel.checkValue(.useAmount(old: old, new: new))
                                    }
                                    .keyboardType(.decimalPad)
                                    .foregroundStyle(.black)
                            }
                            if viewModel.ingredientModel.valueModel.unit == .pound {
                                HStack {
                                    Text("Unit")
                                        .padding(.trailing)
                                    Picker("", selection: $viewModel.useUnit) {
                                        ForEach(UnitType.forPound, id: \.self) { unit in
                                            Text(unit.string)
                                                .tag(unit)
                                                .foregroundStyle(.black)
                                        }
                                    }
                                    .onChange(of: viewModel.useUnit) { _, _ in
                                        viewModel.checkValue(.pass)
                                    }
                                    .pickerStyle(.segmented)
                                }
                            }
                            if viewModel.isExceedAmount {
                                Text("exceeds possible amount")
                                    .font(.footnote)
                                    .foregroundStyle(.red)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(.gray)
                    VStack {
                        Divider()
                        Button("OK") {
                            selectItem()
                            if viewModel.viewType == .add {
                                path.removeLast(path.count)
                            }
                            else if viewModel.viewType == .edit {
                                dismiss()
                            }
                        }
                        .buttonStyle(.primary(.init(foregroundColor: viewModel.isEnableSelect ?  .black : Color(.lightGray), padding: 10, font: .title2, image: Image(systemName: "basket"))))
                        .disabled(!viewModel.isEnableSelect)
                    }
                }
                .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.viewType.title)
                        .font(.title)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle")
                            .foregroundStyle(.black)
                    }
                }
            }
        }
        .onAppear {
            viewModel.checkValue(.pass)
        }
    }
    
    private func selectItem() {
        guard let useAmount = viewModel.useAmount else {
            return
        }
        var calcUseAmount = useAmount
        // 登録時は pound で使用時に gram を選択した場合
        if viewModel.ingredientModel.valueModel.unit == .pound && viewModel.useUnit == .gram {
            calcUseAmount = (viewModel.useAmount ?? 0) / UnitType.PoundGram
        }
        // 小数点 3位で切り捨て
        let floorUseAmount = floor(calcUseAmount * 100) / 100
        
        if viewModel.viewType == .add {
            useIngredientList.append(.init(
                modelId: viewModel.ingredientModel.grocery.persistentModelID,
                useAmount: floorUseAmount))
        }
        if viewModel.viewType == .edit {
            guard let ingredient = useIngredientList.filter({ $0.modelId == viewModel.ingredientModel.grocery.persistentModelID }).first else {
                return
            }
            ingredient.useAmount = floorUseAmount
        }
    }
}

#Preview {
    EditIngredientView(
        ingredientModel: IngredientInfo.IngredientModel.convertToModel(PreviewSampleData.carrot, useAmount: 0),
        useIngredientList: .constant([]),
        viewType: .add, navigationPath: .constant(.init()))
}

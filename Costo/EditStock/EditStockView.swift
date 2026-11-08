//
//  EditStockView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/22.
//

import SwiftUI
import SwiftData

struct EditStockView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: EditStockViewModel
    
    init(grocery: Grocery? = nil, viewType: EditStockViewModel.ViewType) {
        self.viewModel = .init(grocery: grocery, viewType: viewType)
    }
    
    var body: some View {
        NavigationStack {
            Divider()
            List {
                Group {
                    Section("Name") {
                        TextField("", text: $viewModel.inputModel.name)
                            .onChange(of: viewModel.inputModel.name) { _, _ in
                                viewModel.checkValue(.pass)
                            }
                            .foregroundStyle(.black)
                    }
                    
                    Section("Price") {
                        TextField("", value: $viewModel.inputModel.price, format: .number)
                            .onChange(of: viewModel.inputModel.price) { old, new in
                                viewModel.checkValue(.price(old: old, new: new))
                            }
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.black)
                    }
                    
                    Section("Amount") {
                        TextField("", value: $viewModel.inputModel.amount, format: .number)
                            .onChange(of: viewModel.inputModel.amount) { old, new in
                                viewModel.checkValue(.amount(old: old, new: new))
                            }
                            .keyboardType(.decimalPad)
                            .foregroundStyle(.black)
                    }
                    if viewModel.viewType == .edit {
                        Section("Remaining Amount") {
                            TextField("", value: $viewModel.inputModel.remainingAmount, format: .number)
                                .onChange(of: viewModel.inputModel.remainingAmount) { old, new in
                                    viewModel.checkValue(.remainingAmount(old: old, new: new))
                                }
                                .keyboardType(.decimalPad)
                                .foregroundStyle(.black)
                        }
                    }
                    
                    Section("Unit") {
                        Picker("", selection: $viewModel.inputModel.unit) {
                            ForEach(UnitType.allCases, id: \.self) { unit in
                                Text(unit.string)
                                    .tag(unit)
                                    .foregroundStyle(.black)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                .textFieldStyle(.roundedBorder)
                .foregroundStyle(.gray)
            }
            .scrollContentBackground(.hidden)
            .listSectionSpacing(0)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text(viewModel.viewType.title)
                        .font(.title)
                        .fontWeight(.bold)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.save(modelContext)
                    } label: {
                        Text("Save")
                    }
                    .tint(.black)
                    .disabled(!viewModel.isEnableSave)
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
            .navigationBarTitleDisplayMode(.inline)
            .alert("", isPresented: $viewModel.isShowAlert, presenting: viewModel.alertType) { type in
                switch type {
                case .addSuccess:
                    Button("OK") {
                        dismiss()
                    }
                    Button("Continue") {
                        viewModel.reset()
                    }
                case .editSuccess, .error:
                    Button("OK") {
                        dismiss()
                    }
                }
            } message: { type in
                switch type {
                case .addSuccess, .editSuccess:
                    Text("Success")
                case .error(let error):
                    Text(error.localizedDescription)
                }
            }
        }
        .onAppear {
            viewModel.checkValue(.pass)
        }
    }
}

#Preview {
    EditStockView(grocery: PreviewSampleData.carrot, viewType: .add)
}

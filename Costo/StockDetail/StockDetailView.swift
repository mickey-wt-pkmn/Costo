//
//  StockDetailView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/21.
//

import SwiftUI

struct StockDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: StockDetailViewModel
    
    init(info: GroceryInfo, viewType: StockDetailViewModel.PreviousViewType) {
        self.viewModel = .init(groceryInfo: info, viewType: viewType)
    }
    
    var body: some View {
        Divider()
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Group {
                    Image(systemName: "pencil.and.list.clipboard")
                        .font(.title)
                        .foregroundStyle(.black)
                    HStack {
                        Text("Name")
                            .padding(.trailing)
                        Text(viewModel.groceryInfo.displayModel.name)
                            .foregroundStyle(.black)
                    }
                    HStack {
                        Text("Price")
                            .padding(.trailing)
                        Text(viewModel.groceryInfo.displayModel.price)
                            .foregroundStyle(.black)
                    }
                    HStack {
                        Text("Amount")
                            .padding(.trailing)
                        Text(viewModel.groceryInfo.displayModel.amount)
                            .foregroundStyle(.black)
                    }
                    HStack {
                        Text("RemainingAmount")
                            .padding(.trailing)
                        Text(viewModel.groceryInfo.displayModel.remainingAmount)
                            .foregroundStyle(viewModel.groceryInfo.grocery.remainingAmount > 0 ? .black : .red)
                    }
                }
                .foregroundStyle(.gray)
                VStack {
                    Spacer()
                    Divider()
                    if viewModel.viewType == .list {
                        Button("Move to trash") {
                            viewModel.moveToTrash()
                        }
                        .buttonStyle(.primary(
                            .init(padding: 10, font: .title2, image: Image(systemName: TabType.trashList.imageName))))
                    }
                    if viewModel.viewType == .trash {
                        Button("Back to list") {
                            viewModel.backToList()
                        }
                        .buttonStyle(.primary(
                            .init(padding: 10, font: .title2, image: Image(systemName: TabType.stockList.imageName))))
                    }
                }
            }
            .padding(EdgeInsets(top: 16, leading: 32, bottom: 0, trailing: 32))
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Detail")
                    .font(.title)
                    .fontWeight(.bold)
            }
            if viewModel.viewType == .list {
                ToolbarItem(placement: .topBarTrailing) {
                    if viewModel.showingEditView {
                        Button("Cancel", role: .cancel) {
                            viewModel.showingEditView = false
                        }
                    } else {
                        Button("Edit") {
                            viewModel.showingEditView = true
                        }
                    }
                }
            }
        }
        .sheet(
            isPresented: $viewModel.showingEditView,
            content: {
                EditStockView(grocery: viewModel.groceryInfo.grocery, viewType: .edit)
            }
        )
        .alert("", isPresented: $viewModel.isShowAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Success")
        }
    }
}

#Preview {
    StockDetailView(
        info: .init(grocery: PreviewSampleData.carrot),
        viewType: .list)
    .environment(\.editMode, Binding.constant(EditMode.inactive))
}

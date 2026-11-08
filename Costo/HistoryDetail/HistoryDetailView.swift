//
//  HistoryDetailView.swift
//  Costo
//
//  Created by mickey-wp on 2024/03/24.
//

import SwiftUI
import SwiftData

struct HistoryDetailView: View {
    @Environment(\.dismiss) private var dismiss
    
    private let displayModel: HistoryDetailInfo.HistoryDetailDisplayModel
    
    init(historyInfo: HistoryInfo) {
        displayModel = .convertToModel(historyInfo.history)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                Divider()
                ForEach(displayModel.ingredientHistory) { history in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Name")
                                .padding(.trailing)
                            Text(history.name)
                                .foregroundStyle(.black)
                        }
                        HStack {
                            Text("Use Amount")
                                .padding(.trailing)
                            Text(history.useAmount)
                                .foregroundStyle(.black)
                        }
                        HStack {
                            Text("Cost")
                                .padding(.trailing)
                            Text(history.cost)
                                .foregroundStyle(.black)
                        }
                        Spacer()
                        Divider()
                    }
                    .foregroundStyle(.gray)
                }
                .padding(EdgeInsets(top: 8, leading: 32, bottom: 0, trailing: 8))
                HStack {
                    Text("All Cost")
                        .padding(.trailing)
                    Text(displayModel.allCost)
                        .foregroundStyle(.black)
                }
                .font(.title2)
            }
            .scrollContentBackground(.hidden)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("History Detail")
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
            .toolbarBackground(.white, for: .navigationBar)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HistoryDetailView(
        historyInfo: HistoryInfo(history: PreviewSampleData.history))
}

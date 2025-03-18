//
//  LazyListView.swift
//  UalaTechnicalTest
//
//  Created by Luis David Goyes Garces on 17/3/25.
//

import SwiftUI

fileprivate enum LazyListViewConstant {
    enum SelectedCell {
        static let color = Color.blue.opacity(0.5)
    }
}

struct LazyListView<CellModel, CellType: View>: View where CellModel: Hashable, CellModel: Identifiable {
    
    let shouldNavigate: Bool
    let entries: [CellModel]
    @Binding var selection: CellModel?
    @ViewBuilder var cell: (CellModel) -> CellType
    
    private func createCell(entry: CellModel) -> some View {
        HStack {
            cell(entry)
            if shouldNavigate {
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
        .padding(.horizontal)
        .background(
            selection?.id == entry.id
            ? Color(UIColor.systemGray5)
            : Color(UIColor.systemBackground)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            selection = entry
        }
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(entries) { entry in
                    if shouldNavigate {
                        NavigationLink(value: entry) {
                            createCell(entry: entry)
                        }
                        .tint(.black)
                    } else {
                        createCell(entry: entry)
                    }
                    
                    Divider()
                }
            }
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
}

fileprivate struct DummyCellModel: Identifiable, Hashable {
    let id: Int
    let title: String
}

#Preview("Should not navigate, and has nothing selected") {
    @Previewable @State var selection: DummyCellModel?
    let entries = [
        DummyCellModel(id: 1, title: "Dummy 1"),
        DummyCellModel(id: 2, title: "Dummy 2"),
    ]
    LazyListView(shouldNavigate: false, entries: entries, selection: $selection) { model in
        Text(model.title)
    }
}

#Preview("Should not navigate, and has something selected") {
    @Previewable @State var selection: DummyCellModel? =  DummyCellModel(id: 1, title: "Dummy 1")
    let entries = [
        DummyCellModel(id: 1, title: "Dummy 1"),
        DummyCellModel(id: 2, title: "Dummy 2"),
    ]
    LazyListView(shouldNavigate: false, entries: entries, selection: $selection) { model in
        Text(model.title)
    }
}

#Preview("Should navigate, and has nothing selected") {
    @Previewable @State var selection: DummyCellModel?
    let entries = [
        DummyCellModel(id: 1, title: "Dummy 1"),
        DummyCellModel(id: 2, title: "Dummy 2")
    ]
    NavigationStack {
        LazyListView(shouldNavigate: true, entries: entries, selection: $selection) { model in
            Text(model.title)
        }
    }
}

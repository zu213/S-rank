//
//  ListItem.swift
//  S Rank
//
//  Created by Zachary Upstone on 21/04/2026.
//
import SwiftData
import SwiftUI


struct ListItemView: View {
  @Bindable var item: Item
  @Environment(\.modelContext) private var modelContext

  @State private var showingConfirmation = false
  @State private var newItemName: String = ""

  private var sortedChildren: [Item] {
    item.items.sorted(by: { $0.order < $1.order })
  }

  var body: some View {
    ZStack {
      Color(.systemGroupedBackground)
        .ignoresSafeArea()

      if item.items.isEmpty {
        EmptyChildView(itemName: item.name) {
          showingConfirmation = true
        }
      } else {
        List {
          Section {
            ForEach(Array(sortedChildren.enumerated()), id: \.element.id) { index, child in
              InlineItemView(item: child, index: index)
                .listRowBackground(Color(.secondarySystemGroupedBackground))
                .listRowSeparatorTint(Color(.separator).opacity(0.5))
            }
            .onDelete(perform: deleteItems)
            .onMove(perform: moveItems)
          } header: {
            ListHeader(title: item.name)
          }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
      }
    }
    .navigationTitle("")
    .navigationBarTitleDisplayMode(.inline)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
          .font(.system(size: 15, weight: .medium, design: .rounded))
      }
      ToolbarItem(placement: .navigationBarTrailing) {
        Button {
          showingConfirmation = true
        } label: {
          Image(systemName: "plus")
            .font(.system(size: 16, weight: .semibold))
        }
      }
    }
    .alert("New item", isPresented: $showingConfirmation) {
      TextField("Name", text: $newItemName)
      Button("Add") {
        addItem()
      }
      Button("Cancel", role: .cancel) { }
    } message: {
      Text("Add an item to \(item.name)")
    }
  }

  private func addItem() {
    let newItem = Item(name: newItemName, order: item.items.count)
    newItemName = ""
    modelContext.insert(newItem)
    item.items.append(newItem)
  }

  private func moveItems(from source: IndexSet, to destination: Int) {
    var reordered = sortedChildren
    reordered.move(fromOffsets: source, toOffset: destination)
    for (index, child) in reordered.enumerated() {
      child.order = index
    }
  }

  private func deleteItems(offsets: IndexSet) {
    let sorted = sortedChildren
    withAnimation {
      for index in offsets {
        modelContext.delete(sorted[index])
      }
    }
    let deletedIDs = offsets.map { sorted[$0].id }
    item.items.removeAll { child in
      deletedIDs.contains(child.id)
    }
  }
}

// MARK: - Empty child state

struct EmptyChildView: View {
  let itemName: String
  let onAdd: () -> Void

  var body: some View {
    VStack(spacing: 24) {
      ZStack {
        Circle()
          .fill(Color.rankGold.opacity(0.12))
          .frame(width: 80, height: 80)
        Image(systemName: "plus.square.on.square")
          .font(.system(size: 30, weight: .medium))
          .foregroundStyle(Color.rankGold)
      }

      VStack(spacing: 8) {
        Text("Nothing ranked yet")
          .font(.system(size: 20, weight: .semibold, design: .rounded))
          .foregroundStyle(.primary)

        Text("Add items to build your \(itemName) ranking")
          .font(.system(size: 15, weight: .regular, design: .rounded))
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
      }

      Button {
        onAdd()
      } label: {
        Label("Add item", systemImage: "plus")
          .font(.system(size: 15, weight: .semibold, design: .rounded))
          .padding(.horizontal, 20)
          .padding(.vertical, 12)
          .background(Color.rankGold)
          .foregroundStyle(Color(.systemBackground))
          .clipShape(Capsule())
      }
    }
    .padding(40)
  }
}

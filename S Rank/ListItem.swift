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

  var body: some View {
    Group {
      if item.items.isEmpty {
        VStack {
          Text("\(item.name)")
            .font(.headline)
          Text("To convert this to a list simply add items")
        }
      } else {
        List {
          ForEach(Array(item.items.sorted(by: { $0.order < $1.order }).enumerated()), id: \.element.id) { index, child in
            InlineItemView(item: child, index: index)
          }
          .onDelete(perform: deleteItems)
          .onMove(perform: moveItems)
        }
      }
    }
    .navigationTitle(item.name)
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        EditButton()
      }
      ToolbarItem {
        Button {
          showingConfirmation = true
        } label: {
          Label("Add Item", systemImage: "plus")
        }
      }
    }
    .alert("Create Item", isPresented: $showingConfirmation) {
      TextField("Enter your item", text: $newItemName)
      Button("Confirm") {
        addItem()
      }
      Button("Cancel", role: .cancel) { }
    } message: {
      Text("Enter your new item or ranking name")
    }
  }

  private func addItem() {
    let newItem = Item(name: newItemName, order: item.items.count)
    newItemName = ""
    modelContext.insert(newItem)
    item.items.append(newItem)
  }

  private func moveItems(from source: IndexSet, to destination: Int) {
    item.items.move(fromOffsets: source, toOffset: destination)
    for (index, child) in item.items.enumerated() {
      child.order = index
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        modelContext.delete(item.items[index])
      }
    }
    item.items.remove(atOffsets: offsets)
  }
}

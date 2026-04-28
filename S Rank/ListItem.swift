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
        Text("Empty")
      } else {
        List {
          ForEach(item.items) { child in
            InlineItemView(item: child)
          }
          .onDelete(perform: deleteItems)
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
      Text("Input item name")
    }
  }

  private func addItem() {
    let newItem = Item(name: newItemName)
    newItemName = ""
    modelContext.insert(newItem)
    item.items.append(newItem)
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

//
//  ContentView.swift
//  S Rank
//
//  Created by Zachary Upstone on 12/04/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
  @Environment(\.modelContext) private var modelContext
  @Query(filter: #Predicate<Item> { $0.parent == nil }, sort: \.order) private var items: [Item]

  @State private var showingConfirmation = false
  @State private var newItemName: String = ""
  @State private var orderedItems: [Item] = []

  var body: some View {
    NavigationStack {
      List {
        ForEach(Array(orderedItems.enumerated()), id: \.element.id) { index, item in
          InlineItemView(item: item, index: index)
        }
        .onDelete(perform: deleteItems)
        .onMove(perform: moveItems)
      }
      .onChange(of: items) { _, newValue in
        // Only reset order when items are added/removed, not on every change
        if newValue.count != orderedItems.count {
          orderedItems = newValue
        }
      }
      .onAppear {
        orderedItems = items
      }
      .navigationTitle("Base Ranking")
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
        ToolbarItem {
          Button(action: {
            showingConfirmation = true
          })
          {
            Label("Add Item", systemImage: "plus")
          }
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
    let item = Item(name: newItemName, order: orderedItems.count)
    newItemName = ""
    modelContext.insert(item)
    orderedItems.append(item)
  }

  private func moveItems(from source: IndexSet, to destination: Int) {
    orderedItems.move(fromOffsets: source, toOffset: destination)
    for (index, item) in orderedItems.enumerated() {
      item.order = index
    }
  }

  private func deleteItems(offsets: IndexSet) {
    for index in offsets {
      modelContext.delete(orderedItems[index])
    }
    orderedItems.remove(atOffsets: offsets)
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}

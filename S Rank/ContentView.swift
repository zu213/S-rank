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
  @Query(filter: #Predicate<Item> { $0.parent == nil }) private var items: [Item]
    
  @State private var showingConfirmation = false
  @State private var newItemName: String = ""
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(items) { item in
          InlineItemView(item: item)
        }
        .onDelete(perform: deleteItems)
      }
      .navigationTitle("Base folder")
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
      Text("Input item name")
    }
  }
  
  
  private func addItem() {
    let item2 = Item(name: newItemName)
    newItemName = ""
    modelContext.insert(item2)
  }
  
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        //modelContext.delete(items[index])
      }
    }
  }
  
  func addItem(item: Item) {
    modelContext.insert(item)
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}

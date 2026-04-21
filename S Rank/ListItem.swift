//
//  ListItem.swift
//  S Rank
//
//  Created by Zachary Upstone on 21/04/2026.
//
import SwiftData
import SwiftUI


struct ListItemView: View {
  var name: String
  var items: [Item]
  
  @State private var showingConfirmation = false
  
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(items) { item in
          if let subItems = item.items {
            ListItemView(name: item.name, items: subItems)
          } else {
            BaseItemView(text: item.name)
          }
        }
        .onDelete(perform: deleteItems)
      }
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
    } detail: {
      Text("Select an item")
    }
    .confirmationDialog("Change background", isPresented: $showingConfirmation) {
      Text("Add new:")
        Button("Item ") {  }
        Button("List") { }
        Button("Cancel", role: .cancel) { }
    } message: {
        Text("Select a new color")
    }
  }
  
  private func addItem() {
    withAnimation {
      let newItem = Item(name: "new item")
      //modelContext.insert(newItem)
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        //modelContext.delete(items[index])
      }
    }
  }
}

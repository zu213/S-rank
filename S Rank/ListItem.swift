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
  @State var items: [Item]
  
  @State private var showingConfirmation = false
  @State private var newItemName: String = ""
  
  var body: some View {
    NavigationSplitView {
      List {
        ForEach(items) { item in
          if item.items == nil {
            NavigationLink {
              Text("Item at")
            } label: {
              InlineItemView(text: item.name) {
                item.items = []
              }
            }
          } else {
            NavigationLink {
              Text("Item at")
            } label: {
              InlineItemView(text: item.name, convertToList: nil)
            }
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
    let item = Item(name: newItemName)
    newItemName = ""
    self.items.append(item)
  }
  
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        //modelContext.delete(items[index])
      }
    }
  }
}

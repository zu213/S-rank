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
      ZStack {
        Color(.systemGroupedBackground)
          .ignoresSafeArea()

        if orderedItems.isEmpty {
          EmptyRankingView {
            showingConfirmation = true
          }
        } else {
          List {
            Section {
              ForEach(Array(orderedItems.enumerated()), id: \.element.id) { index, item in
                InlineItemView(item: item, index: index)
                  .listRowBackground(Color(.secondarySystemGroupedBackground))
                  .listRowSeparatorTint(Color(.separator).opacity(0.5))
              }
              .onDelete(perform: deleteItems)
              .onMove(perform: moveItems)
            } header: {
              ListHeader(title: "S Rank")
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
    }
    .onChange(of: items) { _, newValue in
      if newValue.count != orderedItems.count {
        orderedItems = newValue
      }
    }
    .onAppear {
      orderedItems = items
    }
    .alert("New ranking", isPresented: $showingConfirmation) {
      TextField("Name", text: $newItemName)
      Button("Add") {
        addItem()
      }
      Button("Cancel", role: .cancel) { }
    } message: {
      Text("Give your ranking a name")
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

// MARK: - Empty state

struct EmptyRankingView: View {
  let onAdd: () -> Void

  var body: some View {
    VStack(spacing: 24) {
      ZStack {
        Circle()
          .fill(Color.rankGold.opacity(0.12))
          .frame(width: 80, height: 80)
        Image(systemName: "list.number")
          .font(.system(size: 32, weight: .medium))
          .foregroundStyle(Color.rankGold)
      }

      VStack(spacing: 8) {
        Text("No rankings yet")
          .font(.system(size: 20, weight: .semibold, design: .rounded))
          .foregroundStyle(.primary)

        Text("Add your first item to start ranking")
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

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}

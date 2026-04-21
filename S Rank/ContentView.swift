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
  @Query private var items: [Item]
  
  var body: some View {
    ListItemView(name: "hello", items: items)
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}

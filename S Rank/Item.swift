//
//  Item.swift
//  S Rank
//
//  Created by Zachary Upstone on 12/04/2026.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class Item: Identifiable {
  var name: String
  var items: [Item]
  @Relationship(inverse: \Item.items) var parent: Item?

  init(name: String) {
    self.name = name
    self.items = []
  }

  init(name: String, items: [Item]) {
    self.name = name
    self.items = items
  }
}

struct InlineItemView: View {
  var item: Item

  var body: some View {
    NavigationLink {
      ListItemView(item: item)
    } label: {
      Text(item.name)
    }
  }
}

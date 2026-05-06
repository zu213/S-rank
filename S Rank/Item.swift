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
  var order: Int
  var items: [Item]
  @Relationship(inverse: \Item.items) var parent: Item?

  init(name: String, order: Int = 0) {
    self.name = name
    self.order = order
    self.items = []
  }

  init(name: String, order: Int = 0, items: [Item]) {
    self.name = name
    self.order = order
    self.items = items
  }
}

struct InlineItemView: View {
  var item: Item
  var index: Int
  
  var body: some View {
    HStack {
      Text("\(index)")
      NavigationLink {
        ListItemView(item: item)
      } label: {
        Text(item.name)
      }
    }
  }
}

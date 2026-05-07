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

// MARK: - Inline row view

struct InlineItemView: View {
  var item: Item
  var index: Int

  var body: some View {
    NavigationLink {
      ListItemView(item: item)
    } label: {
      HStack(spacing: 12) {
        RankBadge(index: index)

        VStack(alignment: .leading, spacing: 2) {
          Text(item.name)
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundStyle(Color.primary)

          if !item.items.isEmpty {
            Text("\(item.items.count) \(item.items.count == 1 ? "item" : "items")")
              .font(.system(size: 12, weight: .regular, design: .rounded))
              .foregroundStyle(Color.secondary)
          }
        }

        Spacer()
      }
      .padding(.vertical, 6)
    }
  }
}

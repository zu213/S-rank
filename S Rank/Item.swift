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
  var items: [Item]? = nil
  
  init(name: String) {
    self.name = name
  }
  
  init(name: String, items: [Item]) {
    self.name = name
    self.items = items
  }
}

struct InlineItemView: View {
  var item: Item
  
  var body: some View {
    HStack {
      NavigationLink {
        ListItemView(name: item.name, items: item.items ?? [])
      } label: {
        Text(item.name)
      }
      
      if item.items == nil {
        Button(action: {
          item.items = []
        }) {
          Image(systemName: "chevron.right")
        }
      }
    }
  }
}

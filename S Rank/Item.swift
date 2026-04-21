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

struct BaseItemView: View {
  var text: String
  
  var body: some View {
    Text(text)
  }
}

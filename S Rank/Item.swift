//
//  Item.swift
//  S Rank
//
//  Created by Zachary Upstone on 12/04/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
  var timestamp: Date
  
  init(timestamp: Date) {
    self.timestamp = timestamp
  }
}

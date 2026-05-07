//
//  DesignSystem.swift
//  S Rank
//
//  Created by Zachary Upstone on 12/04/2026.
//

import SwiftUI

// MARK: - Colors

extension Color {
  static let rankGold = Color(red: 0.96, green: 0.77, blue: 0.26)
  static let rankSilver = Color(red: 0.55, green: 0.72, blue: 0.95)
  static let rankBronze = Color(red: 0.80, green: 0.55, blue: 0.30)

  static func rankColor(for index: Int) -> Color {
    switch index {
    case 0: return .rankGold
    case 1: return .rankSilver
    case 2: return .rankBronze
    default: return Color.secondary
    }
  }
}

// MARK: - List Header

struct ListHeader: View {
  let title: String

  var body: some View {
    Text(title)
      .font(.system(size: 38, weight: .heavy, design: .rounded))
      .foregroundStyle(Color(.label))
      .textCase(nil)
      .padding(.bottom, 8)
      .padding(.horizontal, 4)
  }
}

// MARK: - Rank Badge

struct RankBadge: View {
  let index: Int

  private var label: String {
    "\(index + 1)"
  }

  private var badgeColor: Color {
    .rankColor(for: index)
  }

  private var isTopThree: Bool {
    index < 3
  }

  var body: some View {
    ZStack {
      Circle()
        .fill(isTopThree ? badgeColor.opacity(0.18) : Color(.quaternarySystemFill))
        .frame(width: 34, height: 34)

      Text(label)
        .font(.system(size: isTopThree ? 13 : 12, weight: isTopThree ? .bold : .semibold, design: .rounded))
        .foregroundStyle(isTopThree ? badgeColor : Color.secondary)
    }
  }
}

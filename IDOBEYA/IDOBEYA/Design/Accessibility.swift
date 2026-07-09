import SwiftUI

enum A11y {
  enum Tab {
    static func label(for tab: IDOTab, badgeCount: Int) -> String {
      switch tab {
      case .notifications where badgeCount > 0:
        return "\(tab.title)、未読\(badgeCount)件"
      default:
        return tab.title
      }
    }

    static func hint(for tab: IDOTab) -> String {
      switch tab {
      case .home: "ホーム画面を表示します"
      case .search: "部屋を検索します"
      case .compose: "新しい投稿を作成します"
      case .notifications: "通知一覧を表示します"
      case .profile: "マイページを表示します"
      }
    }
  }

  static func roomCard(_ room: AppRoom, compact: Bool) -> String {
    var parts = [room.name, "\(room.memberCount)人", room.category, visibilityLabel(room.visibility)]
    if room.isJoined { parts.append("参加中") }
    if !compact, !room.description.isEmpty { parts.append(room.description) }
    return parts.joined(separator: "、")
  }

  static func postCard(_ post: AppPost) -> String {
    "\(post.authorName)さんの投稿。\(post.roomName)。\(post.body)"
  }

  static func likeButton(isLiked: Bool, count: Int) -> String {
    isLiked ? "いいね済み、\(count)件" : "いいね、\(count)件"
  }

  static func commentCount(_ count: Int) -> String {
    "コメント\(count)件"
  }

  private static func visibilityLabel(_ visibility: RoomVisibility) -> String {
    switch visibility {
    case .public: "公開"
    case .inviteOnly: "招待制"
    case .private: "非公開"
    }
  }
}

extension View {
  /// HIG 最小タップ領域 44pt
  func idoMinTapTarget(alignment: Alignment = .center) -> some View {
    frame(minWidth: Theme.Spacing.minTapTarget, minHeight: Theme.Spacing.minTapTarget, alignment: alignment)
  }

  func idoAccessibility(
    _ label: String,
    hint: String? = nil,
    traits: AccessibilityTraits = []
  ) -> some View {
    modifier(AccessibilityModifier(label: label, hint: hint, traits: traits))
  }
}

private struct AccessibilityModifier: ViewModifier {
  let label: String
  let hint: String?
  let traits: AccessibilityTraits

  func body(content: Content) -> some View {
    content
      .accessibilityElement(children: .ignore)
      .accessibilityLabel(label)
      .accessibilityHint(hint ?? "")
      .accessibilityAddTraits(traits)
  }
}

extension View {
  func idoAccessibilityGrouped(_ label: String, hint: String? = nil) -> some View {
    accessibilityElement(children: .combine)
      .accessibilityLabel(label)
      .accessibilityHint(hint ?? "")
  }
}

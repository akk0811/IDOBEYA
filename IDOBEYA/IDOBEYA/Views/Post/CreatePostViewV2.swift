import SwiftUI

/// Design System v1.0 ベースの投稿作成画面（STEP7）
///
/// STEP14 より `MainTabView` の投稿タブで使用。Preview / モーダル確認時は `showCancelButton: true`（既定）。
struct CreatePostViewV2: View {
  let destinationRoom: RoomDetailItem
  let hints: [CreatePostHint]
  let options: [CreatePostOption]
  let showCancelButton: Bool

  @State private var bodyText: String
  @State private var isAnonymous: Bool

  private let maxCharacterCount = MockCreatePost.maxCharacterCount

  init(
    destinationRoom: RoomDetailItem = MockRoomDetails.chatLounge,
    hints: [CreatePostHint] = MockCreatePost.hints,
    options: [CreatePostOption] = MockCreatePost.options,
    previewBodyText: String? = nil,
    previewIsAnonymous: Bool = false,
    showCancelButton: Bool = true
  ) {
    self.destinationRoom = destinationRoom
    self.hints = hints
    self.options = options
    self.showCancelButton = showCancelButton
    _bodyText = State(initialValue: previewBodyText ?? "")
    _isAnonymous = State(initialValue: previewIsAnonymous)
  }

  var body: some View {
    VStack(spacing: 0) {
      postHeader

      ScrollView {
        VStack(alignment: .leading, spacing: AppTheme.spacing.lg) {
          destinationCard
          editorSection
          hintsSection
          optionsSection
          anonymousSection
          prePostRulesCard
        }
        .padding(.horizontal, AppTheme.spacing.lg)
        .padding(.top, AppTheme.spacing.sm)
        .padding(.bottom, AppTheme.spacing.xl)
      }
    }
    .background(AppTheme.colors.background)
  }

  // MARK: - Header

  private var postHeader: some View {
    ZStack {
      AppHeader(title: "新しい投稿")

      HStack(spacing: AppTheme.spacing.sm) {
        if showCancelButton {
          Button(action: {}) {
            Text("キャンセル")
              .font(AppTheme.typography.presets.body.font())
              .foregroundStyle(AppTheme.colors.textSecondary)
          }
          .frame(minWidth: AppTheme.spacing.huge, minHeight: AppTheme.spacing.huge, alignment: .leading)
          .accessibilityLabel("キャンセル")
        } else {
          Color.clear
            .frame(width: AppTheme.spacing.huge, height: AppTheme.spacing.huge)
        }

        Spacer(minLength: AppTheme.spacing.xs)

        Button(action: {}) {
          Text("投稿")
            .font(AppTheme.typography.presets.body.font())
            .fontWeight(AppTheme.typography.weights.semibold)
            .foregroundStyle(canSubmitPost ? AppTheme.colors.primary : AppTheme.colors.primary.opacity(0.4))
        }
        .disabled(!canSubmitPost)
        .frame(minWidth: AppTheme.spacing.huge, minHeight: AppTheme.spacing.huge, alignment: .trailing)
        .accessibilityLabel("投稿")
      }
      .padding(.horizontal, AppTheme.spacing.md)
    }
  }

  // MARK: - Destination

  private var destinationCard: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      sectionTitle("投稿先")

      BaseCard {
        HStack(alignment: .center, spacing: AppTheme.spacing.sm) {
          Image(systemName: destinationRoom.iconName)
            .font(.system(size: AppTheme.typography.sizes.heading, weight: AppTheme.typography.weights.medium))
            .foregroundStyle(AppTheme.colors.primary)
            .frame(width: AppTheme.spacing.xxl, height: AppTheme.spacing.xxl)
            .background(AppTheme.colors.primary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))

          VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
            Text(destinationRoom.name)
              .font(AppTheme.typography.presets.subHeading.font())
              .foregroundStyle(AppTheme.colors.textPrimary)
              .lineLimit(1)
            Text(destinationSummary)
              .font(AppTheme.typography.presets.caption.font())
              .foregroundStyle(AppTheme.colors.textSecondary)
          }

          Spacer(minLength: AppTheme.spacing.xs)

          Image(systemName: "chevron.right")
            .font(.system(size: AppTheme.typography.sizes.caption, weight: AppTheme.typography.weights.semibold))
            .foregroundStyle(AppTheme.colors.textSecondary)
        }
      }
      .accessibilityElement(children: .combine)
      .accessibilityLabel("投稿先、\(destinationRoom.name)、\(destinationSummary)")
    }
  }

  // MARK: - Editor

  private var editorSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      AppTextEditor(
        placeholder: "なにか話してみよう...",
        text: $bodyText,
        maxLength: maxCharacterCount
      )

      Text(MockCreatePost.helperText)
        .font(AppTheme.typography.presets.caption.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .fixedSize(horizontal: false, vertical: true)
    }
  }

  // MARK: - Hints

  private var hintsSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      sectionTitle("投稿のヒント")

      ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: AppTheme.spacing.xs) {
          ForEach(hints) { hint in
            AppChip(title: hint.label, action: { applyHint(hint) })
          }
        }
        .padding(.vertical, AppTheme.spacing.xxs)
      }
    }
  }

  // MARK: - Options

  private var optionsSection: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      sectionTitle("投稿オプション")

      HStack(spacing: AppTheme.spacing.md) {
        ForEach(options) { option in
          postOptionItem(option)
        }
        Spacer(minLength: 0)
      }
    }
  }

  private func postOptionItem(_ option: CreatePostOption) -> some View {
    VStack(spacing: AppTheme.spacing.xs) {
      IconCircleButton(
        systemName: option.systemImage,
        backgroundStyle: .background,
        accessibilityLabel: option.label,
        action: {}
      )
      .opacity(0.45)
      .allowsHitTesting(false)

      Text(option.label)
        .font(AppTheme.typography.presets.caption.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
    }
    .frame(maxWidth: .infinity)
  }

  // MARK: - Anonymous

  private var anonymousSection: some View {
    BaseCard {
      Toggle(isOn: $isAnonymous) {
        VStack(alignment: .leading, spacing: AppTheme.spacing.xxs) {
          Text("匿名で投稿する")
            .font(AppTheme.typography.presets.subHeading.font())
            .foregroundStyle(AppTheme.colors.textPrimary)
          Text(MockCreatePostUser.anonymousDescription)
            .font(AppTheme.typography.presets.caption.font())
            .foregroundStyle(AppTheme.colors.textSecondary)
            .fixedSize(horizontal: false, vertical: true)
        }
      }
      .tint(AppTheme.colors.primary)
    }
  }

  // MARK: - Rules

  private var prePostRulesCard: some View {
    VStack(alignment: .leading, spacing: AppTheme.spacing.sm) {
      Text("投稿前の確認")
        .font(AppTheme.typography.presets.subHeading.font())
        .foregroundStyle(AppTheme.colors.textPrimary)

      Text(destinationRoom.comfortRules.joined(separator: " / "))
        .font(AppTheme.typography.presets.body.font())
        .foregroundStyle(AppTheme.colors.textSecondary)
        .fixedSize(horizontal: false, vertical: true)
    }
    .padding(AppTheme.spacing.md)
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(AppTheme.colors.primary.opacity(0.06))
    .clipShape(RoundedRectangle(cornerRadius: AppTheme.radius.medium))
    .overlay(
      RoundedRectangle(cornerRadius: AppTheme.radius.medium)
        .stroke(AppTheme.colors.primary.opacity(0.12), lineWidth: 1)
    )
  }

  // MARK: - Computed

  private var trimmedBodyText: String {
    bodyText.trimmingCharacters(in: .whitespacesAndNewlines)
  }

  private var canSubmitPost: Bool {
    !trimmedBodyText.isEmpty && !isOverCharacterLimit
  }

  private var isOverCharacterLimit: Bool {
    bodyText.count > maxCharacterCount
  }

  private var destinationSummary: String {
    let visibilityLabel: String = switch destinationRoom.visibility {
    case .public: "公開部屋"
    case .inviteOnly: "招待制"
    case .private: "非公開"
    }
    return "\(visibilityLabel)・\(destinationRoom.memberCount)人"
  }

  // MARK: - Actions

  private func applyHint(_ hint: CreatePostHint) {
    if bodyText.isEmpty {
      bodyText = hint.prompt
      return
    }

    let separator = bodyText.hasSuffix(" ") || bodyText.hasSuffix("、") ? "" : " "
    bodyText += separator + hint.prompt
  }

  // MARK: - Helpers

  private func sectionTitle(_ title: String) -> some View {
    Text(title)
      .font(AppTheme.typography.presets.heading.font())
      .foregroundStyle(AppTheme.colors.textPrimary)
      .accessibilityAddTraits(.isHeader)
  }
}

#Preview("Create Post V2") {
  CreatePostViewV2()
}

#Preview("Create Post V2 — With Text") {
  CreatePostViewV2(
    previewBodyText: "今日は少し疲れたので、ゆるく話せる場所があって安心しました。"
  )
}

#Preview("Create Post V2 — Over Limit") {
  CreatePostViewV2(
    previewBodyText: String(repeating: "あ", count: MockCreatePost.maxCharacterCount + 1)
  )
}

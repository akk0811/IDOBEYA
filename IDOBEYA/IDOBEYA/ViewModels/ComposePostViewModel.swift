import Foundation

@MainActor
final class ComposePostViewModel<Store: AppStoring>: ViewModelBase {
  private let store: Store

  @Published var bodyText = ""
  @Published var selectedRoomID: UUID?
  @Published var includeImage = false
  @Published var includePoll = false
  @Published var pollQuestion = ""
  @Published var isAnonymous = false
  @Published var isPosting = false

  let preselectedRoomID: UUID?
  let embeddedInTab: Bool

  init(store: Store, preselectedRoomID: UUID? = nil, embeddedInTab: Bool = false) {
    self.store = store
    self.preselectedRoomID = preselectedRoomID
    self.embeddedInTab = embeddedInTab
    super.init()
    observe(store)
  }

  var joinedRooms: [AppRoom] { store.joinedRooms }

  var canPost: Bool {
    TextValidator.isNotEmpty(bodyText)
      && selectedRoomID != nil
      && (!includePoll || TextValidator.isNotEmpty(pollQuestion))
  }

  func configureInitialRoom() {
    if selectedRoomID == nil {
      selectedRoomID = preselectedRoomID ?? joinedRooms.first?.id
    }
  }

  func selectedRoomName() -> String {
    store.room(id: selectedRoomID ?? UUID())?.name ?? "部屋を選択"
  }

  func submit(onComplete: @escaping () -> Void) {
    guard let roomID = selectedRoomID else { return }
    isPosting = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
      guard let self else { return }
      store.addPost(
        roomID: roomID,
        body: bodyText,
        isAnonymous: isAnonymous,
        hasImage: includeImage,
        pollQuestion: includePoll ? pollQuestion : nil
      )
      isPosting = false
      if embeddedInTab {
        resetForm()
      } else {
        onComplete()
      }
    }
  }

  func resetForm() {
    bodyText = ""
    includeImage = false
    includePoll = false
    pollQuestion = ""
    isAnonymous = false
  }
}

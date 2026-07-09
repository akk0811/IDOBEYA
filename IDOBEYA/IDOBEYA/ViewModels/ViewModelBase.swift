import Combine
import Foundation

@MainActor
class ViewModelBase: ObservableObject {
  private var cancellable: AnyCancellable?

  func observe<S: ObservableObject>(_ source: S) {
    cancellable = source.objectWillChange.sink { [weak self] _ in
      self?.objectWillChange.send()
    }
  }
}

import SwiftUI
import ComposableArchitecture

@main
struct NetflixCloneApp: App {
  var body: some Scene {
    WindowGroup {
      ContentView(
        store: Store(initialState: Feature.State()) {
          Feature()
        }
      )
    }
  }
}

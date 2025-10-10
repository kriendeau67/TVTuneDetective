import SwiftUI

@main
struct TVTuneDetectiveApp: App {
    @StateObject private var engine = GameEngine()

    var body: some Scene {
        WindowGroup {
            ContentView(engine: engine)
        }
    }
}

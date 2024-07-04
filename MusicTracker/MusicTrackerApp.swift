import SwiftUI

@main
struct MusicTrackerApp: App {
    @StateObject private var entryManager = EntryManager()
    var body: some Scene {
        WindowGroup {
            PracticeView(entryManager: entryManager)
                .environmentObject(entryManager)
        }
    }
}

//
//  MusicTrackerApp.swift
//  MusicTracker
//
//  Created by Mekhala Vithala on 1/7/24.
//

import SwiftUI

@main
struct MusicTrackerApp: App {
    let entryManager = EntryManager()
    var body: some Scene {
        WindowGroup {
            TabContentView(entryManager: entryManager)
        }
    }
}

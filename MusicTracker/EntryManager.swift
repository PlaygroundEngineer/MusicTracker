//
//  EntryManager.swift
//  MusicTracker
//
//  Created by Mekhala Vithala on 7/14/24.
//

import Foundation
import SwiftUI

public struct PracticeEntry: Identifiable, Codable {
    public var id = UUID()
    var imageData: Data?
    var date = Date()
    var duration: String
    var songTitle: String
    var feedback: String
    var notes: String
    var colorHex: String
}

class EntryManager: ObservableObject {
    @Published var entries: [PracticeEntry] = []
    
    var colorIndex: Int = 0
    
    func getSequentialColor() -> String {
        let colors: [String] = [
            CustomColors.green,
            CustomColors.blue,
            CustomColors.pink,
            CustomColors.yellow,
            CustomColors.magenta,
            CustomColors.slate,
            CustomColors.tan
        ]
        let color = colors[self.colorIndex % colors.count]
        self.colorIndex += 1
        return color
    }
    
    func saveEntriesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "practiceEntries")
        }
    }
    
    func deleteEntry(by id: UUID) {
        if let index = entries.firstIndex(where: { $0.id == id }) {
            entries.remove(at: index)
            saveEntriesToUserDefaults()
        }
    }
    
    func updateEntry(_ entry: PracticeEntry) {
        if let index = entries.firstIndex(where: { $0.id == entry.id }) {
            entries[index] = entry
            saveEntriesToUserDefaults()
        }
    }
}

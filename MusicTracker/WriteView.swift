import SwiftUI
import Combine

public struct PracticeEntry: Identifiable, Codable {
    public var id = UUID()
    var imageData: Data?
    var date = Date()
    var duration: Int
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

struct WriteView: View {
    @EnvironmentObject var entryManager: EntryManager
    @State private var newEntry = PracticeEntry(imageData: nil, date: Date(), duration: 0, songTitle: "", feedback: "", notes: "", colorHex: "")
    
    var body: some View {
        Color(hex: CustomColors.cream, opacity: 1)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        VStack (spacing: 1) {
                            Spacer()
                            Text("journey")
                                .font(.system(size: 40))
                            //.fontDesign(.monospaced)
                            //.fontWeight(.light)
                            Text("FURTHER")
                                .font(.system(size: 50))
                            //.fontDesign(.serif)
                            //.fontWeight(.bold)
                                .zIndex(1)
                            
                            ZStack {
                                Rectangle()
                                    .foregroundColor(Color(hex: CustomColors.tan, opacity: 1))
                                    .frame(width: UIScreen.width * 0.9, alignment: .center)
                                    .offset(y: -25)
                                    .zIndex(0)
                                
                                VStack {
                                    // Song Title Text Editor
                                    TextEditorWithPlaceholder(text: $newEntry.songTitle, placeholder: "Type your song...")
                                        .frame(width: UIScreen.width * 0.84)
                                    
                                    // Feedback Text Editor
                                    TextEditorWithPlaceholder(text: $newEntry.notes, placeholder: "Type your practice...")
                                        .frame(width: UIScreen.width * 0.84)
                                    
                                    // Notes Text Editor
                                    TextEditorWithPlaceholder(text: $newEntry.feedback, placeholder: "Type your feedback...")
                                        .frame(width: UIScreen.width * 0.84)
                                    TaskView(newEntry: $newEntry, entryManager: entryManager)
                                }
                                .padding(8)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            )
    }
}

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CustomTextEditor(text: $text, placeholder: placeholder)
                .background(
                    Rectangle()
                        .foregroundColor(Color(hex: CustomColors.cream, opacity: 1))
                ) 
                .border(Color(hex: CustomColors.black, opacity: 1), width: 1)
            
            Rectangle()
                .frame(width: UIScreen.width * 0.84, height: 5)
                .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
        }
        .padding(8)
    }

} 


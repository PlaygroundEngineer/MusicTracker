import SwiftUI
import Combine

public struct PracticeEntry: Identifiable, Codable {
    public var id = UUID()
    //var image: UIImage?
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
        ]
        let color = colors[entryManager.colorIndex % colors.count]
        self.colorIndex += 1
        return color
    }
    
    // Function to save entries to UserDefaults
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
    @State private var newEntry = PracticeEntry(date: Date(), duration: 0, songTitle: "", feedback: "", notes: "", colorHex: "")
    
    var body: some View {
        Color(hex: CustomColors.cream, opacity: 1)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        // Brown background rectangle
                        Rectangle()
                            .foregroundColor(Color(hex: CustomColors.tan, opacity: 1))
                            .frame(width: UIScreen.main.bounds.width * 0.33, height: UIScreen.main.bounds.height * 0.4, alignment: .center)
                        
                        VStack(spacing: 1) {
                            Spacer()
                            Text("journey")
                                .font(.system(size: 40))
                                .fontDesign(.monospaced)
                                .fontWeight(.light)
                            Text("FURTHER")
                                .font(.system(size: 50))
                                .fontDesign(.serif)
                                .fontWeight(.bold)
                            //.offset(y: 4)
                            
                            // Song Title Text Editor
                            TextEditorWithPlaceholder(text: $newEntry.songTitle, placeholder: "Type your song...")
                                .frame(width: UIScreen.main.bounds.width * 0.28, height: UIScreen.main.bounds.height * 0.07)
                            
                            // Notes Text Editor
                            TextEditorWithPlaceholder(text: $newEntry.notes, placeholder: "Type your practice...")
                                .frame(width: UIScreen.main.bounds.width * 0.28, height: UIScreen.main.bounds.height * 0.12)
                            
                            // Feedback Text Editor
                            TextEditorWithPlaceholder(text: $newEntry.feedback, placeholder: "Type your feedback...")
                                .frame(width: UIScreen.main.bounds.width * 0.28, height: UIScreen.main.bounds.height * 0.12)
                            
                            HStack {
                                ZStack {
                                    Circle()
                                        .frame(width: 25)
                                        .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                                    Image(systemName: "camera")
                                        .font(.system(size: 10))
                                        .foregroundColor(Color.white)
                                }
                                
                                ZStack(alignment: .leading) {
                                    ZStack {
                                        Rectangle()
                                            .frame(width: 125, height: 25)
                                            .cornerRadius(25)
                                            .foregroundColor(Color.white)
                                        
                                        Text("  25 minutes")
                                            .font(.system(size: 10))
                                    }
                                    
                                    ZStack {
                                        Circle()
                                            .frame(width: 25)
                                            .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                                        Image(systemName: "play.fill")
                                            .font(.system(size: 10))
                                            .foregroundColor(Color.white)
                                    }
                                }
                                
                                ZStack {
                                    Rectangle()
                                        .frame(width: 60, height: 25)
                                        .cornerRadius(25)
                                        .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                                    
                                    Button(action: {
                                        newEntry.colorHex = entryManager.getSequentialColor()
                                        //print(String(newEntry.colorHex))
                                        entryManager.entries.append(newEntry)
                                        entryManager.saveEntriesToUserDefaults()
                                        newEntry = PracticeEntry(date: Date(), duration: 0, songTitle: "", feedback: "", notes: "", colorHex: "")
                                    }) {
                                        ZStack {
                                            Rectangle()
                                                .frame(width: 60, height: 25)
                                                .cornerRadius(25)
                                                .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                                            
                                            Text("Add ->")
                                                .font(.system(size: 10))
                                                .foregroundColor(Color.white)
                                        }
                                    }
                                }
                            }
                            .padding(8)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(y: -UIScreen.main.bounds.height * 0.23)
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
            TextEditor(text: $text)
                .border(Color(hex: CustomColors.black, opacity: 1), width: 1)
            
            Rectangle()
                .frame(width: UIScreen.width * 0.28, height: 5)
                .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
        }
        .padding(8)
    }
}

import SwiftUI
import Combine

public struct PracticeEntry: Identifiable, Codable {
    public var id = UUID()
    //var imageData: Data?
    var date = Date()
    var duration: Int
    var songTitle: String
    var feedback: String
    var notes: String
}

class EntryManager: ObservableObject {
    @Published var entries: [PracticeEntry] = []
    
    func saveEntriesToUserDefaults() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(entries) {
            UserDefaults.standard.set(encoded, forKey: "practiceEntries")
        }
    }
}

struct WriteView: View {
    @EnvironmentObject var entryManager: EntryManager
    @State private var newEntry = PracticeEntry(date: Date(), duration: 0, songTitle: "", feedback: "", notes: "")
    
    var body: some View {
        /*Color(hex: CustomColors.cream, opacity: 1)
         .edgesIgnoringSafeArea(.all)*/
        GeometryReader { geometry in
            // Brown background rectangle
            VStack(spacing: 1) {
                Spacer()
                Text("journey")
                    .font(.system(size: 40))
                Text("FURTHER")
                    .font(.system(size: 50))
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
                        TextEditorWithPlaceholder(text: $newEntry.feedback, placeholder: "Type your practice...")
                            .frame(width: UIScreen.width * 0.84)
                        
                        // Notes Text Editor
                        TextEditorWithPlaceholder(text: $newEntry.notes, placeholder: "Type your feedback...")
                            .frame(width: UIScreen.width * 0.84)
                        TaskView(newEntry: $newEntry, entryManager: entryManager)
                    }
                    .padding(8)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                //.offset(y: UIScreen.height * 0.10)
            }
        }
    }
}

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            /*if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(hex: CustomColors.cream, opacity: 1))
                    .padding(8)
            }*/
            
            CustomTextEditor(text: $text, placeholder: placeholder)
                .background(
                    Rectangle()
                        .foregroundColor(Color(hex: CustomColors.cream, opacity: 1))
                ) 
                .border(Color(hex: CustomColors.black, opacity: 1), width: 1)
            //.padding(8)
             
            Rectangle()
                .frame(width: UIScreen.width * 0.84, height: 5)
                .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
        }
        .padding(8)
    }
}






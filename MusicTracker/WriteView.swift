import SwiftUI
import Combine

struct WriteView: View {
    @State var entry: PracticeEntry
    @EnvironmentObject var entryManager: EntryManager
    // @State private var newEntry = PracticeEntry(imageData: nil, date: Date(), duration: 0, songTitle: "", feedback: "", notes: "", colorHex: "")
    
    var body: some View {
        Color(hex: CustomColors.cream, opacity: 1)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        VStack(spacing: 1) {
                            Spacer()
                            Text("journey")
                                .font(.system(size: 40))
                                .fontDesign(.monospaced)
                                .fontWeight(.light)
                                .foregroundColor(Color(hex: CustomColors.black))
                            Text("FURTHER")
                                .font(.system(size: 50))
                                .fontDesign(.serif)
                                .fontWeight(.bold)
                                .foregroundColor(Color(hex: CustomColors.black))
                                .zIndex(1)
                            TaskView(newEntry: $entry, entryManager: entryManager)
                            
                            ScrollView {
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(Color(hex: CustomColors.tan, opacity: 1))
                                        .frame(width: UIScreen.width * 0.9, alignment: .center)
                                    //.offset(y: -25)
                                        .zIndex(0)
                                    
                                    VStack {
                                        // Song Title Text Editor
                                        TextEditorWithPlaceholder(text: $entry.songTitle, placeholder: "What is the title of your achievement?")
                                            .frame(width: UIScreen.width * 0.84)
                                            .padding(20)
                                        // Feedback Text Editor
                                        TextEditorWithPlaceholder(text: $entry.notes, placeholder: "How would you describe your achievement?")
                                            .frame(width: UIScreen.width * 0.84)
                                        // Notes Text Editor
                                        TextEditorWithPlaceholder(text: $entry.feedback, placeholder: "What feedback or notes do you have on your achievement?")
                                            .frame(width: UIScreen.width * 0.84)
                                            .padding(20)
                                        
                                    }
                                    
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                }
                    .onTapGesture {
                        self.hideKeyboard()
                    }
            )
    }
}

// Extension to hide keyboard
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

import SwiftUI
struct PracticeDetailView: View {
    var entry: PracticeEntry
    @ObservedObject var entryManager: EntryManager
    @State private var isEditingFeedback = false
    @State private var isEditingNotes = false
    @State private var editableFeedback: String = ""
    @State private var editableNotes: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill) 
                    .frame(height: UIScreen.height * 0.5)
                    .frame(width: UIScreen.width * 0.9)
                    .clipped()
                    .cornerRadius(5.0)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color(hex: CustomColors.black), lineWidth: 1.5)
                            .frame(height: UIScreen.height * 0.5)
                            .frame(width: UIScreen.width * 0.9)
                            .padding()
                    )
            } 
            
            Text(entry.songTitle)
                .font(.title)
                .foregroundColor(Color(hex: CustomColors.black))
                .padding([.leading, .trailing, .top])
            
            HStack {
                Image(systemName: "clock")
                Text("\(entry.duration) seconds")
                Spacer()
                Text(entry.date, style: .date)
            }
            .font(.subheadline)
            .foregroundColor(Color(hex: CustomColors.gray, opacity: 1))
            .padding([.leading, .trailing])
            
            Text("What did I practice?")
                .font(.headline)
                .foregroundColor(Color(hex: CustomColors.black))
                .padding([.leading, .trailing, .top])
            
            if isEditingNotes {
                TextEditor(text: $editableNotes) 
                    .frame(height: 150)
                    .foregroundColor(Color(hex: CustomColors.gray))
                    .padding([.leading, .trailing])
                    .gesture(DragGesture().onEnded { _ in
                        endEditingNotes()
                    })
            } else {
                Text(entry.notes)
                    .foregroundColor(Color(hex: CustomColors.gray))
                    .padding([.leading, .trailing, .bottom])
                    .onTapGesture {
                        editableNotes = entry.notes
                        isEditingNotes = true
                    }
            }
            
            Spacer()
            
            Text("What feedback do I have?")
                .font(.headline)
                .foregroundColor(Color(hex: CustomColors.black))
                .padding([.leading, .trailing, .top])
            
            if isEditingFeedback {
                TextEditor(text: $editableFeedback)
                    .frame(height: 150)
                    .foregroundColor(Color(hex: CustomColors.gray))
                    .padding([.leading, .trailing])
                    .gesture(DragGesture().onEnded { _ in
                        endEditingFeedback()
                    })
            } else {
                Text(entry.feedback)
                    .foregroundColor(Color(hex: CustomColors.gray))
                    .padding([.leading, .trailing, .bottom])
                    .onTapGesture {
                        editableFeedback = entry.feedback
                        isEditingFeedback = true
                    }
            }
            
            Spacer()
        }
        .padding()
        .background(Color(hex: entry.colorHex))
        .onAppear {
            editableFeedback = entry.feedback
            editableNotes = entry.notes
        }
        .onDisappear {
            if isEditingFeedback {
                endEditingFeedback()
            }
            if isEditingNotes {
                endEditingNotes()
            }
        }
    }
    
    private func endEditingFeedback() {
        // Save edited feedback back to entry
        var updatedEntry = entry
        updatedEntry.feedback = editableFeedback
        entryManager.updateEntry(updatedEntry)
        isEditingFeedback = false
    }
    
    private func endEditingNotes() {
        // Save edited notes back to entry
        var updatedEntry = entry
        updatedEntry.notes = editableNotes
        entryManager.updateEntry(updatedEntry)
        isEditingNotes = false
    }
}

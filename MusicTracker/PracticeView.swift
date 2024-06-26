import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .top, spacing: 20) {
                    VStack {
                        ForEach(Array(leftEntries.enumerated()), id: \.element.id) { index, entry in
                            NavigationLink(destination: PracticeDetailView(entry: entry, entryManager: entryManager)) {
                                PracticeCardView(entry: entry, entryManager: entryManager, index: index)
                            }
                        }
                    }
                    
                    VStack {
                        ForEach(Array(rightEntries.enumerated()), id: \.element.id) { index, entry in
                            NavigationLink(destination: PracticeDetailView(entry: entry, entryManager: entryManager)) {
                                PracticeCardView(entry: entry, entryManager: entryManager, index: index + leftEntries.count)
                            }
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
            }
        }
        .ignoresSafeArea()
        //.background(Color(hex: CustomColors.cream, opacity: 1))
        .padding(.vertical, 10)
    }
    
    var leftEntries: [PracticeEntry] {
        Array(entryManager.entries.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element })
    }
    
    var rightEntries: [PracticeEntry] {
        Array(entryManager.entries.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element })
    }
}

struct PracticeCardView: View {
    let entry: PracticeEntry
    @ObservedObject var entryManager: EntryManager
    let index: Int
    
    @State private var offset = CGSize.zero
    @State private var isSwiped = false
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                Button(action: {
                    withAnimation {
                        if let index = self.entryManager.entries.firstIndex(where: { $0.id == self.entry.id }) {
                            self.entryManager.entries.remove(at: index)
                        }
                    }
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(10)
                }
                .padding(.trailing, 20)
            }
            
            VStack(spacing: 8) {
                Text(entry.songTitle)
                    .font(.system(size: 24)) // Set font size to 24
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                    
                    Text("\(entry.duration) minutes")
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                    
                    Spacer()
                    
                    Text("\(entry.date, formatter: dateFormatter)")
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                }
                .padding(.horizontal, 0)
                .padding(.bottom, 10)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: entry.colorHex))
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.black, lineWidth: 1.5)
                    .overlay(
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 4)
                        }
                            .clipShape(RoundedRectangle(cornerRadius: 0))
                    )
            )
            //.shadow(radius: 5)
            .offset(x: offset.width)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        if gesture.translation.width < 0 {
                            self.offset = gesture.translation
                        }
                    }
                    .onEnded { _ in
                        if self.offset.width < -100 {
                            withAnimation {
                                self.isSwiped = true
                                self.offset.width = -100 // lock the card in place
                            }
                        } else {
                            withAnimation {
                                self.offset = .zero
                            }
                        }
                    }
            )
        }
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

struct PracticeDetailView: View {
    var entry: PracticeEntry
    @ObservedObject var entryManager: EntryManager
    @State private var isEditingFeedback = false
    @State private var isEditingNotes = false
    @State private var editableFeedback: String = ""
    @State private var editableNotes: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: "keyboard")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.black, lineWidth: 1)
                )
            
            
            Text(entry.songTitle)
                .font(.title)
                .padding([.leading, .trailing, .top])
            
            HStack {
                Image(systemName: "clock")
                Text("\(entry.duration) minutes")
                Spacer()
                Text(entry.date, style: .date)
            }
            .font(.subheadline)
            .foregroundColor(Color(hex: CustomColors.gray, opacity: 1))
            .padding([.leading, .trailing])
            
            Text("What did I practice?")
                .font(.headline)
                .padding([.leading, .trailing, .top])
            
            if isEditingNotes {
                TextEditor(text: $editableNotes) 
                    .frame(height: 150)
                    .padding([.leading, .trailing])
                    .gesture(DragGesture().onEnded { _ in
                        endEditingNotes()
                    })
            } else {
                Text(entry.notes)
                    .padding([.leading, .trailing, .bottom])
                    .onTapGesture {
                        editableNotes = entry.notes
                        isEditingNotes = true
                    }
            }
            
            Spacer()
            
            Text("What feedback do I have?")
                .font(.headline)
                .padding([.leading, .trailing, .top])
            
            if isEditingFeedback {
                TextEditor(text: $editableFeedback)
                    .frame(height: 150)
                    .padding([.leading, .trailing])
                    .gesture(DragGesture().onEnded { _ in
                        endEditingFeedback()
                    })
            } else {
                Text(entry.feedback)
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

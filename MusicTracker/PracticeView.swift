import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    @State private var isShowingWriteView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .top, spacing: 20) {
                    VStack {
                        AddNewCardView(isShowingWriteView: $isShowingWriteView)
                        
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
            .background(
                NavigationLink(destination: WriteView().environmentObject(entryManager), isActive: $isShowingWriteView) {
                    EmptyView()
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    var leftEntries: [PracticeEntry] {
        Array(entryManager.entries.enumerated().filter { $0.offset % 2 == 0 }.map { $0.element })
    }
    
    var rightEntries: [PracticeEntry] {
        Array(entryManager.entries.enumerated().filter { $0.offset % 2 != 0 }.map { $0.element })
    }
}

struct AddNewCardView: View {
    @Binding var isShowingWriteView: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.black)
                .background(Color(hex: CustomColors.tan))
                .cornerRadius(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(Color(hex: CustomColors.tan), lineWidth: 1.5)
                        .frame(width: 100, height: UIScreen.height * 0.1)
                )
                .onTapGesture {
                    isShowingWriteView = true
                }
            
            /*Text("Add New")
             .font(.system(size: 24))
             .fontWeight(.medium)
             .foregroundColor(.black)
             .multilineTextAlignment(.center)*/
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: CustomColors.tan))
        .cornerRadius(0)
        .overlay(
            RoundedRectangle(cornerRadius: 0)
                .stroke(Color(hex: CustomColors.black), lineWidth: 1.5)
                .overlay(
                    VStack {
                        Spacer()
                        Rectangle()
                            .fill(Color(hex: CustomColors.black))
                            .frame(height: 4)
                    }
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                )
        )
        .padding(.bottom, 10)
    }
}

// Continue with PracticeCardView, PracticeDetailView, etc.


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
                if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill) 
                        .frame(width: 100, height: UIScreen.height * 0.1)
                        .clipped()
                        .cornerRadius(5.0)
                    //.padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.black, lineWidth: 1.5)
                                .frame(width: 100, height: UIScreen.height * 0.1)
                        )
                }
                
                Text(entry.songTitle)
                    .font(.system(size: 24)) // Set font size to 24
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(.black)
                        .font(.system(size: 10))
                    
                    Text("\(entry.duration) seconds")
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
            if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill) 
                    .frame(height: UIScreen.height * 0.5)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(5.0)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 5.0)
                            .stroke(Color.black, lineWidth: 1.5)
                            .frame(height: UIScreen.height * 0.5)
                            .frame(maxWidth: .infinity)
                            .padding()
                    )
            } 
            
            Text(entry.songTitle)
                .font(.title)
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

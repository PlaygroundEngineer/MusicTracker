import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: 20) {
                VStack {
                    ForEach(Array(leftEntries.enumerated()), id: \.element.id) { index, entry in
                        PracticeCardView(entry: entry, entryManager: entryManager, index: index)
                    }
                }
                
                VStack {
                    ForEach(Array(rightEntries.enumerated()), id: \.element.id) { index, entry in
                        PracticeCardView(entry: entry, entryManager: entryManager, index: index + leftEntries.count)
                    }
                }
            }
            .padding(.horizontal)
        }
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
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(.white)
                        .font(.title2)
                    
                    Text("\(entry.duration) minutes")
                        .foregroundColor(.white)
                        .font(.system(size: 10)) // Use the inputted font size
                    
                    Spacer()
                    
                    Text("\(entry.date, formatter: dateFormatter)")
                        .foregroundColor(.white)
                        .font(.system(size: 10)) // Use the inputted font size
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(getSequentialColor(for: index))
            .cornerRadius(0)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.black, lineWidth: 3)
                    .overlay(
                        VStack {
                            Spacer()
                            Rectangle()
                                .fill(Color.black)
                                .frame(height: 6)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 0))
                    )
            )
            .shadow(radius: 5)
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
    
    private func getSequentialColor(for index: Int) -> Color {
        let colors: [Color] = [
            Color(hex: CustomColors.cream, opacity: 1),
            Color(hex: CustomColors.green, opacity: 1),
            Color(hex: CustomColors.blue, opacity: 1),
            Color(hex: CustomColors.tan, opacity: 1),
            Color(hex: CustomColors.pink, opacity: 1),
            Color(hex: CustomColors.yellow, opacity: 1),
            Color(hex: CustomColors.magenta, opacity: 1),
            Color(hex: CustomColors.slate, opacity: 1)
        ]
        return colors[index % colors.count]
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        let entryManager = EntryManager()
        entryManager.entries = [
            PracticeEntry(date: Date(), duration: 60, songTitle: "Coding Practice", feedback: "Good session", notes: "Focused on algorithms"),
            PracticeEntry(date: Date(), duration: 45, songTitle: "Piano Practice", feedback: "Improving technique", notes: "Played scales and arpeggios")
        ]
        return PracticeView(entryManager: entryManager)// Set a default font size for preview
    }
}

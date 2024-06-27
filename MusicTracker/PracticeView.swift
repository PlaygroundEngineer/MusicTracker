import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    
    var body: some View {
        ScrollView {
            HStack(alignment: .top, spacing: 20) {
                VStack {
                    ForEach(leftEntries) { entry in
                        PracticeCardView(entry: entry, entryManager: entryManager)
                    }
                }
                
                VStack {
                    ForEach(rightEntries) { entry in
                        PracticeCardView(entry: entry, entryManager: entryManager)
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
    
    @State private var offset = CGSize.zero
    @State private var isSwiped = false
    
    var body: some View {
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
                    .font(.subheadline)
                
                Spacer()
                
                Text("\(entry.date, formatter: dateFormatter)")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 10)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(getSequentialColor())
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.black, lineWidth: 3)
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
                            self.offset = .zero
                            if let index = self.entryManager.entries.firstIndex(where: { $0.id == self.entry.id }) {
                                self.entryManager.entries.remove(at: index)
                            }
                        }
                    } else {
                        withAnimation {
                            self.offset = .zero
                        }
                    }
                }
        )
    }
    
    private func getSequentialColor() -> Color {
        let colors: [Color] = [
            Color(hex: CustomColors.black, opacity: 1),
            Color(hex: CustomColors.gray, opacity: 1),
            Color(hex: CustomColors.cream, opacity: 1),
            Color(hex: CustomColors.tan, opacity: 1),
            Color(hex: CustomColors.green, opacity: 1),
            Color(hex: CustomColors.blue, opacity: 1),
            Color(hex: CustomColors.pink, opacity: 1),
            Color(hex: CustomColors.yellow, opacity: 1),
            Color(hex: CustomColors.magenta, opacity: 1),
            Color(hex: CustomColors.slate, opacity: 1)
        ]
        return colors[0]
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
        return PracticeView(entryManager: entryManager)
    }
}


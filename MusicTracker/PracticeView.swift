import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    
    var body: some View {
        ScrollView {
            let columns = [
                GridItem(.adaptive(minimum: 160))
            ]
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(entryManager.entries) { entry in
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
                    .background(Color.blue) // Example color, replace with dynamic color based on entry
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 3) // Black border
                    )
                    .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 10)
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

import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    @State private var newEntry = PracticeEntry(
            imageData: nil,
            date: Date(),
            duration: 0,
            songTitle: "",
            feedback: "",
            notes: "",
            colorHex: ""
        )
    @State private var isShowingWriteView = false
    
    var body: some View {
     
        NavigationView {
            Color(hex: CustomColors.cream, opacity: 1)
                .edgesIgnoringSafeArea(.all)
                .overlay(
                    GeometryReader { geometry in
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
                            
                            ScrollView {
                                HStack(alignment: .top, spacing: 20) {
                                    VStack {
                                        NewCardView(isShowingWriteView: $isShowingWriteView)
                                        
                                        ForEach(Array(leftEntries.enumerated()), id: \.element.id) { index, entry in
                                            NavigationLink(destination: PracticeDetailView(entry: entry, entryManager: entryManager)) {
                                                PracticeCardView(entry: entry, entryManager: entryManager, index: index)
                                                //WriteView(entry: entry).environmentObject(entryManager)
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
                                // PracticeDetailView(entry: newEntry, entryManager: entryManager)
                                NavigationLink(destination: WriteView(
                                    entry: PracticeEntry(imageData: nil, date: Date(), duration: 0, songTitle: "", feedback: "", notes: "", colorHex: "")
                                ).environmentObject(entryManager), isActive: $isShowingWriteView) {
                                    
                                    // NavigationLink(destination: PracticeDetailView(entry: newEntry, entryManager: entryManager), isActive: $isShowingWriteView) {
                                    EmptyView()
                                }
                            )
                        }
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










import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    @State private var isShowingWriteView = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                HStack(alignment: .top, spacing: 20) {
                    VStack {
                        NewCardView(isShowingWriteView: $isShowingWriteView)
                        
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










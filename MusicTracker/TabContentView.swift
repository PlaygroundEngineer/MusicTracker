import SwiftUI

struct TabContentView: View {
    @ObservedObject var entryManager: EntryManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            WriteView()
                .environmentObject(entryManager)
                .tabItem {
                    Image(systemName: "square.and.pencil")
                    Text("Write")
                }
                .tag(0)
            
            PracticeView(entryManager: entryManager)
                .environmentObject(entryManager)
                .tabItem {
                    Image(systemName: "music.note.list")
                    Text("Practice")
                }
                .tag(1)
            
            //MilestonesHorizontalScrollView()
                .tabItem {
                    Image(systemName: "chart.xyaxis.line")
                    Text("Stats")
                }
                .tag(2)
        }
    }
}

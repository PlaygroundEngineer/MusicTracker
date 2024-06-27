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
                    Image(systemName: "lanyardcard")
                    Text("Practice")
                }
                .tag(1)
            
            Text("Statistics")
                .tabItem {
                    Image(systemName: "arrow.clockwise")
                    Text("Stats")
                }
                .tag(2)
            //CustomTabBar(selectedTab: $selectedTab)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<3) { index in
                Rectangle()
                    .frame(width: UIScreen.width / 3, height: 4)
                    .foregroundColor(index == selectedTab ? Color(hex: CustomColors.black, opacity: 1) : Color(hex: CustomColors.black, opacity: 0.25))
            }
        }
    }
}


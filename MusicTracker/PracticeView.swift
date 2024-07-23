import SwiftUI

struct PracticeView: View {
    @ObservedObject var entryManager: EntryManager
    @State private var newEntry = PracticeEntry(
        imageData: nil,
        date: Date(),
        duration: "",
        songTitle: "",
        feedback: "",
        notes: "",
        colorHex: ""
    )
    @State private var isShowingWriteView = false
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: CustomColors.cream, opacity: 1)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 1) {
                    Spacer()
                    
                    VStack(spacing: 8) {
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
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 50) // Adjust the padding to center the text vertically
                    
                    Spacer()
                    
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
                    .background(
                        NavigationLink(destination: WriteView(
                            entry: PracticeEntry(imageData: nil, date: Date(), duration: "", songTitle: "", feedback: "", notes: "", colorHex: "")
                        ).environmentObject(entryManager), isActive: $isShowingWriteView) {
                            EmptyView()
                        }
                    )
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingWriteView = true
                        }) {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .foregroundColor(.black)
                                .padding()
                                .background(Color(hex: CustomColors.tan))
                                .cornerRadius(50)
                                .overlay(
                                    Circle()
                                        .stroke(Color.black, lineWidth: 2)
                                )
                                .shadow(radius: 10)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 30)
                    }
                }
            }
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


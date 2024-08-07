import SwiftUI

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
                        .foregroundColor(Color(hex: CustomColors.cream))
                        .padding()
                        .background(Color(hex: CustomColors.gray))
                        .cornerRadius(10)
                }
                .padding(.trailing, 20)
            }
            
            VStack(spacing: 8) {
                if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill) 
                        .frame(height: UIScreen.height * 0.1)
                        .clipped()
                        .cornerRadius(5.0)
                    //.padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color.black, lineWidth: 1.5)
                                .frame(height: UIScreen.height * 0.1)
                        )
                }
                
                Text(entry.songTitle.isEmpty ? "..." : entry.songTitle)
                    .font(.system(size: 24)) // Set font size to 24
                    .fontWeight(.medium)
                    .foregroundColor(Color(hex: CustomColors.black))
                    .multilineTextAlignment(.center)
                
                HStack {
                    Image(systemName: "timer")
                        .foregroundColor(Color(hex: CustomColors.black))
                        .font(.system(size: 10))
                    
                    Text(entry.duration)
                        .foregroundColor(Color(hex: CustomColors.black))
                        .font(.system(size: 10))
                    
                    Spacer()
                    
                    Text("\(entry.date, formatter: dateFormatter)")
                        .foregroundColor(Color(hex: CustomColors.black))
                        .font(.system(size: 10))
                }
                .padding(.horizontal, 10)
                .padding(.bottom, 10)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(hex: entry.colorHex))
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

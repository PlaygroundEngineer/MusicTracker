import SwiftUI

struct PracticeView: View {
    @State private var elapsedTime: TimeInterval = 0
    @State private var songTitle: String = ""
    @State private var selectedImage: UIImage?
    
    let boxData: [(Color, String, TimeInterval)] = [
        (.blue, "Box 1", 0),
        (.green, "Box 2", 0),
        (.orange, "Box 3", 0),
        (.red, "Box 4", 0),
        (.yellow, "Box 5", 0),
        (.purple, "Box 6", 0)
    ]
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 10) {
                ForEach(boxData.indices, id: \.self) { index in
                    if index % 2 == 0 {
                        HStack(spacing: 10) {
                            self.createBox(index: index, width: (geometry.size.width - 10) / 2)
                            if index + 1 < self.boxData.count {
                                self.createBox(index: index + 1, width: (geometry.size.width - 10) / 2)
                            } else {
                                Spacer()
                            }
                        }
                    }
                }
            }
            .padding()
            
            }
        
    }
    
    func createBox(index: Int, width: CGFloat) -> some View {
        let color = boxData[index].0
        let text = boxData[index].1
        let elapsedTime = boxData[index].2 + self.elapsedTime
        
        return Rectangle()
            .fill(color)
            .frame(width: width, height: 100)
            .overlay(
                Text("\(text) - \(Int(elapsedTime)) seconds")
                    .foregroundColor(.white)
                    .font(.headline)
            )
            .cornerRadius(10)
    }
}


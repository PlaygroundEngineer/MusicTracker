import SwiftUI

struct MilestonesHorizontalScrollView: View {
    var body: some View {
        Color(hex: CustomColors.cream, opacity: 1)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                GeometryReader { geometry in
                    ZStack {
                        VStack(alignment: .center) {
                            Spacer()
                            
                            Text("mile")
                                .font(.largeTitle)
                                .fontWeight(.light)
                                
                            Text("STONES")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            ScrollView(.horizontal) {
                                HStack {
                                    MilestoneCard(imageName: "books", title: "I finished reading the Harry Potter series 📚", subtitle: "Longest Entry", date: "8/5/23", color: Color(hex: CustomColors.blue, opacity: 1))
                                        .frame(width: 250)
                                    
                                    MilestoneCard(imageName: "flame.fill", title: "20 day streak! 🔥", subtitle: "", date: "11/27/23 to 12/16/23", color: Color(hex: CustomColors.pink, opacity: 1))
                                        .frame(width: 250)
                                    
                                    MilestoneCard(imageName: "books", title: "I finished reading the Harry Potter series 📚", subtitle: "Longest Entry", date: "8/5/23", color: Color(hex: CustomColors.yellow, opacity: 1))
                                        .frame(width: 250)
                                    
                                    MilestoneCard(imageName: "flame.fill", title: "20 day streak! 🔥", subtitle: "", date: "11/27/23 to 12/16/23", color: Color(hex: CustomColors.green, opacity: 1))
                                        .frame(width: 250)
                                }
                                .padding()
                            }
                            Spacer()
                        }
                    }
                }
            )
    }
}

struct MilestoneCard: View {
    var imageName: String
    var title: String
    var subtitle: String
    var date: String
    var color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding()
            
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
            }
            
            Text(date)
                .font(.subheadline)
                .padding(.horizontal)
                .padding(.bottom, 10)
        }
        .background(color)
        .border(Color(hex: CustomColors.black, opacity: 1), width: 1)
        .padding()
    }
}

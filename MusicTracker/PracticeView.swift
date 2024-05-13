import SwiftUI


struct PracticeView: View {
    @EnvironmentObject var entryManager: EntryManager
    var body: some View {
        List {
            ForEach(entryManager.entries.reversed()) { entry in
                VStack(alignment: .leading) {
                    /*if let imageData = entry.imageData {
                     let uiImage = UIImage(data: imageData)
                     Image(uiImage: uiImage)
                     .resizable()
                     .aspectRatio(ContentMode: .fit)
                     .frame(width: 200, height: 200)
                     }*/
                    Text("Date: \(entry.date, style: .date)")
                    Text("Duration: \(entry.duration) minutes")
                    Text("Song Title: \(entry.songTitle)")
                    Text("Feedback: \(entry.feedback)")
                    Text("Notes: \(entry.notes)")
                }
                .padding()
                .cornerRadius(10)
            }
        }
    }
}
/*
struct PracticeView: View {
    @EnvironmentObject var entryManager: EntryManager
    var body: some View {
        List {
            ForEach(entryManager.entries.reversed()) { entry in
                VStack(alignment: .leading) {
                    /*if let imageData = entry.imageData {
                        let uiImage = UIImage(data: imageData)
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(ContentMode: .fit)
                            .frame(width: 200, height: 200)
                    }*/
                    Text("Date: \(entry.date, style: .date)")
                    Text("Duration: \(entry.duration) minutes")
                    Text("Song Title: \(entry.songTitle)")
                    Text("Feedback: \(entry.feedback)")
                    Text("Notes: \(entry.notes)")
                }
                .padding()
                .cornerRadius(10)
            }
        }
    }*/

 /*
struct PracticeView: View {
    @State private var elapsedTime: TimeInterval = 0
    
    let cardData: [(
        color: Color, body: String, icon: String, duration: String, date: String
    )] = [
        (color: (Color(hex: CustomColors.yellow, opacity: 1)), body: "I got straight A’s this semester", icon: "timer", duration: "20 minutes", date: "12/16/23"),
        (color: (Color(hex: CustomColors.blue, opacity: 1)), body: "I decluttered my closet", icon: "timer", duration: "45 minutes", date: "6/25/23"),
        (color: (Color(hex: CustomColors.green, opacity: 1)), body: "I got straight A’s this semester", icon: "timer", duration: "20 minutes", date: "12/16/23"),
        (color: (Color(hex: CustomColors.pink, opacity: 1)), body: "I decluttered my closet", icon: "timer", duration: "45 minutes", date: "6/25/23"),
        (color: (Color(hex: CustomColors.blue, opacity: 1)), body: "I got straight A’s this semester", icon: "timer", duration: "20 minutes", date: "12/16/23"),
        (color: (Color(hex: CustomColors.yellow, opacity: 1)), body: "I decluttered my closet", icon: "timer", duration: "45 minutes", date: "6/25/23"),
        // ... your card data
    ]
    var body: some View {
        ScrollView {
            let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
            
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(cardData, id: \.body) { data in
                    VStack {
                        Spacer() // Push content to center
                        Text(data.body)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center) // Ensure multiline text is centered
                        Spacer() // Push content to center
                        HStack {
                            Image(systemName: data.icon)
                                .foregroundColor(.white)
                            Text(data.duration)
                                .foregroundColor(.white)
                            Spacer()
                            Text(data.date)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                    .frame(width: 300, height: 400)
                    .background(data.color)
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct PracticeView_Previews: PreviewProvider {
    static var previews: some View {
        PracticeView()
    }
}
*/

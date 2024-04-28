import SwiftUI
struct TaskView: View {
    var body: some View {
        HStack {
            ZStack {
                
                Circle()
                    .frame(width: 25)
                    .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                Image(systemName: "camera")
                    .font(.system(size: 10))
                    .foregroundColor(Color.white)
            }
            
            ZStack {
                Circle()
                    .frame(width: 25)
                    .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                Image(systemName: "calendar")
                    .font(.system(size: 10))
                    .foregroundColor(Color.white)
            }
            
            ZStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .frame(width: 110, height: 25)
                        .cornerRadius(25)
                        .foregroundColor(Color.white)
                    
                    Text("  25 minutes")
                        .font(.system(size: 10))
                }
                
                ZStack {
                    Circle()
                        .frame(width: 25)
                        .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color.white)
                }
            }
            
            ZStack {
                Rectangle()
                    .frame(width: 60, height: 25)
                    .cornerRadius(25)
                    .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                
                Text("Add ->")
                    .font(.system(size: 10))
                    .foregroundColor(Color.white)
            }
        }
    }
}

struct TaskView_Previews: PreviewProvider {
    static var previews: some View {
        TaskView()
    }
}


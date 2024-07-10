 import SwiftUI
struct AddNewCardView: View {
    @Binding var isShowingWriteView: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "plus")
                .resizable()
                .frame(width: 60, height: 60)
                .foregroundColor(.black)
                .background(Color(hex: CustomColors.tan))
                .cornerRadius(5.0)
                .overlay(
                    RoundedRectangle(cornerRadius: 5.0)
                        .stroke(Color(hex: CustomColors.tan), lineWidth: 1.5)
                        .frame(width: 100, height: UIScreen.height * 0.1)
                )
                .onTapGesture {
                    isShowingWriteView = true
                }
            
            /*Text("Add New")
             .font(.system(size: 24))
             .fontWeight(.medium)
             .foregroundColor(.black)
             .multilineTextAlignment(.center)*/
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(hex: CustomColors.tan))
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
    }
}



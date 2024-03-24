import SwiftUI

struct WriteView: View {
    @State private var songTitle: String = ""
    @State private var feedback: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Brown background rectangle
                Rectangle()
                    .foregroundColor(Color(hex: CustomColors.tan, opacity: 1))
                    .frame(width: UIScreen.width * 0.25, height: UIScreen.height * 0.4, alignment: .center)
                
                VStack(spacing: 1) {
                    Spacer()
                    Text("journey")
                        .font(.system(size: 40))
                    Text("FURTHER")
                        .font(.system(size: 50))
                    
                    // Song Title Text Editor
                    TextEditorWithPlaceholder(text: $songTitle, placeholder: "Type your song...")
                        .frame(width: UIScreen.width * 0.22, height: UIScreen.height * 0.06)
                    
                    // Feedback Text Editor
                    TextEditorWithPlaceholder(text: $feedback, placeholder: "Type your practice...")
                        .frame(width: UIScreen.width * 0.22, height: UIScreen.height * 0.12)
                    
                    // Notes Text Editor
                    TextEditorWithPlaceholder(text: $notes, placeholder: "Type your feedback...")
                        .frame(width: UIScreen.width * 0.22, height: UIScreen.height * 0.12)
                    
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
                    .padding(8)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                .offset(y: -UIScreen.height * 0.17)
            }
        }
    }
}

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if text.isEmpty {
                Text(placeholder)
                    .foregroundColor(Color(hex: CustomColors.cream, opacity: 1))
                    .padding(8)
            }
            
            TextEditor(text: $text)
                .background(
                    Rectangle()
                        .foregroundColor(Color(hex: CustomColors.cream, opacity: 1))
                )
                .border(Color(hex: CustomColors.black, opacity: 1), width: 1)
                //.padding(8)
            
            Rectangle()
                .frame(width: UIScreen.width * 0.207, height: 5)
                .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
        }
        .padding(8)
    }
}

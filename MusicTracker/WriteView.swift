import SwiftUI

struct WriteView: View {
    @State private var songTitle: String = ""
    @State private var feedback: String = ""
    @State private var notes: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            // Brown background rectangle
            VStack(spacing: 1) {
                Spacer()
                Text("journey")
                    .font(.system(size: 40))
                Text("FURTHER")
                    .font(.system(size: 50))
                    .zIndex(1)
                
                ZStack {
                    Rectangle()
                        .foregroundColor(Color(hex: CustomColors.tan, opacity: 1))
                        .frame(width: UIScreen.width * 0.9, alignment: .center)
                        .offset(y: -25)
                        .zIndex(0)
                    
                    VStack {
                        // Song Title Text Editor
                        TextEditorWithPlaceholder(text: $songTitle, placeholder: "Type your song...")
                            .frame(width: UIScreen.width * 0.84)
                        
                        // Feedback Text Editor
                        TextEditorWithPlaceholder(text: $feedback, placeholder: "Type your practice...")
                            .frame(width: UIScreen.width * 0.84)
                        
                        // Notes Text Editor
                        TextEditorWithPlaceholder(text: $notes, placeholder: "Type your feedback...")
                            .frame(width: UIScreen.width * 0.84)
                        TaskView()
                    }
                    
                    
                    
                    .padding(8)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .center)
                //.offset(y: UIScreen.height * 0.10)
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
            
            CustomTextEditor()
                .background(
                    Rectangle()
                        .foregroundColor(Color(hex: CustomColors.cream, opacity: 1))
                )
                .border(Color(hex: CustomColors.black, opacity: 1), width: 1)
            //.padding(8)
            
            Rectangle()
                .frame(width: UIScreen.width * 0.84, height: 5)
                .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
        }
        .padding(8)
    }
}


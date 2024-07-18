//
//  CustomTextEditorNew.swift
//  MusicTracker
//
//  Created by Mekhala Vithala on 7/14/24.
//

import SwiftUI

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    var minHeight: CGFloat
    @Binding var textHeight: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.textColor = .black
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.backgroundColor = UIColor.white
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.text = text
        }
        CustomTextEditor.recalculateHeight(view: uiView, result: context.coordinator)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor
        
        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            self.parent.text = textView.text
            CustomTextEditor.recalculateHeight(view: textView, result: self)
        }
    }
    
    static func recalculateHeight(view: UIView, result: Coordinator) {
        DispatchQueue.main.async {
            let newSize = view.sizeThatFits(CGSize(width: view.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            if result.parent.minHeight > newSize.height {
                result.parent.textHeight = result.parent.minHeight
            } else {
                result.parent.textHeight = newSize.height
            }
        }
    }
}

struct TextEditorWithPlaceholder: View {
    @Binding var text: String
    var placeholder: String
    @State private var textHeight: CGFloat = 40 // initial height
    @FocusState private var isFocused: Bool

    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty && !isFocused {
                Text(placeholder)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 12)
                    .onTapGesture {
                        isFocused = true
                    }
            }
            
            CustomTextEditor(text: $text, minHeight: 40, textHeight: $textHeight)
                .frame(minHeight: textHeight, maxHeight: textHeight)
                .padding(4)
                .focused($isFocused)
                .onTapGesture {
                    isFocused = true
                }
        }
        .padding(8)
        .background(
//            Rectangle()
//                .fill(Color.white)
//                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
//                .frame(height: textHeight + 16) // Adjust the height to match the text editor's height
            CustomBorder(topWidth: 1, bottomWidth: 3, 
                         sideWidth: 1, cornerRadius: 0, color: .black)
        )
        .background(.white)
        
        .padding(.horizontal)
    }
}


struct CustomBorder: View {
    var topWidth: CGFloat
    var bottomWidth: CGFloat
    var sideWidth: CGFloat
    var cornerRadius: CGFloat
    var color: Color

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height

            // Paths for each border side
            Path { path in
                // Top border
                path.move(to: CGPoint(x: cornerRadius, y: 0))
                path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
            }
            .stroke(color, lineWidth: topWidth)

            Path { path in
                // Bottom border
                path.move(to: CGPoint(x: cornerRadius, y: height))
                path.addLine(to: CGPoint(x: width - cornerRadius, y: height))
            }
            .stroke(color, lineWidth: bottomWidth)

            Path { path in
                // Left border
                path.move(to: CGPoint(x: 0, y: cornerRadius))
                path.addLine(to: CGPoint(x: 0, y: height - cornerRadius))
            }
            .stroke(color, lineWidth: sideWidth)

            Path { path in
                // Right border
                path.move(to: CGPoint(x: width, y: cornerRadius))
                path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
            }
            .stroke(color, lineWidth: sideWidth)

            // Corners
            Path { path in
                // Top-left corner
                path.move(to: CGPoint(x: 0, y: cornerRadius))
                path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
            }
            .stroke(color, lineWidth: sideWidth)

            Path { path in
                // Top-right corner
                path.move(to: CGPoint(x: width - cornerRadius, y: 0))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
            }
            .stroke(color, lineWidth: sideWidth)

            Path { path in
                // Bottom-left corner
                path.move(to: CGPoint(x: 0, y: height - cornerRadius))
                path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
            }
            .stroke(color, lineWidth: sideWidth)

            Path { path in
                // Bottom-right corner
                path.move(to: CGPoint(x: width, y: height - cornerRadius))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
            }
            .stroke(color, lineWidth: sideWidth)
        }
    }
}

//struct ContentView: View {
//    @State private var text: String = ""
//
//    var body: some View {
//        VStack {
//            TextEditorWithPlaceholder(text: $text, placeholder: "Enter text here...")
//                .padding()
//            Spacer()
//        }
//    }
//}
//

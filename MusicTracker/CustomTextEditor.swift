
import SwiftUI

struct CustomTextEditor: View {
    @Binding var text: String
    @State private var isSheetPresented = false
    var placeholder: String
    
    
    var body: some View {
        VStack {
            TextField(placeholder, text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onTapGesture {
                    isSheetPresented = true
                }
        }
        .sheet(isPresented: $isSheetPresented) {
            EditSheet(text: $text, isSheetPresented: $isSheetPresented)
        }
    }
}

struct EditSheet: View {
    @Binding var text: String
    @Binding var isSheetPresented: Bool
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Done") {
                isSheetPresented = false
            }
            .padding()
        }
        .padding()
    }
}






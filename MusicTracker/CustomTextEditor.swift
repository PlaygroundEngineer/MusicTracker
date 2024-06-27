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
            EditSheet(text: $text, isSheetPresented: $isSheetPresented, placeholder: placeholder)
        }
    }
}

struct EditSheet: View {
    @Binding var text: String
    @Binding var isSheetPresented: Bool
    var placeholder: String
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.gray)
                    
                        
                }
                
                TextEditor(text: $text)
                    .padding(25)
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .padding()
            
            Button("Done") {
                isSheetPresented = false
            }
            .padding()
        }
        .padding()
    }
}




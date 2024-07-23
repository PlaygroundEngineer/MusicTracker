import SwiftUI
import UIKit

struct CustomPracticeTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var isEditing: Bool
    var placeholder: String
    var font: UIFont
    var textColor: UIColor
    var backgroundColor: UIColor
    var onSave: () -> Void = {}
    var minHeight: CGFloat
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomPracticeTextEditor
        
        init(parent: CustomPracticeTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            CustomPracticeTextEditor.recalculateHeight(view: textView, result: self)
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isEditing = true
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            parent.isEditing = false
            parent.onSave()
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = font
        textView.textColor = textColor
        textView.backgroundColor = backgroundColor
        textView.isScrollEnabled = false
        textView.isEditable = true
        //textView.isUserInteractionEnabled = true
        textView.returnKeyType = .done
        textView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if isEditing {
            uiView.becomeFirstResponder()
        }
        CustomPracticeTextEditor.recalculateHeight(view: uiView, result: context.coordinator)
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
    
    @Binding var textHeight: CGFloat
}

struct EditableTextView: View {
    @Binding var text: String
    @State private var isEditing: Bool = false
    var placeholder: String
    var font: UIFont
    var textColor: UIColor
    var backgroundColor: UIColor
    var height: CGFloat
    var onSave: () -> Void
    @State private var textHeight: CGFloat = 40
    
    var body: some View {
        VStack {
            CustomPracticeTextEditor(
                text: $text,
                isEditing: $isEditing,
                placeholder: placeholder,
                font: font,
                textColor: textColor,
                backgroundColor: backgroundColor,
                onSave: onSave,
                minHeight: 40,
                textHeight: $textHeight
            )
            .frame(minHeight: textHeight, maxHeight: textHeight)
            .background(Color(backgroundColor))
            .cornerRadius(8)
            .padding([.leading, .trailing])
            .onTapGesture {
                isEditing = true
            }
        }
    }
}

struct PracticeDetailView: View {
    var entry: PracticeEntry
    @ObservedObject var entryManager: EntryManager
    @State private var editableTitle: String = ""
    @State private var editableFeedback: String = ""
    @State private var editableNotes: String = ""
    
    var body: some View {
        Color(hex: entry.colorHex)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                ScrollView {
                    VStack(alignment: .leading) {
                        if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(maxWidth: .infinity)
                                .clipped()
                                .cornerRadius(5.0)
                                .frame(alignment: .center)
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5.0)
                                        .stroke(Color(hex: CustomColors.black), lineWidth: 1.5)
                                        .frame(alignment: .center)
                                        .padding()
                                )
                                .frame(alignment: .center)
                        }
                        
                        EditableTextView(
                            text: $editableTitle,
                            placeholder: "...",
                            font: UIFont.systemFont(ofSize: 24, weight: .bold),
                            textColor: UIColor(Color(hex: CustomColors.black)),
                            backgroundColor: UIColor(Color.gray.opacity(0.05)),
                            height: 50,
                            onSave: endEditingTitle
                        )
                        .padding([.top])
                        
                        HStack {
                            Image(systemName: "clock")
                            Text("\(entry.duration) seconds")
                            Spacer()
                            Text(entry.date, style: .date)
                        }
                        .font(.subheadline)
                        .foregroundColor(Color(hex: CustomColors.gray, opacity: 1))
                        .padding([.leading, .trailing])
                        
                        Text("Description")
                            .font(.headline)
                            .foregroundColor(Color(hex: CustomColors.black))
                            .padding([.leading, .trailing, .top])
                        
                        EditableTextView(
                            text: $editableNotes,
                            placeholder: "...",
                            font: UIFont.systemFont(ofSize: 17),
                            textColor: UIColor(Color(hex: CustomColors.black)),
                            backgroundColor: UIColor(Color.gray.opacity(0.05)),
                            height: 150,
                            onSave: endEditingNotes
                        )
                        
                        Spacer()
                        
                        Text("Notes")
                            .font(.headline)
                            .foregroundColor(Color(hex: CustomColors.black))
                            .padding([.leading, .trailing, .top])
                        
                        EditableTextView(
                            text: $editableFeedback,
                            placeholder: "...",
                            font: UIFont.systemFont(ofSize: 17),
                            textColor: UIColor(Color(hex: CustomColors.black)),
                            backgroundColor: UIColor(Color.gray.opacity(0.05)),
                            height: 150,
                            onSave: endEditingFeedback
                        )
                        
                        Spacer()
                    }
                    .frame(alignment: .center)
                    .padding()
                    .onAppear {
                        editableFeedback = entry.feedback
                        editableNotes = entry.notes
                        editableTitle = entry.songTitle
                    }
                    .onDisappear {
                        endEditingTitle()
                        endEditingFeedback()
                        endEditingNotes()
                    }
                }
            )
    }
    
    private func endEditingTitle() {
        var updatedEntry = entry
        updatedEntry.songTitle = editableTitle
        entryManager.updateEntry(updatedEntry)
    }
    
    private func endEditingFeedback() {
        var updatedEntry = entry
        updatedEntry.feedback = editableFeedback
        entryManager.updateEntry(updatedEntry)
    }
    
    private func endEditingNotes() {
        var updatedEntry = entry
        updatedEntry.notes = editableNotes
        entryManager.updateEntry(updatedEntry)
    }
}

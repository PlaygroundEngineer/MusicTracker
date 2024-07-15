//
//  PracticeDetailViewNew.swift
//  MusicTracker
//
//  Created by Mekhala Vithala on 7/11/24.
//

import SwiftUI
import UIKit

struct CustomPracticeTextEditor: UIViewRepresentable {
    @Binding var text: String
    @Binding var isEditing: Bool
    var placeholder: String
    var font: UIFont
    var textColor: UIColor
    var backgroundColor: UIColor
    var onSave: () -> Void
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomPracticeTextEditor
        
        init(parent: CustomPracticeTextEditor) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
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
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isUserInteractionEnabled = true
        textView.returnKeyType = .done
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
        if isEditing {
            uiView.becomeFirstResponder()
        }
    }
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
    
    var body: some View {
        VStack {
            CustomPracticeTextEditor(
                text: $text,
                isEditing: $isEditing,
                placeholder: placeholder,
                font: font,
                textColor: textColor,
                backgroundColor: backgroundColor,
                onSave: onSave
            )
            .frame(height: height)
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
        VStack(alignment: .leading) {
            if let imageData = entry.imageData, let uiImage = UIImage(data: imageData) {
                GeometryReader { geometry in
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: geometry.size.height * 0.5)
                        .frame(width: geometry.size.width * 0.9)
                        .clipped()
                        .cornerRadius(5.0)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 5.0)
                                .stroke(Color(hex: CustomColors.black), lineWidth: 1.5)
                                .frame(height: geometry.size.height * 0.5)
                                .frame(width: geometry.size.width * 0.9)
                                .padding()
                        )
                }
            }
            
            EditableTextView(
                text: $editableTitle,
                placeholder: "...",
                font: UIFont.systemFont(ofSize: 24, weight: .bold),
                textColor: UIColor(Color(hex: CustomColors.black)),
                backgroundColor: .clear,
                height: 50,
                onSave: endEditingTitle
            )
            
            HStack {
                Image(systemName: "clock")
                Text("\(entry.duration) seconds")
                Spacer()
                Text(entry.date, style: .date)
            }
            .font(.subheadline)
            .foregroundColor(Color(hex: CustomColors.gray, opacity: 1))
            .padding([.leading, .trailing])
            
            Text("What did I practice?")
                .font(.headline)
                .foregroundColor(Color(hex: CustomColors.black))
                .padding([.leading, .trailing, .top])
            
            EditableTextView(
                text: $editableNotes,
                placeholder: "...",
                font: UIFont.systemFont(ofSize: 17),
                textColor: UIColor(Color(hex: CustomColors.gray)),
                backgroundColor: UIColor(Color.gray.opacity(0.2)),
                height: 150,
                onSave: endEditingNotes
            )
            
            Spacer()
            
            Text("What feedback do I have?")
                .font(.headline)
                .foregroundColor(Color(hex: CustomColors.black))
                .padding([.leading, .trailing, .top])
            
            EditableTextView(
                text: $editableFeedback,
                placeholder: "...",
                font: UIFont.systemFont(ofSize: 17),
                textColor: UIColor(Color(hex: CustomColors.gray)),
                backgroundColor: UIColor(Color.gray.opacity(0.2)),
                height: 150,
                onSave: endEditingFeedback
            )
            
            Spacer()
        }
        .padding()
        .background(Color(hex: entry.colorHex))
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

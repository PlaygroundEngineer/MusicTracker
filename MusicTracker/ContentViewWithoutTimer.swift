//
//  ContentView.swift
//  MusicTracker
//
//  Created by Mekhala Vithala on 1/7/24.
//

/*
import SwiftUI

struct PracticeEntry: Identifiable {
    var id = UUID()
    var date: Date
    var duration: Int
    var feedback: String
    var notes: String
}

struct ContentView: View {
    @State private var entries: [PracticeEntry] = []
    @State private var isAddingEntry = false
    @State private var newEntry = PracticeEntry(date: Date(), duration: 0, feedback: "", notes: "")
    
    var body: some View {
        NavigationView {
            List {
                ForEach(entries) { entry in
                    VStack(alignment: .leading) {
                        Text("Date: \(entry.date, style: .date)")
                        Text("Duration: \(entry.duration) minutes")
                        Text("Feedback: \(entry.feedback)")
                        Text("Notes: \(entry.notes)")
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(10)
                }
                .onDelete(perform: deleteEntries)
            }
            .navigationTitle("Practice Tracker")
            .navigationBarItems(trailing: Button(action: {
                isAddingEntry = true
            }) {
                Image(systemName: "plus")
            })
        }
        .sheet(isPresented: $isAddingEntry) {
            MySheetView(isAddingEntry: $isAddingEntry, newEntry: $newEntry, entries: $entries)
        }
    }
    
    private func deleteEntries(at offsets: IndexSet) {
        entries.remove(atOffsets: offsets)
    }
}

struct MySheetView: View {
    @Binding var isAddingEntry: Bool
    @Binding var newEntry : PracticeEntry
    @Binding var entries: [PracticeEntry]
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("New Practice Entry")) {
                    DatePicker("Date", selection: $newEntry.date, displayedComponents: .date)
                    Stepper("Duration: \(newEntry.duration) minutes", value: $newEntry.duration, in: 0...240, step: 5)
                    TextEditor(text: $newEntry.feedback)
                        .frame(minHeight: 25)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                        .padding(.horizontal)
                        .overlay(
                            VStack {
                                if newEntry.feedback.isEmpty {
                                    Text("Feedback").foregroundColor(Color(UIColor.placeholderText))
                                        .padding(.horizontal, 8)
                                }
                            }
                        )
                    TextEditor(text: $newEntry.notes)
                        .frame(minHeight: 25)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5)
                        .padding(.horizontal)
                        .overlay(
                            VStack {
                                if newEntry.notes.isEmpty {
                                    Text("Notes").foregroundColor(Color(UIColor.placeholderText))
                                        .padding(.horizontal, 8)
                                }
                            }
                        )
                }
                Button(action: {
                    entries.append(newEntry)
                    newEntry = PracticeEntry(date: Date(), duration: 0, feedback: "", notes: "")
                    isAddingEntry = false
                }) {
                    Text("Save")
                }
            }
            .navigationTitle("Add Entry")
            .navigationBarItems(leading: Button("Cancel") {
                isAddingEntry = false
            })
        }
    }
}



#Preview {
    ContentView()
}
*/

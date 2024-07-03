import SwiftUI

struct TaskView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @Binding var newEntry: PracticeEntry
    @ObservedObject var entryManager: EntryManager
    @State private var timer: Timer? = nil
    @State private var isPlaying: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    @State private var customText: String = ""
    
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 25)
                    .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Image(systemName: "camera")
                        .font(.system(size: 10))
                        .foregroundColor(Color.white)
                }
                .padding(4)
                .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
            
            ZStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 110, height: 25)
                        .foregroundColor(Color.white)
                    if isPlaying {
                        Text("\(Int(elapsedTime)) seconds")
                            .foregroundColor(.black)
                            .padding(.horizontal) // Add horizontal padding
                            .frame(width: 85, height: 40) // Fixed width
                            .font(.system(size: 10))
                    } else {
                        TextField("Type here", text: $customText)
                            .foregroundColor(.black)
                            .padding(.horizontal) // Add horizontal padding
                            .frame(width: 85, height: 40) // Fixed width
                            .font(.system(size: 10))
                        
                    }
                }
                ZStack {
                    Circle()
                        .frame(width: 25)
                        .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                    
                    Button(action: {
                        if isPlaying {
                            stopTimer()
                        } else {
                            startTimer()
                        }
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "stop.fill" : "play.fill")
                            .font(.system(size: 10))
                            .foregroundColor(Color.white)
                    }
                }
            }
            ZStack {
                Button {
                    newEntry.duration = Int(elapsedTime) // Assign the elapsed time to the new entry's duration
                    print(newEntry)
                    entryManager.entries.append(newEntry)
                    entryManager.saveEntriesToUserDefaults()
                    newEntry = PracticeEntry(duration: 0, songTitle: "", feedback: "", notes: "")
                    elapsedTime = 0 // Reset the elapsed time after adding the entry
                } label: {
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
        .padding(8)
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        self.selectedImage = selectedImage
    }
    
    func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            elapsedTime += 1
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}


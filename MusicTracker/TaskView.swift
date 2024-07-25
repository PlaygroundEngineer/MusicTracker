import SwiftUI

struct TaskView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @Binding var newEntry: PracticeEntry
    @ObservedObject var entryManager: EntryManager
    @State private var timer: Timer? = nil
    @State private var isPlaying: Bool = false
    @State private var elapsedTime: TimeInterval = 0
    
    var body: some View {
        HStack(spacing: 10) { // Adjusted spacing for better proportion
            // Image Picker Section
            ZStack {
                Circle()
                    .frame(width: 40) // Increased size
                    .foregroundColor(selectedImage == nil ? Color(hex: CustomColors.black) : Color(hex: CustomColors.white))
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Image(systemName: selectedImage == nil ? "camera" : "checkmark")
                        .font(.system(size: 24)) // Increased font size
                        .foregroundColor(selectedImage == nil ? Color(hex: CustomColors.white) : Color(hex: CustomColors.black))
                }
                .padding(8)
                .sheet(isPresented: $isImagePickerPresented, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage)
                }
            }
            
            // Timer Section
            ZStack(alignment: .leading) {
                ZStack {
                    RoundedRectangle(cornerRadius: 30) // Increased corner radius
                        .frame(width: 170, height: 40) // Increased size
                        .foregroundColor(Color(hex: CustomColors.white))
                    Text(formatElapsedTime(elapsedTime))
                        .foregroundColor(Color(hex: CustomColors.black))
                        .padding(.horizontal)
                        .frame(width: 170, height: 40, alignment: .center) // Increased size
                        .font(.system(size: 20)) // Increased font size
                }
                ZStack {
                    Circle()
                        .frame(width: 40) // Increased size
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
                            .font(.system(size: 20)) // Increased font size
                            .foregroundColor(Color(hex: CustomColors.white))
                    }
                }
            }
            
            // Add Button Section
            ZStack {
                Button {
                    if !newEntry.songTitle.isEmpty || !newEntry.notes.isEmpty || !newEntry.feedback.isEmpty {
                        newEntry.duration = formatElapsedTime(elapsedTime)
                        newEntry.imageData = selectedImage?.jpegData(compressionQuality: 1.0)
                        newEntry.colorHex = entryManager.getSequentialColor()
                        entryManager.entries.append(newEntry)
                        entryManager.saveEntriesToUserDefaults()
                        selectedImage = nil
                        elapsedTime = 0
                        stopTimer()
                        newEntry = PracticeEntry(imageData: nil, duration: "", songTitle: "", feedback: "", notes: "", colorHex: entryManager.getSequentialColor())
                    }
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 100, height: 40) // Increased size
                            .cornerRadius(30) // Increased corner radius
                            .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                        
                        Text("Add ->")
                            .font(.system(size: 20)) // Increased font size
                            .foregroundColor(Color(hex: CustomColors.white))
                    }
                }
            }
        }
        .frame(width: UIScreen.width * 0.9, alignment: .center) // Adjusted width for proportion
        .padding(.vertical, 40)
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
    
    func formatElapsedTime(_ elapsedTime: TimeInterval) -> String {
        let hours = Int(elapsedTime) / 3600
        let minutes = (Int(elapsedTime) % 3600) / 60
        let seconds = Int(elapsedTime) % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}


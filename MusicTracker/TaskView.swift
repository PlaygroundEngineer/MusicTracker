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
                        Text(formatElapsedTime(elapsedTime))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .frame(width: 85, height: 40)
                            .font(.system(size: 10))
                    } else {
                        Text(formatElapsedTime(elapsedTime))
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .frame(width: 85, height: 40)
                            .font(.system(size: 10))
                        
                        /* TextField("Type here", text: $customText)
                            .foregroundColor(.black)
                            .padding(.horizontal)
                            .frame(width: 85, height: 40)
                            .font(.system(size: 10))
                        */
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
                    newEntry.duration = formatElapsedTime(elapsedTime)
                    newEntry.imageData = selectedImage?.jpegData(compressionQuality: 1.0)
                    newEntry.colorHex = entryManager.getSequentialColor()
                    entryManager.entries.append(newEntry)
                    entryManager.saveEntriesToUserDefaults()
                    selectedImage = nil
                    elapsedTime = 0
                    newEntry = PracticeEntry(imageData: nil, duration: "00:00:00", songTitle: "", feedback: "", notes: "", colorHex: entryManager.getSequentialColor())
                    stopTimer()
                    isPlaying = false
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
    
    func formatElapsedTime(_ time: TimeInterval) -> String {
        let seconds = Int(time) % 60
        let minutes = (Int(time) / 60) % 60
        let hours = (Int(time) / 3600) % 24
        
        // Format each component to always have two digits
        let hoursString = String(format: "%02d", hours)
        let minutesString = String(format: "%02d", minutes)
        let secondsString = String(format: "%02d", seconds)
        
        // Combine them into the final string
        let timeString = "\(hoursString):\(minutesString):\(secondsString)"
        
        return timeString
    }
}


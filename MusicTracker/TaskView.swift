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
                    .foregroundColor(selectedImage == nil ? Color(hex: CustomColors.black) : Color(hex: CustomColors.cream))
                Button(action: {
                    isImagePickerPresented.toggle()
                }) {
                    Image(systemName: selectedImage == nil ? "camera" : "checkmark")
                        .font(.system(size: 10))
                        .foregroundColor( selectedImage == nil ? Color(hex: CustomColors.cream) : Color(hex: CustomColors.black))
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
                            .foregroundColor(Color(hex: CustomColors.black))
                            .padding(.horizontal) // Add horizontal padding
                            .frame(width: 85, height: 40) // Fixed width
                            .font(.system(size: 10))
                    } else {
                        TextField("Type here", text: $customText)
                            .foregroundColor(Color(hex: CustomColors.black))
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
                            .foregroundColor(Color(hex: CustomColors.cream))
                    }
                }
            }
            
            ZStack {
                Button {
                    newEntry.duration = Int(elapsedTime)
                    newEntry.imageData = selectedImage?.jpegData(compressionQuality: 1.0)
                    newEntry.colorHex = entryManager.getSequentialColor()
                    entryManager.entries
                        .append(newEntry)
                    entryManager.saveEntriesToUserDefaults()
                    selectedImage = nil
                    elapsedTime = 0
                    newEntry = PracticeEntry(imageData: nil, duration: 0, songTitle: "", feedback: "", notes: "", colorHex: entryManager.getSequentialColor())
                } label: {
                    ZStack {
                        Rectangle()
                            .frame(width: 60, height: 25)
                            .cornerRadius(25)
                            .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                        
                        Text("Add ->")
                            .font(.system(size: 10))
                            .foregroundColor(Color(hex: CustomColors.cream))
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

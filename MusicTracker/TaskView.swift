/*import SwiftUI
struct TaskView: View {
    @EnvironmentObject var entryManager: EntryManager
    @Binding var newEntry: PracticeEntry
    var body: some View {
        HStack {
            ZStack {
                
                Circle()
                    .frame(width: 25)
                    .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                Image(systemName: "camera")
                    .font(.system(size: 10))
                    .foregroundColor(Color.white)
            }
            
            ZStack {
                Circle()
                    .frame(width: 25)
                    .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                Image(systemName: "calendar")
                    .font(.system(size: 10))
                    .foregroundColor(Color.white)
            }
            
            ZStack(alignment: .leading) {
                ZStack {
                    Rectangle()
                        .frame(width: 110, height: 25)
                        .cornerRadius(25)
                        .foregroundColor(Color.white)
                    
                    Text("  25 minutes")
                        .font(.system(size: 10))
                }
                
                ZStack {
                    Circle()
                        .frame(width: 25)
                        .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color.white)
                }
            }
            
            ZStack {
                Button("", action: {
                    entryManager.entries.append(newEntry)
                    entryManager.saveEntriesToUserDefaults()
                    newEntry = PracticeEntry(date: Date(), duration: 25, songTitle: "", feedback: "", notes: "")
                })
                
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
*/

import SwiftUI

struct TaskView: View {
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    @Binding var newEntry: PracticeEntry
    
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
                    Rectangle()
                        .frame(width: 110, height: 25)
                        .cornerRadius(25)
                        .foregroundColor(Color.white)
                    
                    Text("  25 minutes")
                        .font(.system(size: 10))
                }
                
                ZStack {
                    Circle()
                        .frame(width: 25)
                        .foregroundColor(Color(hex: CustomColors.black, opacity: 1))
                    Image(systemName: "play.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color.white)
                }
            }
            
            ZStack {
                Button {
                    print(newEntry)
                    //let imageData = selectedImage?.jpegData(compressionQuality: 1.0)
                    entryManager.entries
                        .append(newEntry)
                    entryManager.saveEntriesToUserDefaults()
                    newEntry = PracticeEntry(duration: 0, songTitle: "", feedback: "", notes: "")
                }label: {
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
       // .padding()
        //.frame(maxWidth: .infinity, alignment: .center)
      //  .offset(y: -UIScreen.height * 0.17)
    
    func loadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        self.selectedImage = selectedImage
    }
}


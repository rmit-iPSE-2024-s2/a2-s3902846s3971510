import SwiftUI
import UIKit


/**
 A SwiftUI wrapper for `UIImagePickerController` that allows users to select an image from their photo library.
 
 The `ImagePicker` integrates UIKit's `UIImagePickerController` into a SwiftUI view, making it possible to select images within a SwiftUI app. 
 
 It uses `UIViewControllerRepresentable` to manage the UIKit controller lifecycle and handles the image selection via delegation.
 */


struct ImagePicker: UIViewControllerRepresentable {
    
    /// A binding to the selected `UIImage`, which will store the image chosen by the user.
    @Binding var selectedImage: UIImage?
    
    /// An environment value that provides a dismiss action for dismissing the view.
    @Environment(\.dismiss) var dismiss

    /**
     Creates the `UIImagePickerController` that will be presented.
     
     This function is required by `UIViewControllerRepresentable` and is responsible for creating the UIKit view controller that is managed by SwiftUI.
     
     - Parameter context: The context that provides the coordinator object for the `UIImagePickerController`.
     - Returns: A configured `UIImagePickerController` instance.
     */
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator  // Set the coordinator as the delegate
        return picker
    }

    /**
     Updates the `UIImagePickerController` when the SwiftUI state changes.
     
     - Parameters:
       - uiViewController: The current `UIImagePickerController` instance.
       - context: The context that provides the coordinator object.
     */
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        // No update logic needed for this use case
    }

    /**
     Creates the coordinator that acts as the delegate for `UIImagePickerController`.
     
     The coordinator handles interactions between UIKit and SwiftUI, such as responding to image selection and dismissal.
     
     - Returns: A `Coordinator` instance that handles the delegate methods for `UIImagePickerController`.
     */
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    /**
     The `Coordinator` class acts as the delegate for the `UIImagePickerController`, handling image selection and cancellation events.
     */
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        
        /// A reference to the parent `ImagePicker` instance.
        let parent: ImagePicker

        /**
         Initializes the coordinator with a reference to the parent `ImagePicker`.
         
         - Parameter parent: The parent `ImagePicker` instance.
         */
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        /**
         Called when the user selects an image.
         
         This method is triggered when the user finishes picking an image. It retrieves the selected image and assigns it to the `selectedImage` binding in the `ImagePicker` view.
         
         - Parameters:
           - picker: The `UIImagePickerController` instance.
           - info: A dictionary containing the original image selected by the user.
         */
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.selectedImage = uiImage
            }
            parent.dismiss()  // Dismiss the image picker
        }

        /**
         Called when the user cancels the image picking process.
         
         This method is triggered when the user taps the cancel button, and it dismisses the `UIImagePickerController`.
         
         - Parameter picker: The `UIImagePickerController` instance.
         */
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()  // Dismiss the image picker
        }
    }
}

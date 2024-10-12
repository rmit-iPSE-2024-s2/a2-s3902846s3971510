import Foundation
import SwiftData

@Model
class SavedRoutine {
    var name: String
    var imageName: String
    var time: String
    var workoutDescription: String

    init(name: String, imageName: String, time: String, workoutDescription: String) {
        self.name = name
        self.imageName = imageName
        self.time = time
        self.workoutDescription = workoutDescription
    }
    
    
}

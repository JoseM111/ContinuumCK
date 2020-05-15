import Foundation
import CloudKit
import UIKit.UIImage

// MARK: _@class Post
class Post {
    // MARK: _@Properties
    var photoData: Data?//A byte buffer in memory.
    var timestamp: Date
    var caption: String
    var numberOfComments: Int
    var listOfComments: [Comment]
    let recordID: CKRecord.ID

    // MARK: _@Computed-Properties 👾
    /**©-------------------------------------------©*/
    var photo: UIImage? {
        get {
            guard let photoData = photoData else { return nil }
            return UIImage(data: photoData)
        }
        set { photoData = newValue?.jpegData(compressionQuality: 0.5) }
    }

    var imageAsset: CKAsset? {
        get {
            let tempDirectory = NSTemporaryDirectory()
            let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
            let fileURL = tempDirecotryURL.appendingPathComponent(recordID.recordName).appendingPathExtension("jpg")

            do {
                try photoData?.write(to: fileURL)
            } catch {
                print("Error writing to temporary URL \(error) \(error.localizedDescription)")
            }
            return CKAsset(fileURL: fileURL)
        }
    }
    /**©-------------------------------------------©*/

    init(photo: UIImage?, timestamp: Date = Date(), caption: String, comments: [Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), numberOfComments: Int = 0) {
        self.timestamp = timestamp
        self.caption = caption
        self.numberOfComments = numberOfComments
        self.comments = comments
        self.recordID = recordID
        self.photo = photo
    }
}// END OF CLASS
/**©-------------------------------------------©*/

import UIKit
import CloudKit

/*-----------------------------------------------------------
 var photoData: Data?//A byte buffer in memory.
    var timestamp: Date
    var caption: String
    var comments: [Comment]
-----------------------------------------------------------*/
extension Post {
    // Failable init
    convenience init?(ckRecord: CKRecord) {
        guard let timestamp = ckRecord[PostKeys.TimestampKey] as? Date,
              let caption = ckRecord[PostKeys.CaptionKey] as? String,
              let numberOfComments = ckRecord[PostKeys.CommentCountKey] as? Int
                else { return nil }

        var postPhoto: UIImage?
        
        if let photoAsset = ckRecord[PostKeys.PhotoKey] as? CKAsset {
            do {
                guard let url = photoAsset.fileURL else {return nil}
                let data = try Data(contentsOf: url)
                postPhoto = UIImage(data: data)
            } catch {
                print("Could not transfrom asset to data.")
            }
        }

        self.init(photo: postPhoto, timestamp: timestamp, caption: caption, comments: [], recordID: ckRecord.recordID, numberOfComments: numberOfComments)
    }
}// End of @extension Post

extension CKRecord {
    
    convenience init(post: Post) {
        
        self.init(recordType: PostKeys.RecordKey, recordID: post.recordID)
        
        self.setValuesForKeys([
            PostKeys.CaptionKey : post.caption,
            PostKeys.TimestampKey : post.timestamp,
            PostKeys.CommentCountKey : post.numberOfComments
        ])
        
        if let postPhoto = post.imageAsset {
            self.setValue(postPhoto, forKey: PostKeys.PhotoKey)
        }
    }
}//End of extension CKRecord

// MARK: _@Comment-CKRecord
/**©------------------------------------------------------------------------------©*/
extension Comment {

    convenience init?(ckRecord: CKRecord) {
        guard let text = ckRecord[CommentKeys.TextKey] as? String,
              let timestamp = ckRecord[CommentKeys.TimestampKey] as? Date else { return nil }

        let postReference = ckRecord[CommentKeys.PostReferenceKey] as? CKRecord.Reference

        self.init(text: text, timestamp: timestamp, recordID: ckRecord.recordID, postReference: postReference)
    }
}//End of extension

extension CKRecord {

    convenience init(comment: Comment) {

        self.init(recordType: CommentKeys.RecordTypeKey, recordID: comment.recordID)

        self.setValuesForKeys([
            CommentKeys.TextKey : comment.text,
            CommentKeys.TimestampKey : comment.timestamp
        ])

        if let reference = comment.postReference {
            self.setValue(reference, forKey: CommentKeys.PostReferenceKey)
        }
    }
}
/**©------------------------------------------------------------------------------©*/

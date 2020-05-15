import UIKit
import CloudKit

class Comment {
    // MARK: _@Properties
    let text: String
    let timestamp: Date
    let recordID: CKRecord.ID
    var postReference: CKRecord.Reference?

    init(text: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), postReference: CKRecord.Reference?) {
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
        self.postReference = postReference
    }
}

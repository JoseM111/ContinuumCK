import UIKit
import CloudKit

class PostModelController {
    // MARK: _@Shared instance
    static let shared = PostModelController()

    // MARK: _@Properties
    var listOfPost: [Post] = []
    let publicDB = CKContainer.default().publicCloudDatabase
    private init() {
//        subscribeToNewPosts(completion: nil)
    }

    // MARK: _@CRUD
        /**©------------------------------------------------------------------------------©*/

        // MARK: -CREATE Add method signatures
        func addCommentWith(text: String, post: Post, completion: @escaping (Result<Comment?, PostError>) -> Void) {

            // - reference to use to create a new post
            let reference = CKRecord.Reference(recordID: post.recordID, action: .none)
            let comment = Comment(text: text, postReference: reference)
            let record = CKRecord(comment: comment)

            post.listOfComments.append(comment)

            publicDB.save(record) { (record, error) in
                if let error = error {
                    return printf("\(error.localizedDescription) \(error) in function: \(#function)")
                }

                guard let record = record,
                      let comments = Comment(ckRecord: record) else { return completion(.failure(.noRecord)) }

                self.incrementCommentCount(for: post, completion: nil)
                completion(.success(comments))
            }
        }

    func createPostWith(photo: UIImage, caption: String, completion: @escaping (Result<Post?, PostError>) -> Void) {

        let post = Post(photo: photo, caption: caption)
        self.listOfPost.append(post)

        let record = CKRecord(post: post)

        publicDB.save(record) { (record, error) in
            if let error = error {
                return printf("\(error.localizedDescription) \(error) in function: \(#function)")
            }

            guard let record = record,
                  let post = Post(ckRecord: record) else {  return completion(.failure(.noPost)) }

            completion(.success(post))
        }
    }

    /// READ() if we have data to read
    func fetchPost(completion: @escaping (Result<[Post]?, PostError>) -> Void) {

        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostKeys.RecordKey, predicate: predicate)

        publicDB.perform(query, inZoneWith: nil) { records, error in
            if let error = error {
                return printf("\(error.localizedDescription) \(error) in function: \(#function)")
            }

            guard let records = records else { return completion(.failure(.noRecord)) }
            let posts = records.compactMap { Post(ckRecord: $0) }

            self.listOfPost = posts
            completion(.success(posts))
        }
    }

    func fetchComments(for post: Post, completion: @escaping (Result<[Comment]?, PostError>) -> Void) {
        let postRef = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentKeys.PostReferenceKey, postRef)
        
        let commentIDS = post.listOfComments.compactMap { $0.recordID }
        let childPredicate = NSPredicate(format: "NOT(recordID IN %@)", commentIDS)
        let predicateWithChild = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, childPredicate])
        
        let query = CKQuery(recordType: "Comment", predicate: predicateWithChild)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                printf("\(error.localizedDescription) \(error) in function: \(#function)")
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.noRecord)) }
            let comments = records.compactMap { Comment(ckRecord: $0) }
            
            post.listOfComments.append(contentsOf: comments)
            completion(.success(comments))
        }
    }


// MARK: -UPDATE Add method signatures
        func incrementCommentCount(for post: Post, completion: ((Bool)-> Void)?) {
            post.numberOfComments = post.listOfComments.count
            let modifyOperation = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
            
            modifyOperation.savePolicy = .changedKeys
            modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
                if let error = error {
                    printf("\(error.localizedDescription) \(error) in function: \(#function)")
                    completion?(false)
                    return
                } else {
                    completion?(true)
                }
            }
            publicDB.add(modifyOperation)
        }

        // MARK: -DELETE Add method signatures
        func delete() {
            // You need to remove the object from your source of truth
            // You access it through your shared static instance singleton
            // from our MOC Use your subclassed NSManagedObject
        }
    /**©------------------------------------------------------------------------------©*/
    // MARK: Methods
    func subscribeToNewPosts(completion: @escaping ((Bool, Error?) -> Void)) {
        let predicate = NSPredicate(value: true)
        let record = CKQuerySubscription(recordType: "Post", predicate: predicate, subscriptionID: "AllPost", options: CKQuerySubscription.Options.firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.alertBody = "New post added to Continuum"
        
        notificationInfo.shouldBadge = true
        notificationInfo.shouldSendContentAvailable = true
        record.notificationInfo = notificationInfo
        
        publicDB.save(record) { (record, error) in
            if let error = error {
                printf("\(error.localizedDescription) \(error) in function: \(#function)")
                completion(false, error)
                return
            } else {
                completion(true, error)
            }
        }
    }
    
    func addSubscriptionTo(commentsForPost post: Post, completion: ((Bool, Error?) -> ())?) {
        let postRecordID = post.recordID
        let predicate = NSPredicate(format: "%K = %@", CommentKeys.PostReferenceKey, postRecordID)
        
        let record = CKQuerySubscription(recordType: "Comment", predicate: predicate, subscriptionID: post.recordID.recordName, options: CKQuerySubscription.Options.firesOnRecordCreation)
        
        let notificationInfo = CKSubscription.NotificationInfo()
        notificationInfo.title = "New Comment"
        notificationInfo.alertBody = "A new comment was added"
        notificationInfo.soundName = "Default"
        notificationInfo.shouldSendContentAvailable = true
        notificationInfo
        
    }

}

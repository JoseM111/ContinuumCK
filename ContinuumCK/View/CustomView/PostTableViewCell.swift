import UIKit

class PostTableViewCell: UITableViewCell {
    // MARK: _@IBOutlet
    @IBOutlet weak var postPhotoImage: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var numberOfCommentsLabel: UILabel!
    
    // MARK: @Property to access our Post properties
    // & bind them with our @IBOutlet
    var post: Post? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: _@updateViews
    /**©---------------------------------------------©*/
    func updateViews() {
        postPhotoImage.image = post?.photo
        captionLabel.text = post?.caption
        numberOfCommentsLabel.text = "\(String(describing: post?.comments))"
    }
    /**©---------------------------------------------©*/
}// END OF CLASS

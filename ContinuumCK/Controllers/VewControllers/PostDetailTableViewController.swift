import UIKit

class PostDetailTableViewController: UITableViewController {
    // MARK: _@IBOutlet
    /**©---------------------------------------------©*/
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var followPostBtn: UIButton!
    @IBOutlet weak var btnStackView: UIStackView!
    
    //MARK: - Properties
    var post: Post?{
        didSet{
            loadViewIfNeeded()
            //            updateViews()
        }
    }
    /**©---------------------------------------------©*/

    override func viewDidLoad() {
        super.viewDidLoad()

    
    }
    
    // MARK: _@IBAction
    /**©---------------------------------------------©*/
    @IBAction func commentBtnTapped(_ sender: UIButton) {
        presentCommentAlertController()
    }

    @IBAction func shareBtnTapped(_ sender: UIButton) {
        guard let comment = post?.caption else { return }
        /*-----------------------------------------------------------
        let shareSheet = UIActivityViewController:--?
        It is your responsibility to present and dismiss the view
        controller using the appropriate means for the given device
        idiom. On iPad, you must present the view controller in a
        popover. On other devices, you must present it modally.
        -----------------------------------------------------------*/
        let shareActivity = UIActivityViewController(activityItems: [comment], applicationActivities: nil)
        present(shareActivity, animated: true)
    }
    
    @IBAction func followBtnTapped(_ sender: UIButton) {
        guard let post = post else { return }
        
        PostModelController.shared
    }
    /**©---------------------------------------------©*/

    // MARK: -Methods
    private func presentCommentAlertController() {
        let alertController = UIAlertController(title: "Add a new comment", message: "This better be good...", preferredStyle: .alert)

        alertController.addTextField { textField in
            textField.placeholder = "Insert comment..."
        }
        // Create cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Create comment action
        let commentAction = UIAlertAction(title: "Add Comment", style: .default) { (_) in 
            guard let commentTxt = alertController.textFields?.first?.text, !commentTxt.isEmpty,
                  let post = self.post else { return }

            PostModelController.shared.addCommentWith(text: commentTxt, post: post) { (comment) in  }
            self.tableView.reloadData()
        }

        alertController.addAction(cancelAction)
        alertController.addAction(commentAction)

        self.present(alertController, animated: true)
    }

    // MARK: - Table view data source
    /**©------------------------------------------------------------------------------©*/
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    /**©------------------------------------------------------------------------------©*/
}// END OF CLASS

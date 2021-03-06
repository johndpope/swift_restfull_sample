
import UIKit

class UserDetailEditViewController: UIViewController, UserDetailEditTableViewControllerDelegate{
    
    @IBOutlet var buttonSave: UIBarButtonItem!
    var tableDetail = UserDetailEditTableViewController()
    var user: User!
    var utilNetwork = UtilNetwork.sharedInstance
    var utilViewController = UtilViewController.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Edit"
        addButtonSideRight(buttonSave)
    }
    
    func addButtonSideRight(button: UIBarButtonItem) {
        var array = [UIBarButtonItem]()
        array.append(button)
        self.navigationItem.rightBarButtonItems = array
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.destinationViewController.isKindOfClass(UserDetailEditTableViewController){
            self.tableDetail = segue.destinationViewController as! (UserDetailEditTableViewController)
            self.tableDetail.user = user
            self.tableDetail.delegate = self
        }
    }
    
    @IBAction func touchButtonSave(sender: AnyObject) {
        putEditUser(user)
    }
    
    @IBAction func touchButtonDelete(sender: AnyObject) {
        deleteUser(user)
    }
    
    // MARK: - Call Ws Delete and Put
    
    func deleteUser(user: User) {
        if utilNetwork.isNetworkAvailable() {
            utilViewController.showActivityIndicator("deleting user...")
            RestClient.deleteUser(user.id) { result in
                self.utilViewController.hideActivityIndicator()
                if (result.response?.statusCode < 200 || result.response?.statusCode >= 300)
                {
                    self.utilViewController.showMessage(self, message: result.result.value!.error!.errorMessage())
                } else {
                    self.utilViewController.showMessage(self, message: "User deleted with success!", okHandler: {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }
            }
        } else {
            utilViewController.showMessage(self, message:"We don't have internet. Please connect and try again :(")
        }
    }
    
    func putEditUser(user: User) {
        if utilNetwork.isNetworkAvailable() {
            utilViewController.showActivityIndicator("Update user...")
            RestClient.putEditUser(user) { result in
                self.utilViewController.hideActivityIndicator()
                if (result.response?.statusCode < 200 || result.response?.statusCode >= 300)
                {
                    self.utilViewController.showMessage(self, message: result.result.value!.error!.errorMessage())
                } else {
                    self.utilViewController.showMessage(self, message: "User edited with success!", okHandler: {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }
            }
        } else {
            utilViewController.showMessage(self, message: "Network not available :(")
        }
    }
    
    // MARK: - Delegate table
    func UserDetailEditTableViewControllerCellTextDesc(desc: String) {
        user.description = desc
    }
    
    func UserDetailEditTableViewControllerCellTextEmail(email: String) {
        user.email = email
    }
    
    func UserDetailEditTableViewControllerCellTextName(name: String) {
        user.name = name
    }
}

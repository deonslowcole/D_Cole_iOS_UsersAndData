//Deonslow Cole
//Cross Platform MD-1705
//ViewController

import UIKit
import Firebase

class ViewController: UIViewController {
    
    //Declare outlets for the views
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInView: UIView!
    @IBOutlet weak var homeNavBar: UINavigationBar!
    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var signOutLabel: UILabel!
    
    //Declare a varable to hold the listener for when the user signs in and out
    var handle: FIRAuthStateDidChangeListenerHandle?
    
    //Declare variable to hold the users email
    var userEmail: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set the outlet for the log in view to hidden
        logInView.isHidden = true
        
        //Declare a constant for the tap gesture that will be associated with the log out label. Set the user interaction and add the action to the label.
        let tapSignOut = UITapGestureRecognizer(target: self, action: #selector(ViewController.signOut(sender:)))
        signOutLabel.isUserInteractionEnabled = true
        signOutLabel.addGestureRecognizer(tapSignOut)
        
        //Set a constant to ge the current user
        let user = FIRAuth.auth()?.currentUser
        
        //Use optional binding to set the users email to the variable
        if let user = user {
            
            userEmail = user.email!
        }
        
        //Set the text of the the labels on the log in view
        helloLabel.text = "Hello, " + userEmail
        signOutLabel.text = "Not " + userEmail + "? Click here to log out."
        
    }
    
    //Check when the user has signed in and get the user
    override func viewWillAppear(_ animated: Bool) {
        handle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            //If there is a user set let the log in view appear
            if user != nil {
                let userEmail = user?.email!
                self.logInView.isHidden = false
                
                //Set the labels
                self.helloLabel.text = "Hello, " + userEmail!
                self.signOutLabel.text = "Not " + userEmail! + "? Click here to log out."
            
            } else {
                
                //If there isn't a user signed in hide the log in view
                self.logInView.isHidden = true
            }
            
        })
    }
    
    //Check if the user has signed out
    override func viewWillDisappear(_ animated: Bool) {
        FIRAuth.auth()?.removeStateDidChangeListener(handle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Actions
    
    //Action method for creating a user account to the database
    @IBAction func createAccount(_ sender: Any) {
        
        //Set constants for the email and password text fields
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        //Check to see if the text fields are empty
        if email == "" || password == ""{
            
            //If they are empty call teh method to show the alert about them being empty
            showEmptyAlert()
        
        } else {
            
            //If they aren't empty create a user using their email and password
            FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                
                //If there is no error
                if error == nil {
                    print("YOUR ARE REGISTERED")
                    
                } else {
                    
                    //If there is an error call the method to show the alert
                    self.showErrorAlert(error: error)
                    print("YOU ARE NOT REGISTERED")
                }
            })
        }
    }
    
    //Action method for the user to log into their account
    @IBAction func logInAccount(_ sender: Any) {
        
        //Set constants for the email and password text fields
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        //If the text fields are empty call the method to show the alert
        if email == "" || password == ""{
            
            showEmptyAlert()
            
        } else {
            
            //If not sign the user in with their email and password and clear the text fields
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    
                } else {
                    
                    //if there is an error show the error alert
                    self.showErrorAlert(error: error)
                }
            })
        }
    }
    
    
    //MARK: - Functions
    //Method to show the alert when there are empty text fields
    func showEmptyAlert(){
        
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        
    }
    
    //Method when there is an error when the user is signing in
    func showErrorAlert(error: Error?) {
        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    //Method for when the user is signing out
    func signOut(sender: UITapGestureRecognizer) {
        
        let fbAuth = FIRAuth.auth()
        do{
            try fbAuth?.signOut()
            logInView.isHidden = true
    
        } catch let signOutError as NSError {
            
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    //Method for the user to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
    }


}


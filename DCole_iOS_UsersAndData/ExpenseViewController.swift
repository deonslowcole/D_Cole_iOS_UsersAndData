//Deonslow Cole
//Cross Platform MD-1705
//ExpenseViewController



import UIKit
import Firebase

class ExpenseViewController: UIViewController {
    
    //Declare variables to hold the outlets
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    //Declare global variables
    var location: String = ""
    var amount: Double = 0.0
    var date: String = ""
    var userId: String = ""
    
    //Declare a variable to hold the reference to the database
    var dbRef: FIRDatabaseReference!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Declare a variable to hold the current user
        let user = FIRAuth.auth()?.currentUser
        
        //Use optional binding to get the user's id
        if let user = user {
            
            userId = user.uid
            print("THE USER ID IS " + userId)
        }
        
        //Set the database reference to the child node of the inquired database
        dbRef = FIRDatabase.database().reference().child("user_expenses").child(userId)
        
        //Call the method to read the database
        readDatabase()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Call the method to read teh database
        readDatabase()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: - Actions

    //Action method for when the user logs out
    @IBAction func logOut(_ sender: Any) {
        
        //Declare a constant to hold the authorization to the database. Sign the user out and do to the home screen.
        let fbAuth = FIRAuth.auth()
        do{
            try fbAuth?.signOut()
            let homeVc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
            self.present(homeVc!, animated: true, completion: nil)
            
        } catch let signOutError as NSError {
            
            print("Error signing out: %@", signOutError)
        }
        
    }
    
    //Action method to delete from the database. Set the value to nil and reset all of the variables and text fields. Call the method to read from the database
    @IBAction func deleteExpense(_ sender: Any) {
        dbRef.setValue(nil)
        location = ""
        amount = 0.0
        date = ""
        locationLabel.text = ""
        amountLabel.text = ""
        dateLabel.text = ""
        
        readDatabase()
    }
    
    
    
    //MARK: - Functions
    //Method to read from teh database
    func readDatabase() {
        
        //Read from the database reference using the observeSingleEvent method
        dbRef.observeSingleEvent(of: .value, with: { (FIRDataSnapshot) in
            
            //Check if the reference has children. If so set the variables to the values in the database.
            if FIRDataSnapshot.hasChildren(){
                let expense = FIRDataSnapshot.value as? NSDictionary
                self.location = (expense?["exLocation"] as? String)!
                self.amount = (expense?["exAmount"] as? Double)!
                self.date = (expense?["exDate"] as? String)!
                
                self.locationLabel.text = self.location
                self.amountLabel.text = "$" + String(self.amount)
                self.dateLabel.text = self.date
                
            } else {
                
                //If it doesn't have children set the labels
                self.locationLabel.text = ""
                self.amountLabel.text = "No expense logged."
                self.dateLabel.text = ""
            }
         
            //If there aren't any values disable the delete button. if there are enable it.
            if self.location == "" || self.amount == 0.0 || self.date == ""{
                self.deleteButton.isEnabled = false
                self.deleteButton.alpha = 0.5
                
            } else {
                self.deleteButton.isEnabled = true
                self.deleteButton.alpha = 1.0
            }
        })
        
    }

}

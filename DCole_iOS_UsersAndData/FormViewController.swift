//Deonslow Cole
//Cross Platform MD-1705
//FormViewController


import UIKit
import Firebase

class FormViewController: UIViewController {
    
    //Declare variables to hold the textfields
    @IBOutlet weak var businessNameTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    
    //Declare a variable to hold the reference to the database
    var dbRef: FIRDatabaseReference!
    
    //Declare a vaiable to hold the userid
    var userId: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        //Declare a variable to hold the current user
        let user = FIRAuth.auth()?.currentUser
        
        //Use optional binding to get the user's userid
        if let user = user {
            
            userId = user.uid
            print(userId)
        }
        
        //Reference the database using the top child node
        dbRef = FIRDatabase.database().reference().child("user_expenses")
        
        //Delcare a constant for the date formatter. Set the date and time style
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        //Declare a constant to hold the formatted date
        let dateString = formatter.string(from: Date())
        
        //Set the date textfield text equal to the date constant
        dateTextField.text = dateString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Actions

    //Action method for when the user saves the entered data
    @IBAction func saveExpense(_ sender: Any) {
        
        //Declare constants for the text fields
        let bName = businessNameTextField.text
        let bAmount: Double = Double(amountTextField.text!)!
        let bDate = dateTextField.text
        
        //Check the values of the constants. If they are empty show an alert
        if bName == "" || bAmount < 0.0 || bDate == ""{
            
            let titleString = NSAttributedString(string: "Error", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName: UIColor.red])
            let alertController = UIAlertController(title: "", message: "Please fill out all fields", preferredStyle: .alert)
            alertController.setValue(titleString, forKey: "attributedTitle")
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
        
        } else {
            
            //If they aren't add the values to the database that will be associated with the user.
            let exRef = dbRef.child(userId)
            let expenseArray = ["exAmount": bAmount, "exDate": bDate!, "exLocation": bName!] as [String : Any]
            exRef.setValue(expenseArray)
            
            //Go back to the expense view controller
            let expenseVc = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseVC")
            self.present(expenseVc!, animated: true, completion: nil)
            
        }
        
    }
    
    //Action method for when the user touches the cancel button.
    @IBAction func cancelEntry(_ sender: Any) {
        
        //Show an alert when the cancel button is touched. If they want to cancel go back to the expense view controller
        let alertController = UIAlertController(title: "Cancel Entry", message: "Do you want to cancel entering your new expense?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (UIAlertAction) in
            
            let expenseVc = self.storyboard?.instantiateViewController(withIdentifier: "ExpenseVC")
            self.present(expenseVc!, animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(yesAction)
        self.present(alertController, animated: true)
    }
    
    //Method for the user to dismiss the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view .endEditing(true)
    }

}

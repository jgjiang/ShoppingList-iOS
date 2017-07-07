//
//  LogInViewController.swift
//  ShoppingList
//
//  Created by Tony on 02/04/2017.
//  Copyright © 2017 Tony. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

var loginFlag = 0

class LogInViewController: UIViewController {

    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func logInAction(_ sender: Any) {
        
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            
            
            
            let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            FIRAuth.auth()?.signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                if error == nil {
                    
                    if let user = FIRAuth.auth()?.currentUser {
                        if !user.isEmailVerified{
                            let alertController = UIAlertController(title: "Error", message: "Sorry, please verify your email", preferredStyle: .alert)
                            let verifyNotificationAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            alertController.addAction(verifyNotificationAction)
                            self.present(alertController, animated: true, completion: nil)
                        
                        } else {
                            
                            print("You have successfully log in")
                            
                            //let itemViewController = self.storyboard?.instantiateViewController(withIdentifier: "itemViewController")
                            
                            //itemViewController?.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain, target: itemViewController, action: #selector(LogInViewController.logoutAction))
                            
                            loginFlag = 1
                            
                            self.dismiss(animated: true, completion: nil)
                        
                            //let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            //appDelegate.window?.rootViewController = navContoller
                            
                            
                        }
                        
                    
                    
                    
                    }
                    
                    
                } else {
                    
                   
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
        
        
    }
    
   
    
    override func touchesBegan(_: Set<UITouch>, with: UIEvent?){
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

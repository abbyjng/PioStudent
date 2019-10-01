//
//  LoginViewController.swift
//  PioStudent
//
//  Created by Abigail Ng on 4/7/19.
//  Copyright © 2019 Abigail Ng. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DatabaseReference!
    
    var handle: AuthStateDidChangeListenerHandle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        emailTextField.text = ""
        passwordTextField.text = ""
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if emailTextField.text == "" || passwordTextField.text == "" {
            let alertController = UIAlertController(title: "Please enter a valid email and password.", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            alertController.popoverPresentationController?.sourceView = (sender as! UIView)
            
            present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { [weak self] user, error in
                guard let strongSelf = self else { return }
                let user = Auth.auth().currentUser
                if user != nil {
                    let userID = Auth.auth().currentUser?.uid
                    loggedIn = true
                    currentLogin.uid = userID!
                    self!.ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
                        let value = snapshot.value as? NSDictionary
                        currentLogin.name = value?["name"] as? String ?? ""
                        currentLogin.password = (self?.passwordTextField.text)!
                        currentLogin.email = value?["email"] as? String ?? ""
                        currentLogin.phoneNumber = value?["phoneNumber"] as? String ?? ""
                        currentLogin.grade = value?["grade"] as? String ?? ""
                        if value?["nhsStudent"] as? String ?? "" == "true" {
                            currentLogin.nhsStudent = true
                        } else {
                            currentLogin.nhsStudent = false
                        }
                        if value?["tutorTutee"] as? String ?? "" == "true" {
                            currentLogin.tutorTutee = true
                        } else {
                            currentLogin.tutorTutee = false
                        }
                        
                        self!.performSegue(withIdentifier: "login", sender: nil)
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                } else {
                    let alertController = UIAlertController(title: "Invalid login", message: nil, preferredStyle: .alert)
                    
                    let cancelAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    alertController.popoverPresentationController?.sourceView = (sender as! UIView)
                    
                    self!.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancel(unwindSegue: UIStoryboardSegue) {
        
    }
    
}

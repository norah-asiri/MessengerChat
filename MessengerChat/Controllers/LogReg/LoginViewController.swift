//
//  ViewController.swift
//  MessengerAppIOS
//
//  Created by administrator on 06/01/2022.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    // ----------| LOGIN CLASS |--------------

    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    @IBAction func logInBtn(_ sender: UIButton) {
    
    // LOGIN  Firebase Login
        // Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(self!.email.text!)")
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            // if this succeeds, dismiss
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}


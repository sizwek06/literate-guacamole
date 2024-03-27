//
//  UserAccessScreenViewController.swift
//  Onews
//
//  Created by Sizwe Khathi on 2024/03/27.
//

import Foundation
import UIKit
import FirebaseAuth

class UserAccessScreenViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var userAccessViewModel = UserAcessViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAccessViewModel.delegate = self
        
        navigationItem.title = "Onews Sign In"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        registerUser()
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        // TODO: Add sign in
    }
    
    func registerUser() {
        guard let email = self.emailTextField.text,
              let password = self.passwordTextfield.text,
              let username = usernameTextField.text
        else { return }
        
        self.userAccessViewModel.registerUser(email: email, password: password, username: username)
    }
}

extension UserAccessScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
        case usernameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextfield.becomeFirstResponder()
        case passwordTextfield:
            print("Password field returns")
         registerUser()
        default:
            textField.resignFirstResponder()
        }
        return false
    }
}

extension UserAccessScreenViewController: UserAcessDelegate {
    
    func successfulRegistration(user: User, isRegistration: Bool) {
        self.dismiss(animated: true)
        print("User email: ", user.email as Any)
        print("User details: ", user.displayName as Any)
        
        // TODO: Task if registration or sign in
    }
    
    func showLoader() {
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: "Processing request, chill")
        OnewsLoaderViewController.sharedInstance.show()
    }
    
    func hideLoader() {
        OnewsLoaderViewController.sharedInstance.hide()
    }
    
    func didFailWithError(error: String, isRegistration: Bool) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Retry", style: UIAlertAction.Style.default, handler: { (_) in
            self.registerUser()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

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
    
    @IBOutlet weak var pageHeaderLabel: UILabel!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    var userAccessViewModel = UserAcessViewModel()
    public var isSignIn: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAccessViewModel.delegate = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        // TODO: Add sign in
    }
    
    func registerUser() {
        guard let email = self.emailTextField.text,
              let password = self.passwordTextfield.text
        else { return }
        
        self.userAccessViewModel.registerUser(email: email, password: password)
    }
    
    func setupView() {
        let pageText = self.isSignIn ? K.signInText : K.signUpText
        
        pageHeaderLabel.text = "Onews \(pageText)"
        signInButton.setTitle(pageText, for: .normal)
        
        signInButton.isEnabled = false
    }
    
    func checkTextfieldsContent() {
        guard let passwordFieldText = passwordTextfield.text,
        let emailFieldText = passwordTextfield.text
        else { return }
        
        signInButton.isEnabled = !passwordFieldText.isEmpty && !emailFieldText.isEmpty ? true : false
    }
}

extension UserAccessScreenViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    switch textField {
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
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case emailTextField:
            checkTextfieldsContent()
        case passwordTextfield:
            checkTextfieldsContent()
        default:
            checkTextfieldsContent()
        }
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
        OnewsLoaderViewController.sharedInstance.setDisplay(loadingText: K.loadingUserText)
        OnewsLoaderViewController.sharedInstance.show()
    }
    
    func hideLoader() {
        OnewsLoaderViewController.sharedInstance.hide()
    }
    
    func didFailWithError(error: String, isRegistration: Bool) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: K.alertRetry, style: UIAlertAction.Style.default, handler: { (_) in
            self.registerUser()
        }))
        
        alert.addAction(UIAlertAction(title: K.alertCancel, style: UIAlertAction.Style.cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

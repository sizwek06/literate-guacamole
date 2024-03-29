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
    
    var userAccessViewModel = UserAccessViewModel()
    public var isUserRegistration: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userAccessViewModel.delegate = self
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if let settingViewController = presentingViewController as? SettingsViewController {
            DispatchQueue.main.async {
                settingViewController.setUpView()
            }
        }
    }
    
    @IBAction func cancelBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "PeformAfterPresenting"), object: nil))

        authenticateUserDetails()
    }
    
    func authenticateUserDetails() {
        guard let email = self.emailTextField.text,
              let password = self.passwordTextfield.text
        else { return }
        
        if self.isUserRegistration {
            self.userAccessViewModel.signUp(email: email, password: password)
        } else {
            self.userAccessViewModel.signInUser(email: email, password: password)
        }
    }
    
    func setupView() {
        let pageText = self.isUserRegistration ?  K.signUpText : K.signInText
        
        pageHeaderLabel.text = "Onews \(pageText)"
        signInButton.setTitle(pageText, for: .normal)
        
        passwordTextfield.enablesReturnKeyAutomatically = true
        emailTextField.enablesReturnKeyAutomatically = true
        
        passwordTextfield.returnKeyType = self.isUserRegistration ? .join : .go
        
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
            authenticateUserDetails()
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case passwordTextfield:
            signInButton.isEnabled = true
        default:
            checkTextfieldsContent()
        }
    }
}

extension UserAccessScreenViewController: UserAcessDelegate {
    
    func confirmLogOut() {
    }
    
    func successfulUserSignIn(user: User, isRegistration: Bool) {
        
        guard let email = user.email else { return }
        
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.synchronize()
        
        self.dismiss(animated: true)
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
            self.authenticateUserDetails()
        }))
        
        alert.addAction(UIAlertAction(title: K.alertCancel, style: UIAlertAction.Style.cancel, handler: { (_) in
            alert.dismiss(animated: true)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

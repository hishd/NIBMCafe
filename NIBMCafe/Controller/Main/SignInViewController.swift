//
//  ViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-26.
//

import UIKit

class SignInViewController: BaseViewController {

    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        setTextDelegates()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firebaseOP.delegate = self
        networkMonitor.delegate = self
    }
    
    @IBAction func onSignInClicked(_ sender: Any) {
        
        if !InputFieldValidator.isValidEmail(txtEmail.text ?? "") {
            txtEmail.clearText()
            txtEmail.displayInlineError(errorString: InputErrorCaptions.invalidEmailAddress)
            return
        }
        
        if !InputFieldValidator.isValidPassword(pass: txtPassword.text ?? "", minLength: 6, maxLength: 20){
            txtPassword.clearText()
            txtPassword.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if !networkMonitor.isReachable {
            self.displayErrorMessage(message: FieldErrorCaptions.noConnectionTitle)
            return
        }
        
        displayProgress()
        self.firebaseOP.signInUser(email: txtEmail.text ?? "", password: txtPassword.text ?? "")
    }
}

//MARK: - Textfiled delegates to listen to return events on keyboard
extension SignInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTextDelegates(){
        txtEmail.delegate = self
        txtPassword.delegate = self
    }
}

extension SignInViewController : FirebaseActions {
    func onUserNotRegistered(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
    func onUserSignInSuccess(user: User?) {
        dismissProgress()
        if let user = user {
            self.performSegue(withIdentifier: StoryBoardSegues.launchToHomeSegue, sender: nil)
            SessionManager.saveUserSession(user)
        } else {
            displayErrorMessage(message: FieldErrorCaptions.generalizedError)
        }
    }
    func onUserSignInFailedWithError(error: Error) {
        dismissProgress()
        displayErrorMessage(message: error.localizedDescription)
    }
    func onUserSignInFailedWithError(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}


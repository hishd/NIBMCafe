//
//  SignUpViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-26.
//

import UIKit

class SignUpViewController: BaseViewController {
    
    @IBOutlet weak var txtUserName: CustomTextField!
    @IBOutlet weak var txtEmail: CustomTextField!
    @IBOutlet weak var txtPhoneNo: CustomTextField!
    @IBOutlet weak var txtPassword: CustomTextField!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    
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
    
    @IBAction func onSignInPressed(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onSignUpClicked(_ sender: UIButton) {
        
        if !InputFieldValidator.isValidName(txtUserName.text ?? "") {
            txtUserName.clearText()
            txtUserName.displayInlineError(errorString: InputErrorCaptions.invalidName)
            return
        }
        
        if !InputFieldValidator.isValidEmail(txtEmail.text ?? "") {
            txtEmail.clearText()
            txtEmail.displayInlineError(errorString: InputErrorCaptions.invalidEmailAddress)
            return
        }
        
        if !InputFieldValidator.isValidMobileNo(txtPhoneNo.text ?? "") {
            txtPhoneNo.clearText()
            txtPhoneNo.displayInlineError(errorString: InputErrorCaptions.invalidPhoneNo)
            return
        }
        
        if !InputFieldValidator.isValidPassword(pass: txtPassword.text ?? "", minLength: 6, maxLength: 20){
            txtPassword.clearText()
            txtPassword.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if !InputFieldValidator.isValidPassword(pass: txtConfirmPassword.text ?? "", minLength: 6, maxLength: 20){
            txtConfirmPassword.clearText()
            txtConfirmPassword.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if txtPassword.text ?? " " != txtConfirmPassword.text ?? "" {
            txtPassword.clearText()
            txtConfirmPassword.clearText()
            txtConfirmPassword.displayInlineError(errorString: InputErrorCaptions.passwordNotMatched)
            txtPassword.displayInlineError(errorString: InputErrorCaptions.passwordNotMatched)
            return
        }
        
        if !networkMonitor.isReachable {
            self.displayErrorMessage(message: FieldErrorCaptions.noConnectionTitle)
            return
        }
        
        displayProgress()
        self.firebaseOP.registerUser(user: User(_id: "",
                                                userName: txtUserName.text!,
                                                email: txtEmail.text!,
                                                phoneNo: txtPhoneNo.text!,
                                                password: txtPassword.text!, imageRes: ""))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

//MARK: - Textfiled delegates to listen to return events on keyboard
extension SignUpViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTextDelegates() {
        txtUserName.delegate = self
        txtEmail.delegate = self
        txtPhoneNo.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
    }
}

extension SignUpViewController : FirebaseActions {
    func isSignUpSuccessful(user: User?) {
        dismissProgress()
        if let user = user {
            displaySuccessMessage(message: "Regisration Successful!", completion: {
                SessionManager.saveUserSession(user)
                self.performSegue(withIdentifier: StoryBoardSegues.signUpToAllowLocation, sender: nil)
            })
        } else {
            displayErrorMessage(message: FieldErrorCaptions.generalizedError)
        }
    }
    func isSignUpFailedWithError(error: Error) {
        dismissProgress()
        displayErrorMessage(message: error.localizedDescription)
    }
    func isSignUpFailedWithError(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
    func isExisitingUser(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}

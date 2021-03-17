//
//  UpdatePasswordViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-06.
//

import UIKit

class UpdatePasswordViewController: BaseViewController {

    @IBOutlet weak var txtCurrentPassword: CustomTextField!
    @IBOutlet weak var txtNewPassword: CustomTextField!
    @IBOutlet weak var txtConfirmPassword: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnOnUpdateClicked(_ sender: UIButton) {
        
        if !InputFieldValidator.isValidPassword(pass: txtCurrentPassword.text ?? "", minLength: 6, maxLength: 20){
            txtCurrentPassword.clearText()
            txtCurrentPassword.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if !InputFieldValidator.isValidPassword(pass: txtNewPassword.text ?? "", minLength: 6, maxLength: 20){
            txtNewPassword.clearText()
            txtNewPassword.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if !InputFieldValidator.isValidPassword(pass: txtConfirmPassword.text ?? "", minLength: 6, maxLength: 20){
            txtConfirmPassword.clearText()
            txtConfirmPassword.displayInlineError(errorString: InputErrorCaptions.invalidPassword)
            return
        }
        
        if txtNewPassword.text ?? " " != txtConfirmPassword.text ?? "" {
            txtNewPassword.clearText()
            txtConfirmPassword.clearText()
            txtConfirmPassword.displayInlineError(errorString: InputErrorCaptions.passwordNotMatched)
            txtNewPassword.displayInlineError(errorString: InputErrorCaptions.passwordNotMatched)
            return
        }
        
        if !networkMonitor.isReachable {
            self.displayErrorMessage(message: FieldErrorCaptions.noConnectionTitle)
            return
        }
        
        guard let email = SessionManager.getUserSesion()?.email else {
            NSLog("User email is empty")
            displayErrorMessage(message: FieldErrorCaptions.updatePasswordFailed)
            return
        }
        
        displayProgress()
        firebaseOP.updateUserPassword(email: email, newPassword: txtNewPassword.text!, existingPassword: txtCurrentPassword.text!)
    }
}

extension UpdatePasswordViewController: FirebaseActions {
    func onPasswordChanged() {
        dismissProgress()
        displaySuccessMessage(message: "Password updated successfully!", completion: {
//            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
    }
    func onPasswordChangeFailedWithError(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}

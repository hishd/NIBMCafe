//
//  UpdatePasswordViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-06.
//

import UIKit

class UpdatePasswordViewController: BaseViewController {

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
    
    @IBAction func btnOnUpdateClicked(_ sender: UIButton) {
        
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
        
        displayProgress()
        firebaseOP.updateUserPassword(newPassword: txtNewPassword.text!)
    }
}

extension UpdatePasswordViewController: FirebaseActions {
    func onPasswordChanged() {
        dismissProgress()
        displaySuccessMessage(message: "Password updated successfully!", completion: {
            self.dismiss(animated: true, completion: nil)
        })
    }
    func onPasswordChangeFailedWithError(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}

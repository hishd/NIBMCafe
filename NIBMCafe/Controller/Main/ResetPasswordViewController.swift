//
//  ResetPasswordViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-05.
//

import UIKit

class ResetPasswordViewController: BaseViewController {

    @IBOutlet weak var txtEmail: CustomTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        setTextDelegates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firebaseOP.delegate = self
        networkMonitor.delegate = self
    }
    
    @IBAction func onResetPasswordPressed(_ sender: UIButton) {
        if !InputFieldValidator.isValidEmail(txtEmail.text ?? "") {
            txtEmail.clearText()
            txtEmail.displayInlineError(errorString: InputErrorCaptions.invalidEmailAddress)
            return
        }
        
        if !networkMonitor.isReachable {
            self.displayErrorMessage(message: FieldErrorCaptions.noConnectionTitle)
            return
        }
        
        displayProgress()
        self.firebaseOP.sendResetPasswordRequest(email: txtEmail.text ?? "")
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
extension ResetPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func setTextDelegates(){
        txtEmail.delegate = self
    }
}

extension ResetPasswordViewController : FirebaseActions {
    func onResetPasswordEmailSent() {
        dismissProgress()
        displaySuccessMessage(message: "Email sent, please check inbox!", completion: nil)
    }
    func onResetPasswordEmailSentFailed(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}

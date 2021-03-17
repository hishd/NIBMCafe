//
//  UpdateProfileViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-06.
//

import UIKit

class UpdateProfileViewController: BaseViewController {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var txtUserName: CustomTextField!
    @IBOutlet weak var txtPhoneNo: CustomTextField!
    
    let user = SessionManager.getUserSesion()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgProfile.generateRoundImage()
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        networkMonitor.delegate = self
        firebaseOP.delegate = self
        
        txtUserName.text = user?.userName
        txtPhoneNo.text = user?.phoneNo
    }
    
    @IBAction func onEditImagePressed(_ sender: UIButton) {
    }
    
    @IBAction func onBackPressed(_ sender: UIButton) {
//        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onUpdateProfilePressed(_ sender: UIButton) {
        if !InputFieldValidator.isValidName(txtUserName.text ?? "") {
            txtUserName.clearText()
            txtUserName.displayInlineError(errorString: InputErrorCaptions.invalidName)
            return
        }
        if !InputFieldValidator.isValidMobileNo(txtPhoneNo.text ?? "") {
            txtPhoneNo.clearText()
            txtPhoneNo.displayInlineError(errorString: InputErrorCaptions.invalidPhoneNo)
            return
        }
        
        guard var user = user else {
            NSLog("User data is empty")
            displayErrorMessage(message: FieldErrorCaptions.updateUserFailed)
            return
        }
        
        if !networkMonitor.isReachable {
            self.displayErrorMessage(message: FieldErrorCaptions.noConnectionTitle)
            return
        }
        
        user.userName = txtUserName.text
        user.phoneNo = txtPhoneNo.text
        displayProgress()
        firebaseOP.updateUser(user: user)
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

extension UpdateProfileViewController: FirebaseActions {
    func onUserDataUpdated(user: User?) {
        dismissProgress()
        SessionManager.saveUserSession(user!)
        displaySuccessMessage(message: "Profile updated successfully!", completion: {
//            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        })
    }
    func onUserUpdateFailed(error: String) {
        dismissProgress()
        displayErrorMessage(message: error)
    }
}

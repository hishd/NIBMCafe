//
//  BaseViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-05.
//

import UIKit
import Loaf

class BaseViewController: UIViewController, NetworkListener {
    
    var networkMonitor = NetworkMonitor.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    
    var progressHUD: ProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = ProgressHUD(view: view)
        // Do any additional setup after loading the view.
    }
    
    func displayProgress() {
        progressHUD.displayProgressHUD()
    }
    
    func dismissProgress() {
        progressHUD.dismissProgressHUD()
    }
    
    func displayErrorMessage(message: String) {
        Loaf(message, state: .error, sender: self).show()
    }
    
    func displaySuccessMessage(message: String) {
        Loaf(message, state: .success, sender: self).show()
    }
    
    func displayInfoMessage(message: String) {
        Loaf(message, state: .info, sender: self).show()
    }
    
    func displayWarningMessage(message: String) {
        Loaf(message, state: .warning, sender: self).show()
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

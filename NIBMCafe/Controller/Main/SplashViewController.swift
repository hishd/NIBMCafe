//
//  SplashViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-05.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.popViewController(animated: true)
        if SessionManager.authState {
            NSLog("User Session found")
            self.performSegue(withIdentifier: StoryBoardSegues.splashToHome, sender: nil)
        } else {
            NSLog("User Session not found")
            self.performSegue(withIdentifier: StoryBoardSegues.splashToSignIn, sender: nil)
        }
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

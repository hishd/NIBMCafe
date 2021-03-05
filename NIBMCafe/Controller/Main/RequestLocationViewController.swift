//
//  RequestLocationViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-26.
//

import UIKit
import CoreLocation

class RequestLocationViewController: BaseViewController {
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func onAllowLocationClicked(_ sender: Any) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .restricted, .denied, .notDetermined:
                NSLog("Location services disabled")
                displayErrorMessage(message: "Application requires location access to continue!")
            case .authorizedAlways, .authorizedWhenInUse:
                NSLog("Location services enabled")
                self.performSegue(withIdentifier: StoryBoardSegues.signUptoHomeSegue, sender: nil)
            default:
                displayErrorMessage(message: "Application requires location access to continue!")
                NSLog("Location services disabled")
            }
        } else {
            displayWarningMessage(message: "Please enable location services")
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

//
//  RequestLocationViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-02-26.
//

import UIKit
import CoreLocation


class RequestLocationViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    @IBAction func onAllowLocationClicked(_ sender: Any) {
        if checkLocationAccess() {
            self.performSegue(withIdentifier: StoryBoardSegues.allowLocationtoHomeSegue, sender: nil)
        } else {
            locationManager.requestAlwaysAuthorization()
        }
//        if CLLocationManager.locationServicesEnabled() {
//            switch locationManager.authorizationStatus {
//            case .restricted, .denied, .notDetermined:
//                NSLog("Location services disabled")
//                displayErrorMessage(message: "Application requires location access to continue!")
//            case .authorizedAlways, .authorizedWhenInUse:
//                NSLog("Location services enabled")
//                self.performSegue(withIdentifier: StoryBoardSegues.signUptoHomeSegue, sender: nil)
//            default:
//                displayErrorMessage(message: "Application requires location access to continue!")
//                NSLog("Location services disabled")
//            }
//        } else {
//            displayWarningMessage(message: "Please enable location services")
//        }
    }
    
}

extension RequestLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            self.performSegue(withIdentifier: StoryBoardSegues.allowLocationtoHomeSegue, sender: nil)
        }
    }
}

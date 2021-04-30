//
//  BaseViewController.swift
//  NIBMCafe
//
//  Created by Hishara Dilshan on 2021-03-05.
//

import UIKit
import Loaf
import CoreLocation

class BaseViewController: UIViewController, NetworkListener {
    
    var networkMonitor = NetworkMonitor.instance
    var popupAlerts = PopupAlerts.instance
    
    var firebaseOP = FirebaseOP.instance
    
    var progressHUD: ProgressHUD!
    
    let refreshControl = UIRefreshControl()
    
    var alertController: UIAlertController!
    
    let locationManager = CLLocationManager()
    
    var pickedLattitude: Double = 0
    var pickedLonglitude: Double = 0
    var locationFetchStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()
        progressHUD = ProgressHUD(view: view)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
            self.locationFetchStarted = true
        }
    }
    
    func displayProgress() {
        progressHUD.displayProgressHUD()
    }
    
    func dismissProgress() {
        progressHUD.dismissProgressHUD()
    }
    
    func displayErrorMessage(message: String) {
        Loaf(message, state: .error, sender: self).show(.custom(1.0))
    }
    
    func displaySuccessMessage(message: String, completion: (() -> Void)?) {
        Loaf(message, state: .success, sender: self).show(.custom(1.0)) {
            dismissal in
            if let completion  = completion {
                completion()
            }
        }
    }
    
    func displayInfoMessage(message: String) {
        Loaf(message, state: .info, sender: self).show(.custom(1.0))
    }
    
    func displayWarningMessage(message: String) {
        Loaf(message, state: .warning, sender: self).show(.custom(1.0))
    }
    
    func displayActionSheet(title: String, message: String, positiveTitle: String, negativeTitle: String, positiveHandler: @escaping (UIAlertAction) -> Void, negativeHandler: @escaping (UIAlertAction) -> Void) {

        alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        alertController.title = title
        alertController.message = message
        alertController.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: positiveHandler))
        alertController.addAction(UIAlertAction(title: negativeTitle, style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func checkLocationAccess() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .restricted, .denied, .notDetermined:
                NSLog("Location services disabled")
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                NSLog("Location services enabled")
                return true
            default:
                return false
            }
        } else {
            return false
        }
    }
}

extension BaseViewController : CLLocationManagerDelegate {
//    
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways || status == .authorizedWhenInUse {
//            self.performSegue(withIdentifier: StoryBoardSegues.allowLocationtoHomeSegue, sender: nil)
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            pickedLattitude = location.coordinate.latitude
            pickedLonglitude = location.coordinate.longitude
            print("Locations updated : \(location)")
            if networkMonitor.isReachable {
                firebaseOP.checkforPendingOrdersAndUpdate(email: SessionManager.getUserSesion()?.email ?? "", lat: pickedLattitude, lon: pickedLonglitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        displayErrorMessage(message: "Location error")
        print(error.localizedDescription)
    }
    
}

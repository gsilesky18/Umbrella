//
//  SettingsViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit
import CoreLocation

class SettingsViewController: UIViewController {

    @IBOutlet weak var zipCodeOuterView: UIView!
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var unitSegmentedControl: UISegmentedControl!
    @IBOutlet weak var getWeatherButton: UIButton!
    
    var mainViewController: MainViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Init blur view
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        //Insert view
        view.insertSubview(blurView, at: 0)
        //Add constraints to blur view
        blurView.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        blurView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        //TODO: Add vibrancy effect to segement and button
        
        //Round corners of input view
        zipCodeOuterView.layer.cornerRadius = 10.0
        //Set segment control with stored preference
        unitSegmentedControl.selectedSegmentIndex = Preferences.sharedInstance.getUnits().rawValue
        
        //Setup tap gesture to dismiss view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapToClose))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        zipCodeOuterView.layer.cornerRadius = 10.0
    }
    
    @IBAction func unitChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == WeatherRequestUnits.imperial.rawValue {
            Preferences.sharedInstance.saveUnits(units: WeatherRequestUnits.imperial)
        }else if sender.selectedSegmentIndex == WeatherRequestUnits.metric.rawValue {
            Preferences.sharedInstance.saveUnits(units: WeatherRequestUnits.metric)
        }
        //Update resource with units change
        let location = Preferences.sharedInstance.getLocation()
        if location.latitude != 0, location.longitude != 0 {
            mainViewController?.forecastResource = DarkSkyApi.sharedInstance.getForcastResource(latitude: location.latitude, longitude: location.longitude)
        }
    }
    

    @IBAction func getWeatherButtonTapped(_ sender: UIButton) {
        //Check the zip code field is not empty
        if let zipCode = zipCodeTextField.text, !zipCode.isEmpty {
            //Check the the zip code is 5 digits
            if NSPredicate(format: "SELF MATCHES %@", "\\d{5}").evaluate(with: zipCode) {
                //Get latitude and longitude from zip code
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(zipCode) { [weak self] (placeMarks, error) in
                    if let error = error{
                        self?.showAlertView(message: error.localizedDescription)
                    }else{
                        if let place = placeMarks?.first, let location = place.location {
                            //Update resource with new location
                            self?.mainViewController?.forecastResource = DarkSkyApi.sharedInstance.getForcastResource(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                            //Update user default location
                            Preferences.sharedInstance.saveLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude, city: place.locality ?? "", state: place.administrativeArea ?? "")
                            DispatchQueue.main.async {
                                //Update UI on Main Thread
                                self?.mainViewController?.cityAndStateLabel.text = "\(String(describing: place.locality)), \(String(describing: place.administrativeArea))"
                                self?.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            }else{
                showAlertView(message: "Please enter a 5 digit zip code.")
            }
        }else{
            tapToClose()
        }
    }
    
    func showAlertView(message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func tapToClose() {
        //If location is blank then don't close settings
        //Allows user to close if perference are stored
        let location = Preferences.sharedInstance.getLocation()
        if location.latitude == 0, location.longitude == 0 {
            showAlertView(message: "Please enter a zip code.")
        }else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}

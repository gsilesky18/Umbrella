//
//  MainViewController.swift
//  Umbrella
//
//  Created by Jon Rexeisen on 10/13/15.
//  Copyright © 2015 The Nerdery. All rights reserved.
//

import UIKit
import Siesta

class MainViewController: UIViewController {

    @IBOutlet weak var currentTemperatureView: UIView!
    @IBOutlet weak var cityAndStateLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var statusOverlay = ResourceStatusOverlay()
    
    var forecastResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)

            forecastResource?.addObserver(self).addObserver(statusOverlay, owner: self).loadIfNeeded()

        }
    }
    
    var currentCondition : Condition? {
        didSet{
            if let currentCondition = currentCondition {
                temperatureLabel.text = "\(currentCondition.temperature)˚"
                conditionLabel.text = currentCondition.summary
                if Preferences.sharedInstance.getUnits() == WeatherRequestUnits.imperial, currentCondition.temperature > 60 {
                    view.backgroundColor = UIColor(0xFF9800)
                    currentTemperatureView.backgroundColor = UIColor(0xFF9800)
                }else if Preferences.sharedInstance.getUnits() == WeatherRequestUnits.metric, currentCondition.temperature > 16 {
                    view.backgroundColor = UIColor(0xFF9800)
                    currentTemperatureView.backgroundColor = UIColor(0xFF9800)
                }else{
                    view.backgroundColor = UIColor(0x03A9F4)
                    currentTemperatureView.backgroundColor = UIColor(0x03A9F4)
                }
            }
        }
    }

    var forecasts: [Forecast] = [] {
        didSet{
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup Siesta overlay
        statusOverlay.embed(in: self)
        statusOverlay.displayPriority = [.loading, .anyData, .error]
        
        //Set default colors to warm
        view.backgroundColor = UIColor(0xFF9800)
        currentTemperatureView.backgroundColor = UIColor(0xFF9800)
        
        //Get location from prefernces
        let location = Preferences.sharedInstance.getLocation()
        if location.latitude != 0, location.longitude != 0 {
            forecastResource = DarkSkyApi.sharedInstance.getForcastResource(latitude: location.latitude, longitude: location.longitude)
            refreshScreen()
        }
        
        //Setup will enter foreground notification
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forecastResource?.loadIfNeeded()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //If forcast resource is nil then open settings
        if forecastResource == nil{
            //First opening
            performSegue(withIdentifier: "segueToSettings", sender: nil)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLayoutSubviews() {
        //Set overlay to cover view
        statusOverlay.positionToCover(view.bounds, inView: view)
    }
    
    deinit {
        //Remove will enter foreground notification
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToSettings"{
            if let vc = segue.destination as? SettingsViewController {
               vc.mainViewController = self
            }
        }
    }
    
    @IBAction func settingsButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "segueToSettings", sender: nil)
    }
    
    func refreshScreen(){
        //Update UI with forecast resource
        if let response : DarkSkyResponse = forecastResource?.typedContent() {
            currentCondition = response.currently
            forecasts = response.forecasts.sorted(by: {
                return $0.date < $1.date
            })
        }
        
        let location = Preferences.sharedInstance.getLocation()
        cityAndStateLabel.text = "\(location.city), \(location.state)"
    }
    
    @objc func willEnterForeground(_ notification: NSNotification!){
        //Reload 
        forecastResource?.loadIfNeeded()
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return forecasts.count > 0 ? 2 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if forecasts.count > section{
            return forecasts[section].hourlyCondition.count
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherCollectionViewCell.kWeatherCollectionViewCell, for: indexPath) as? WeatherCollectionViewCell else {
            return UICollectionViewCell()
        }
        if forecasts.count > indexPath.section{
            cell.condition = forecasts[indexPath.section].hourlyCondition[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: DailyGroupCollectionReusableView.kDailyGroupCollectionReusableView, for: indexPath) as? DailyGroupCollectionReusableView else {
            return UICollectionReusableView()
        }
        if forecasts.count > indexPath.section{
            cell.dateLable.text = forecasts[indexPath.section].date.toRelativeDate()
        }
        return cell
    }
}

// MARK: - Resource observer
extension MainViewController: ResourceObserver {
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        if let response : DarkSkyResponse = resource.typedContent() {
            currentCondition = response.currently
            forecasts = response.forecasts.sorted(by: {
                return $0.date < $1.date
            })
        }
    }
}



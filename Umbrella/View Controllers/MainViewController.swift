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

    @IBOutlet weak var collectionView: UICollectionView!
    
    fileprivate var statusOverlay = ResourceStatusOverlay()
    
    fileprivate var forecastResource: Resource? {
        didSet {
            oldValue?.removeObservers(ownedBy: self)
            oldValue?.cancelLoadIfUnobserved(afterDelay: 0.1)
            
            forecastResource?.addObserver(self).addObserver(statusOverlay, owner: self).loadIfNeeded()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusOverlay.embed(in: self)
        statusOverlay.displayPriority = [.loading, .anyData, .error]
        
        let latitude = UserDefaults.standard.double(forKey: "Latitude")
        let longitude = UserDefaults.standard.double(forKey: "Longitude")
        
        if latitude != 0, longitude != 0 {
            forecastResource = DarkSkyApi.sharedInstance.getForcast(latitude: latitude, longitude: longitude)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        forecastResource?.loadIfNeeded()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    @IBAction func returnFromSettingsSegue(_: UIStoryboardSegue) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
}

// MARK: - UICollectionViewDataSource

extension MainViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        return UICollectionReusableView()
    }
}

// MARK: - Resource observer
extension MainViewController: ResourceObserver {
    
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        if let response : DarkSkyResponse = resource.typedContent() {
            print(response)
        }
    }
}



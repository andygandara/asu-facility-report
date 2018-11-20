//
//  MapVC.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 11/19/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class MapVC: UIViewController {

    @IBOutlet weak var placeLabel: UILabel!
    
    var location: String?
    
    var locationManager = CLLocationManager()
    var placesClient = GMSPlacesClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: Any) {
        location = nil
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        getLocation()
    }
    func getLocation() {
        placesClient.currentPlace(callback: { (placeLikelihoodList, error) -> Void in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                for likelihood in placeLikelihoodList.likelihoods {
                    let place = likelihood.place
                    print("Current Place name \(place.name) at likelihood \(likelihood.likelihood)")
                    print("Current Place address \(String(describing: place.formattedAddress))")
                    print("Current Place attributions \(String(describing: place.attributions))")
                    print("Current PlaceID \(place.placeID)\n\n")
                }
                
                self.placeLabel.text = placeLikelihoodList.likelihoods.first?.place.formattedAddress
                self.location = placeLikelihoodList.likelihoods.first?.place.formattedAddress
                
            }
        })
    }

}

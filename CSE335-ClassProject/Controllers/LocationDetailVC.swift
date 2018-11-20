//
//  LocationDetailVC.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 11/19/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit
import MapKit

class LocationDetailVC: UIViewController {
    
    var addressReceived: String?
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue.")
            
            self.setMap()
        }
    }
    
    func setMap() {
        if let address = addressReceived {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
                if let placemark = placemarks?.first, let location = placemark.location {
                    let mark = MKPlacemark(placemark: placemark)
                    
                    if var region = self?.mapView.region {
                        region.center = location.coordinate
                        region.span.longitudeDelta /= 2000.0
                        region.span.latitudeDelta /= 2000.0
                        self?.mapView.setRegion(region, animated: true)
                        self?.mapView.addAnnotation(mark)
                    }
                }
            }
        } else {
            print("No address received.")
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

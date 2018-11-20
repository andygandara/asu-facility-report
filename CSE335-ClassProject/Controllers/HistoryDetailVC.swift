//
//  HistoryDetailVC.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 11/17/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit

class HistoryDetailVC: UITableViewController {
    
    // Data to be received from segue
    var receivedModel: IssueEntity?
    
    // UI outlets for model data
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var campusLabel: UILabel!
    @IBOutlet weak var buildingLabel: UILabel!
    @IBOutlet weak var floorLabel: UILabel!
    @IBOutlet weak var areaLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDataLabels()
    }
    
    func setDataLabels() {
        if let data = receivedModel {
            print("Data received successfully:\n\(data)")
            
            guard let date = data.date else {
                fatalError()
            }
            
            image.image = UIImage(data: data.photo!)
            campusLabel.text = data.campus
            buildingLabel.text = data.building
            floorLabel.text = data.floor
            areaLabel.text = data.area
            detailsLabel.text = data.details
            locationLabel.text = data.location
            dateLabel.text = getFriendlyDate(date: date)
        } else {
            print("No data received.")
        }
    }
    
    func getFriendlyDate(date: Date) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        let friendlyDate = dateFormatterPrint.string(from: date)
        print(friendlyDate)
        
        return friendlyDate
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapDetail" {
            if let vc = segue.destination as? LocationDetailVC {
                if let address = receivedModel?.location {
                    print("Data received successfully:\n\(address)")
                    vc.addressReceived = address
                }
            }
        }
    }

}

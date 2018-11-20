//
//  ProfileVC.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 11/14/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {

    // UI outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailAddressLabel: UILabel!
    @IBOutlet weak var phoneNumLabel: UILabel!
    @IBOutlet weak var labelStack: UIStackView!
    @IBOutlet weak var noProfileImage: UIImageView!
    @IBOutlet weak var editAddButton: UIBarButtonItem!
    @IBOutlet weak var noProfileStack: UIStackView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set image view and label when no profile data is available
        self.noProfileImage.image =  UIImage(named:"blank-profile")
        self.noProfileImage.layer.cornerRadius = self.noProfileImage.frame.size.width / 2
        self.noProfileImage.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //var profile = ProfileModel()
        //let model = ProfileModel()
        if let profile = ProfileModel().getProfileObject() {
            print(profile)
            
            noProfileStack.isHidden = true
            labelStack.isHidden = false
            editAddButton.title = "Edit"
            
            nameLabel.text = profile.name
            emailAddressLabel.text = profile.emailAddress
            phoneNumLabel.text = profile.phoneNumber
        } else {
            noProfileStack.isHidden = false
            labelStack.isHidden = true
            editAddButton.title = "Add Profile"
            
        }
    }
    
    
    
    @IBAction func unwindToEditVC(segue:UIStoryboardSegue) { }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

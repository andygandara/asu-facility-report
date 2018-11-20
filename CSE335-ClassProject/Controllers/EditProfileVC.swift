//
//  EditProfileVC.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 10/12/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit

class EditProfileVC: UITableViewController, UITextFieldDelegate {
    
    var profile = ProfileModel()

    // IB outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBAction func save(_ sender: Any) {
        if let name = nameTextField.text, name != "",
            let email = emailAddressTextField.text, email != "",
            let num = phoneNumTextField.text, num != "" {
            // Update/save profile and dismiss view controller
            profile.updateProfile(name: name, emailAddress: email, phoneNumber: num)
            print(profile.getProfileObject() ?? "Profile not saved.")
            self.navigationController?.popViewController(animated: true)
        } else {
            // UI alert
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Dismiss keyboard when tapping anywhere
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
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

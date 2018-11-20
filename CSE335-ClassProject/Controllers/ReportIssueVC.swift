//
//  FirstViewController.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 10/12/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit
import CoreData
import MessageUI

class ReportIssueVC: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, MFMailComposeViewControllerDelegate {
    // MARK: - Variables
    var selectedImage: UIImage?
    var selectedLocation: String?
    
    // MARK: - UI Items
    @IBOutlet weak var campusTF: UITextField!
    @IBOutlet weak var buildingTF: UITextField!
    @IBOutlet weak var floorTF: UITextField!
    @IBOutlet weak var areaTF: UITextField!
    @IBOutlet weak var detailsTF: UITextView!
    @IBOutlet weak var photoSelectedLabel: UILabel!
    @IBOutlet weak var locationSelectedLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // MARK: - UI Actions
    // Add image and assign to selectedImage
    @IBAction func addPhoto(_ sender: Any) {
        
        let photoSourceRequestController = UIAlertController(title: "", message: "Choose your photo source.", preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style:.default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) { //checking if camera is available
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                
                self.present(imagePicker, animated: true, completion: nil)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        })
        
        photoSourceRequestController.addAction(cameraAction)
        photoSourceRequestController.addAction(photoLibraryAction)
        photoSourceRequestController.addAction(cancelAction)
        
        present(photoSourceRequestController, animated: true, completion: nil)
    }

    
    // Clear all text fields and selections
    @IBAction func cancel(_ sender: Any) {
        clearEntries()
    }
    
    // Submit issue
    @IBAction func submit(_ sender: Any) {
        
        // Safe unwrap
        if let campus = campusTF.text, !campus.isEmpty,
            let building = buildingTF.text, !building.isEmpty,
            let floor = floorTF.text, !floor.isEmpty,
            let area = areaTF.text, !area.isEmpty,
            let details = detailsTF.text, !details.isEmpty,
            let image = selectedImage,
            let location = selectedLocation, !location.isEmpty {
            
            // Open up MFMailComposeViewController to send email
            sendEmail(campus: campus, building: building, floor: floor, area: area, details: details, image: image, location: location, date: datePicker.date)
            
            // Add new issue to CoreData
            let issueModel = IssueModel()
            issueModel.addIssue(campus: campus, building: building, floor: floor, area: area, details: details, image: image, location: location, date: datePicker.date)
            
            // Clear entries
            clearEntries()
            
        } else {
            alertInvalid()
        }
        
    }
    
    // MARK: - Functions
    func sendEmail(campus: String, building: String, floor: String, area: String, details: String, image: UIImage, location: String, date: Date) {
        if( MFMailComposeViewController.canSendMail()) {
            print("Can send email.")
            
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            // Set to recipients
            mailComposer.setToRecipients(["FacMan@asu.edu"])
            
            // Set the subject
            mailComposer.setSubject("ASU Facilities Issue Report")
            
            // Get sender info
            let profileModel = ProfileModel()
            var senderName = ""
            var senderEmail = ""
            var senderPhone = ""
            if let name = profileModel.getProfileObject()?.name, let email = profileModel.getProfileObject()?.emailAddress, let phone = profileModel.getProfileObject()?.phoneNumber {
                senderName = name
                senderEmail = email
                senderPhone = phone
            }
            
            // Set mail body
            let body = "<b>ASU Facilities Issue Report</b><br/><br/><b>Sender Name:</b> \(senderName)<br/><b>Sender Email:</b> \(senderEmail)<br/><b>Sender Phone Number:</b> \(senderPhone)<br/><br/><b>Date:</b> \(getFriendlyDate(date: date))<br/><b>Campus:</b> \(campus)<br/><b>Building:</b> \(building)<br/><b>Floor:</b> \(floor)<br/><b>Area:</b> \(area)<br/><b>Details:</b> \(details)<br/><b>Location:</b> \(location)"
            mailComposer.setMessageBody(body, isHTML: true)
            mailComposer.addAttachmentData(selectedImage!.pngData()!, mimeType: "image/png", fileName: "image.png")
            
            //this will compose and present mail to user
            self.present(mailComposer, animated: true, completion: nil)
        } else {
            print("Email is not supported.")
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
    
    func alertInvalid() {
        let alert = UIAlertController(title: "Missing Data", message: "Please make sure you have completed all fields.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func clearEntries() {
        selectedImage = nil
        campusTF.text = nil
        buildingTF.text = nil
        floorTF.text = nil
        areaTF.text = nil
        detailsTF.text = nil
        photoSelectedLabel.text = "No Photo Selected"
        locationSelectedLabel.text = "No Location Selected"
        selectedLocation = nil
        datePicker.date = Date.init()
        setTextViewPlaceHolder(textView: detailsTF, text: "Enter issue details")
        self.view.endEditing(true)
    }
    
    func setTextViewPlaceHolder(textView: UITextView, text: String) {
        textView.text = text
        textView.textColor = UIColor.lightGray
    }
    
    // MARK: - Protocols
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let newImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Put image on screen if taken with no errors
        selectedImage = newImage
        
        // Update label
        photoSelectedLabel.text = "✅ Photo Successfully Uploaded"
        
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setTextViewPlaceHolder(textView: textView, text: "Enter issue details")
        }
    }
    
    func mailComposeController(_ didFinishWithcontroller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailsTF.delegate = self
        
        // Dismiss keyboard when tapping anywhere
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        
        // Set border color to match text fields
        detailsTF.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        setTextViewPlaceHolder(textView: detailsTF, text: "Enter issue details")
    }

    @IBAction func returnedFromMapVC(_ sender: UIStoryboardSegue) {
        if sender.source is MapVC {
            if let senderVC = sender.source as? MapVC {
                // Get data from sender
                print("returnedFromMapVC function triggered.")
                locationSelectedLabel.text = senderVC.location
                selectedLocation = senderVC.location
            }
        }
    }

}


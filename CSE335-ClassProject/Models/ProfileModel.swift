//
//  ProfileModel.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 11/13/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit
import CoreData
import Foundation

public class ProfileModel
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private var fetchResults = [ProfileEntity]()
    
    private func fetchRecord() -> [ProfileEntity] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileEntity")
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [ProfileEntity])!
        return fetchResults
    }
    
    func getCount() -> Int {
        do {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileEntity")
            let count = try managedObjectContext.count(for: fetchRequest)
            print("Count: \(count)")
            return count
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return 0
        }
    }
    
    func updateProfile(name: String, emailAddress: String, phoneNumber: String)
    {
        _ = fetchRecord()
        // create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "ProfileEntity", in: self.managedObjectContext)
        //add to the manege object context
        let profile = ProfileEntity(entity: ent!, insertInto: self.managedObjectContext)
        profile.name = name
        profile.emailAddress = emailAddress
        profile.phoneNumber = phoneNumber
        
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
        }
        _ = fetchRecord()
        
        if (getCount() > 1) {
            print("fetchResults: \(fetchResults)")
            removeProfile(row: 1)
        }
        
        print(profile)
    }
    
    func removeProfile(row: Int)
    {
        managedObjectContext.delete(fetchResults[row])
        // remove it from the fetch results array
        fetchResults.remove(at:row)
        
        do {
            // save the updated managed object context
            try managedObjectContext.save()
        } catch {
            
        }
        
    }
    
    func getProfileObject() -> ProfileEntity? {
        return fetchRecord().first
    }
}

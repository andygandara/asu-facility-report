//
//  IssueModel.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 11/12/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit
import CoreData
import Foundation

public class IssueModel
{
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var fetchResults = [IssueEntity]()
    
    func fetchRecord() -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IssueEntity")
        let sort = NSSortDescriptor(key: #keyPath(IssueEntity.date), ascending: false)
        fetchRequest.sortDescriptors = [sort]
        fetchResults = ((try? managedObjectContext.fetch(fetchRequest)) as? [IssueEntity])!
        return fetchResults.count
    }
    
    func addIssue(campus: String, building: String, floor: String, area: String, details: String, image: UIImage, location: String, date: Date)
    {
        // create a new entity object
        let ent = NSEntityDescription.entity(forEntityName: "IssueEntity", in: self.managedObjectContext)
        //add to the manege object context
        let newItem = IssueEntity(entity: ent!, insertInto: self.managedObjectContext)
        newItem.campus = campus
        newItem.building = building
        newItem.floor = floor
        newItem.area = area
        newItem.details = details
        newItem.photo = image.pngData()
        newItem.location = location
        newItem.date = date
        
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
        }
        
        print(newItem)
    }
    
    // Won't need
    func editIssue(row: Int, desc: String, image: UIImage) {
        // save the updated context
        do {
            try self.managedObjectContext.save()
        } catch _ {
        }
    }
    
    func removeIssue(row:Int)
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
    
    func getIssueObject(row:Int) -> IssueEntity
    {
        return fetchResults[row]
    }
    
    func deleteAll()
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "IssueEntity")
        
        // whole fetchRequest object is removed from the managed object context
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            
            
        }
        catch _ as NSError {
            // Handle error
        }
        
    }
}

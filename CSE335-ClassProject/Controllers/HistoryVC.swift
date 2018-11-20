//
//  HistoryVC.swift
//  CSE335-ClassProject
//
//  Created by Andy Gandara on 11/12/18.
//  Copyright © 2018 Andy Gandara. All rights reserved.
//

import UIKit
import CoreData

class HistoryVC: UITableViewController {
    
    var issueModel: IssueModel = IssueModel()
    
    @IBOutlet var historyTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
 
    override func viewWillAppear(_ animated: Bool) {
        historyTableView.reloadData()
        if let index = self.historyTableView.indexPathForSelectedRow{
            self.historyTableView.deselectRow(at: index, animated: true)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return issueModel.fetchRecord()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath)

        let issueAtIndex = issueModel.getIssueObject(row: indexPath.row)
        
        guard let date = issueAtIndex.date else {
            fatalError()
        }
        
        cell.textLabel?.text = issueAtIndex.building
        cell.detailTextLabel?.text = getFriendlyDate(date: date)

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            issueModel.removeIssue(row: indexPath.row)
            //tableView.reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigatio

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyToDetail" {
            if let vc = segue.destination as? HistoryDetailVC, let indexPath = tableView.indexPathForSelectedRow {
                vc.receivedModel = issueModel.getIssueObject(row: indexPath.row)
            }
        }
    }
 

}

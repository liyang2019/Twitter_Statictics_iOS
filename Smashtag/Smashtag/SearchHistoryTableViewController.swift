//
//  SearchHistoryTableViewController.swift
//  Smashtag
//
//  Created by Li Yang on 7/20/17.
//  Copyright © 2017 Rice University. All rights reserved.
//

import UIKit
import CoreData

class SearchHistoryTableViewController: FetchedResultsTableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        { didSet { updateUI() } }
    
    var fetchedResultsController: NSFetchedResultsController<Search>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchedResultsController?.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI() {
        if let context = container?.viewContext {
            let request: NSFetchRequest<Search> = Search.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "created", ascending: false)]
            fetchedResultsController = NSFetchedResultsController<Search>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Search History Cell", for: indexPath)
        if let search = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = search.searchTerm
            
            // failed to update them in tableVew..
//            if let created = search.created as Date? {
//                print(created)
//                let formatter = DateFormatter()
//                // transform to readable date
//                if Date().timeIntervalSince(created) > 24 * 60 * 60 {
//                    formatter.dateStyle = .short
//                } else {
//                    formatter.timeStyle = .short
//                }
//                cell.detailTextLabel?.text = formatter.string(from: created)
//            } else {
//                cell.detailTextLabel?.text = nil
//            }
        }
        return cell
    }
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Search Again",
            let smashTweetTVC = segue.destination.contents as? SmashTweetTableViewController,
            let searchText = (sender as? UITableViewCell)?.textLabel?.text {
            smashTweetTVC.searchText = searchText            
        }
    }
    
}


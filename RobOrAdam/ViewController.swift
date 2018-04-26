//
//  ViewController.swift
//  RobOrAdam
//
//  Created by Lee Offir on 4/26/18.
//  Copyright © 2018 Lee Offir. All rights reserved.
//
import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var robItems = [Rob]()
    var moc:NSManagedObjectContext!
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moc = appDelegate?.persistentContainer.viewContext
        self.tableView.dataSource = self
        
        loadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    
    func loadData(){
        let robRequest:NSFetchRequest<Rob> = Rob.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        robRequest.sortDescriptors = [sortDescriptor]
        do {
            try robItems = moc.fetch(robRequest)
            
        }catch {
            print("Could not load data")
        }
        self.tableView.reloadData()
    }
    
    
    
    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        let robItem = Rob(context: moc)
        robItem.added = NSDate() as Date
        
        if sender.tag == 0 {
            robItem.type = "Rob wins!"
        }else {
            robItem.type = "Adam wins!"
        }
        
        appDelegate?.saveContext()
        
        loadData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return robItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
    
        let robItem = robItems[indexPath.row]
        
       
        let robType = robItem.type
        cell.textLabel?.text = robType
        
       
        let robDate = robItem.added as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy, hh:mm"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: robDate)
        
        
        if robType == "Rob wins!" {
            cell.imageView?.image = UIImage(named: "rob")
        }else{
            cell.imageView?.image = UIImage(named: "adam")
        }
        
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
}
}

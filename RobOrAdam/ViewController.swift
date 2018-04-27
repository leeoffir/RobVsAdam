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
    
    
    var items = [Rob]()
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
        let request:NSFetchRequest<Rob> = Rob.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "added", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        do {
            try items = moc.fetch(request)
            
        }catch {
            print("Could not load data")
        }
        self.tableView.reloadData()
    }
    
    
    
    @IBAction func addFoodToDatabase(_ sender: UIButton) {
        let item = Rob(context: moc)
        item.added = NSDate() as Date
        
        if sender.tag == 0 {
            item.type = "Rob wins!"
        }else {
            item.type = "Adam wins!"
        }
        
        appDelegate?.saveContext()
        
        loadData()
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
    
        let robItem = items[indexPath.row]
        
       
        let type = robItem.type
        cell.textLabel?.text = type
        
       
        let robDate = robItem.added as! Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d yyyy, hh:mm"
        
        cell.detailTextLabel?.text = dateFormatter.string(from: robDate)
        
        
        if type == "Rob wins!" {
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

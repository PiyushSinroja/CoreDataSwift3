//
//  ViewController.swift
//  CoreDataSwift3
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tblview: UITableView!
    
    var cellObj : simpleCell = simpleCell()
    var arrayEmp = [Employee]()
    
    let managedContext = CoreDataHelper.managedContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tblview.estimatedRowHeight = 44.0
        tblview.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:-  Button Actions
    @IBAction func btnAdd(_ sender: Any) {
        let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
        self.present(addViewController!, animated: true, completion: nil)
    }
    
    @IBAction func btnDeleteCustom(_ sender: Any) {
        // Please check this and learn
        deleteData(name: "Bhavik", title: "Sanghavi")
    }
    
    //MARK:- Fetch Core Data
    func fetchData(){
        let fetchRequest = CoreDataHelper.coreDataSharedObj.fetchRequestEmployee()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
      //   let sortDescriptor = NSSortDescriptor(key: #keyPath(Employee.name), ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        do{
            arrayEmp = try managedContext.fetch(fetchRequest)
            print(arrayEmp.count)
            if self.arrayEmp.count > 0 {
                for empob in self.arrayEmp{
                    
                    print(empob.name ?? "")
                    print(empob.title ?? "")
                    print(empob.date ?? "")
                    print(empob.roll )
                }
            }
            tblview.reloadData()
        }catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    //MARK:- Delete Entity
    func deleteEntity(obj: AnyObject) {
        let objentity = obj as! Employee
        self.managedContext.delete(objentity)
        contextUpdate()
        fetchData()
    }
    
    // This deletedata is used For like Where Clause
    func deleteData(name: String, title: String) {
        let fetchRequest = CoreDataHelper.coreDataSharedObj.fetchRequestEmployee()
        
        /*
         // You can take compound predicate for mutiple delete
         var subPredicates : [NSPredicate] = []
         let predicate = NSPredicate(format: "%K == %@", "name", name)
         subPredicates.append(predicate)
         fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates)
         */
        
        let predicate = NSPredicate(format: "name==%@&&title==%@", name,title)
        fetchRequest.predicate = predicate
        do {
            let fetchedEntities = try managedContext.fetch(fetchRequest)
            for entity in fetchedEntities {
                self.managedContext.delete(entity)
            }
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        contextUpdate()
        fetchData()
    }
    
    //MARK:- contextUpdate
    func contextUpdate() {
        do {
            try managedContext.save()
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}

//MARK:- UITableViewDataSource Methods
extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayEmp.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellObj = tblview.dequeueReusableCell(withIdentifier: "cell") as! simpleCell
        
        if let name = self.arrayEmp[indexPath.row].name,  let title = self.arrayEmp[indexPath.row].title {
            cellObj.lblName.text = name + " " + title
        }
        
        cellObj.backgroundColor = UIColor.randomColor
        return cellObj
    }
}
//MARK:- UITableViewDelegate Methods
extension ViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let addViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddViewController") as? AddViewController
        
        if let name = self.arrayEmp[indexPath.row].name,  let title = self.arrayEmp[indexPath.row].title {
            addViewController?.empobj = self.arrayEmp[indexPath.row] as Employee
            
            print(name)
            print(title)
        }
        self.present(addViewController!, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            print(indexPath.row)
            if let name = self.arrayEmp[indexPath.row].name,  let title = self.arrayEmp[indexPath.row].title {
                deleteEntity(obj: self.arrayEmp[indexPath.row])
                
                print(name)
                print(title)
            }
        }
    }
}

extension UIColor{
    class var randomColor: UIColor{
        get {
            let red = CGFloat(drand48())
            let green = CGFloat(drand48())
            let blue = CGFloat(drand48())
            return UIColor(red: red, green: green, blue: blue, alpha: 0.25)
            
        }
    }
    
}



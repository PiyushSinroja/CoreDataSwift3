//
//  AddViewController.swift
//  CoreDataSwift3
//


import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var btnSaveOrUpdate: UIButton!
    
    var empobj : AnyObject?
    let managedContext = CoreDataHelper.managedContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if empobj != nil{
            let obj = empobj as! Employee
            if let name = obj.name,  let title = obj.title {
                
                txtName.text = name
                txtTitle.text = title

                
                print(name)
                print(title)
            }
            
            btnSaveOrUpdate.setTitle("Update", for: UIControlState.normal)
        }
        else{
            btnSaveOrUpdate.setTitle("Save", for: UIControlState.normal)
        }
    }
    //MARK:- Button Actions
    @IBAction func btnSave(_ sender: Any) {
        if !(txtTitle.text?.isEmpty)! && !(txtName.text?.isEmpty)! {
            if btnSaveOrUpdate.titleLabel?.text == "Save" {
                saveEmployeeData()
            }
            else{
                updateDataFromEntity()
            }
        }
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK:- Save Data
    func saveEmployeeData(){
        let employeeData = Employee(context: managedContext)
        employeeData.name = txtName.text
        employeeData.title = txtTitle.text
        employeeData.roll = 1
        employeeData.date = NSDate()
        updateContext()
    }
    
    //MARK:- UpdateData
    func updateDataFromEntity() {
        let obj = empobj as! Employee
        obj.name = txtName.text!
        obj.title = txtTitle.text
        obj.roll = 1
        obj.date = NSDate()
        
        updateContext()
    }
    
    func updateContext() {
        do {
            try managedContext.save()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.dismiss(animated: true, completion: nil)
            }
        }catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    // This is used for where clause
    /*
     func updateData() {
     let fetchRequest = CoreDataHelper.coreDataSharedObj.fetchRequestEmployee()
     let predicate = NSPredicate(format: "title==%@", "patel")
     fetchRequest.predicate = predicate
     do{
     let arrayNew = try managedContext.fetch(fetchRequest)
     for emp in arrayNew {
     emp.name = txtName.text
     emp.title = txtTitle.text
     emp.date = NSDate()
     }
     }
     catch let error as NSError {
     fatalError("Unresolved error \(error), \(error.userInfo)")
     }
     updateContext()
     }
     
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

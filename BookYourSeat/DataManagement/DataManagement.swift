//
//  DataManagement.swift
//  BookYourSeat
//
//  Created by George on 1/10/19.
//  Copyright © 2019 Georgekutty. All rights reserved.
//

import UIKit
import CoreData
class DataManagement: NSObject
{

    static func createData(data:[String:Any]){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let userEntity = NSEntityDescription.entity(forEntityName: "SeatDetails", in: managedContext)!
        let seatValues:[[String:String]] = data["data"] as! [[String:String]]
        
        for seatInfo in seatValues {
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(Int(seatInfo["id"] ?? "0"), forKeyPath: "id")
            user.setValue(seatInfo["price"], forKey: "price")
            user.setValue(seatInfo["status"], forKey: "seatStatus")
        }
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    

  static  func retrieveData() ->[Any] {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return []}
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SeatDetails")
        let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        var valueFromBD : [ Any] = []
        do {
            let result = try managedContext.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                var values :[String:String] = [:]
                values["id"] = String(data.value(forKey: "id") as! Int)
                values["price"] = data.value(forKey: "price") as? String
                values["status"] = data.value(forKey: "seatStatus") as? String
                valueFromBD.append(values)
            }
        } catch {
            print("Failed")
        }
    
        return valueFromBD
    }
    
    static func updateData(seatStatus:String,id:String){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "SeatDetails")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
            
            let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(seatStatus, forKey: "seatStatus")
            do{
                try managedContext.save()
            }
            catch
            {
                print(error)
            }
        }
        catch
        {
            print(error)
        }
        
    }
    
}

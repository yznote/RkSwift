//
//  DbTestVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/15.
//

import CoreData
import UIKit

class DbTestVC: RKBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         * CoreData
         * 1. cmd+N 选择 ‘data model’,创建与项目同名xx.xcdatamodeld
         * 2. AppDelegate 添加代码【参考AppDelegate.m或者本类末尾】
         * 3. 创建Entity
         * 4. 添加属性
         */

        debug.log("core data start")

        // add()
        lookup()
        // edit()
        // del()
    }

    /// 删除
    func del() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext

        let fetchReq = NSFetchRequest<User>(entityName: "User")
        fetchReq.fetchLimit = 10
        fetchReq.fetchOffset = 0

        let predicate = NSPredicate(format: "id='1'", "")
        fetchReq.predicate = predicate

        do {
            let fetchObj = try context.fetch(fetchReq)
            for obj in fetchObj {
                context.delete(obj)
            }
            // 保存
            app.saveContext()
        } catch {
            fatalError("未查询到")
        }
    }

    /// 修改
    func edit() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext

        let fetchReq = NSFetchRequest<User>(entityName: "User")
        fetchReq.fetchLimit = 10
        fetchReq.fetchOffset = 0

        let predicate = NSPredicate(format: "id='1'", "")
        fetchReq.predicate = predicate

        do {
            let fetchObj = try context.fetch(fetchReq)
            for obj in fetchObj {
                obj.name = "xiaoming"
            }
            // 保存
            app.saveContext()
        } catch {
            fatalError("未查询到")
        }
    }

    /// 查询
    func lookup() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext

        let fetchReq = NSFetchRequest<User>(entityName: "User")
        fetchReq.fetchLimit = 10
        fetchReq.fetchOffset = 0

        let predicate = NSPredicate(format: "id='1'", "")
        fetchReq.predicate = predicate

        do {
            let fetchObj = try context.fetch(fetchReq)

            debug.log("===>", "\(fetchObj)")
            for obj in fetchObj {
                debug.log("===>", "id:\(obj.id ?? 999)", "name:\(obj.name ?? "null-name")")
            }

        } catch {
            fatalError("未查询到")
        }
    }

    /// 增加
    func add() {
        let app = UIApplication.shared.delegate as! AppDelegate
        let context = app.persistentContainer.viewContext

        let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: context) as! User
        user.id = 1
        user.name = "daming"

        app.saveContext()
    }
}

/*
 // MARK: - Core Data stack
 lazy var persistentContainer: NSPersistentContainer = {
     //  The persistent container for the application. This implementation
     //  creates and returns a container, having loaded the store for the
     //  application to it. This property is optional since there are legitimate
     //  error conditions that could cause the creation of the store to fail.

     let container = NSPersistentContainer(name: "RKProject")
     container.loadPersistentStores(completionHandler: { _, error in
         if let error = error as NSError? {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful
             // during development.

             //  Typical reasons for an error here include:
             //  * The parent directory does not exist, cannot be created, or disallows writing.
             //  * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             //  * The device is out of space.
             //  * The store could not be migrated to the current model version.
             //  Check the error message to determine what the actual problem was.

             fatalError("Unresolved error \(error), \(error.userInfo)")
         }
     })
     return container
 }()

 // MARK: - Core Data Saving support
 func saveContext() {
     let context = persistentContainer.viewContext
     if context.hasChanges {
         do {
             try context.save()
         } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful
             // during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
     }
 }
 */

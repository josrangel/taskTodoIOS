//
//  TaskUtility.swift
//  AgendaList
//
//  Created by ParpaditosKMMX on 22/10/20.
//

import Foundation

class TaskUtility{
    private static let key = "tasks"
    
    //archive
    private static func archive(_ tasks: [[Task]]) -> Data? {
        return try? NSKeyedArchiver.archivedData(withRootObject: tasks, requiringSecureCoding: false)
    }
    
    //fetch
    static func fetch() -> [[Task]]? {
        guard let unarchivedData = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(unarchivedData) as? [[Task]] ?? [[]]
    }
    
    //save
    static func save(_ tasks: [[Task]]) {
        let archiveTask = archive(tasks)
        UserDefaults.standard.set(archiveTask, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
}

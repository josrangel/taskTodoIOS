//
//  TaskStore.swift
//  AgendaList
//
//  Created by KMMX on 21/10/20.
//

import Foundation

class TaskStore{
    //atributos
    var tasks = [[Task](), [Task]()]
    //init
    
    //metodos
    func add(_ task:Task,at index: Int, isDone: Bool = false){
        let section = isDone ? 1:0
        tasks[section].insert(task, at:index)
    }
    
    @discardableResult func removeTask(at index: Int, isDone:Bool = false) -> Task {
        let section = isDone ? 1 : 0
        return tasks[section].remove(at: index)
    }
}

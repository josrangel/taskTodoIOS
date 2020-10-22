//
//  Task.swift
//  AgendaList
//
//  Created by ParpaditosKMMX on 21/10/20.
//

import Foundation
//Modelo
class Task: NSObject, NSCoding {
    //atributos
    var name: String?
    var isDone: Bool?
    
    private let nameKey = "name"
    private let isDoneKey = "isDone"
    //init
    
    init(name: String, isDone: Bool = false) {
        self.name = name
        self.isDone = isDone
    }
    
    required init(coder: NSCoder) {
        guard let name = coder.decodeObject(forKey: nameKey) as? String,
              let isDone = coder.decodeObject(forKey: isDoneKey) as? Bool
        else { return }
        
        self.name = name
        self.isDone = isDone
    }
    
    //metodos
    func encode(with coder: NSCoder){
        coder.encode(name, forKey: nameKey)
        coder.encode(isDoneKey, forKey: isDoneKey)
    }
}

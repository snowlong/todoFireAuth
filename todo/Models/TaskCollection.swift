//
//  TaskCollection.swift
//  todo
//
//  Created by Jun Takahashi on 2019/05/22.
//  Copyright © 2019年 Jun Takahashi. All rights reserved.
//

import Foundation

protocol TaskCollectionDelegate: class {
    func reload()
}

class TaskCollection {
    
    static var shared = TaskCollection()
    
    public private(set) var tasks: [Task] = []

    weak var delegate: TaskCollectionDelegate?
    
    let userDefaults = UserDefaults.standard

    private init() {
        self.load()
    }
    
    // タスクの追加
    func addTask (_ task: Task) {
        tasks.append(task)
        self.save()
    }
    
    // タスクの削除
    func removeTask (at: Int) {
        tasks.remove(at: at)
        self.save()
    }
    
    func editTask () {
        self.save()
    }
    
    private func save () {
        do {
            let data = try PropertyListEncoder().encode(tasks)
            userDefaults.set(data, forKey: "tasks")
        } catch {
            fatalError ("Save Faild.")
        }
        
        delegate?.reload()
    }
    
    private func load() {
        guard let data = userDefaults.data(forKey: "tasks") else { return }
        do {
            let tasks = try PropertyListDecoder().decode([Task].self, from: data)
            self.tasks = tasks
        } catch {
            fatalError ("Cannot Load.")
        }
    }
}

//
//  TaskTableViewController.swift
//  AgendaList
//
//  Created by KMMX on 21/10/20.
//

import UIKit

class TaskTableViewController: UITableViewController {
    
    //var cells: [UITableViewCell] = []
    var taskStore : TaskStore! {
        didSet{
            taskStore.tasks = TaskUtility.fetch() ?? [ [Task](), [Task]()]
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *){
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithTransparentBackground()
            navBarAppearance.backgroundColor = UIColor(red: 28/255, green:166/255, blue: 211/255, alpha:1)
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
          
            navigationController?.navigationBar.standardAppearance = navBarAppearance
            navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.navigationBar.backgroundColor = UIColor.clear
            
        }
        cellSetup()
        tableViewSetup()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    @IBAction func addTask(_ sender: UIBarButtonItem){
        let alert = UIAlertController(title: "Add a Task", message: nil, preferredStyle: .alert)
        //let addAction = UIAlertAction(title: "Add", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            guard let name = alert.textFields?.first?.text else { return }
            let newTask = Task(name: name)
            
            let indexPath = IndexPath(row: 0, section: 0)
            
            self.taskStore.add(newTask, at: 0)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        //addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addTextField{textField in
            textField.placeholder = "Enter Task Name"
            textField.addTarget(self, action: #selector(self.handleTextChange), for: .editingChanged)
        }
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    @objc private func handleTextChange(_ sender: UITextField){
        guard let alertController = presentedViewController as? UIAlertController,
              let addAction = alertController.actions.first,
              let text = sender.text
        else{
            return
        }
    }
    
    //bad way not correct
    func cellSetup(){
        /*for _ in 0...1000 {
            let cell = UITableViewCell()
            cell.textLabel?.text = "Bad way!"
            cells.append(cell)
        }*/
        
        let todoTask = [Task(name: "Estudiar"), Task(name: "Ir de compras"), Task(name: "Gimnasio")]
        let doneTask = [Task(name: "Limpiar el auto", isDone: true)]
        
        taskStore.tasks=[todoTask,doneTask]
    }
    
    func tableViewSetup(){
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 350
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //return 1
        return taskStore.tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskStore.tasks[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        //let cell = cells[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        //taskStore.tasks[indexPath.section][indexPath.row].name
        cell.textLabel?.text = taskStore.tasks[indexPath.section][indexPath.row].name //"How much better!"
        

        // Configure the cell...

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section:Int) ->String?{
        return section == 0 ? "To-do" : "Done"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {
            (action,sourceView,completationHandler) in
            guard let isDone = self.taskStore.tasks[indexPath.section][indexPath.row].isDone else { return}
            self.taskStore.removeTask(at: indexPath.row, isDone: isDone)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            completationHandler(true)
        }
        
        deleteAction.image = #imageLiteral(resourceName: "delete")
        deleteAction.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let doneAction = UIContextualAction(style: .normal, title: nil) {
            (action,sourceView,completationHandler) in
            
            self.taskStore.tasks[0][indexPath.row].isDone = true
            let doneTask = self.taskStore.removeTask(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            self.taskStore.add(doneTask, at: 0, isDone: true)
            
            tableView.insertRows(at: [IndexPath(row: 0, section : 1)], with: .automatic)
            
            completationHandler(true)
        }
        
        doneAction.image = #imageLiteral(resourceName: "done")
        doneAction.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        return indexPath.section == 0 ? UISwipeActionsConfiguration(actions: [doneAction]) : nil
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

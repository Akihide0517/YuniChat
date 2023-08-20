//
//  File.swift
//  newChat
//
//  Created by 吉田成秀 on 2022/07/03.
//

import UIKit
import Firebase
import FirebaseDatabase

class Item {

    var ref: DatabaseReference?
    var title: String?

    init (snapshot: DataSnapshot) {
        ref = snapshot.ref

        let data = snapshot.value as! Dictionary<String, String>
        title = data["title"]! as String
    }

}

class ItemsTableViewController: UITableViewController {

    var user: User!
    var items = [Item]()
    var ref: DatabaseReference!
    private var databaseHandle: DatabaseHandle!

    override func viewDidLoad() {
        super.viewDidLoad()

        ref = Database.database().reference()
        startObservingDatabase()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
        return cell
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = items[indexPath.row]
            item.ref?.removeValue()
        }
    }

    func startObservingDatabase () {
        databaseHandle = ref.child("users/items").observe(.value, with: { (snapshot) in
            var newItems = [Item]()

            for itemSnapShot in snapshot.children {
                let item = Item(snapshot: itemSnapShot as! DataSnapshot)
                newItems.append(item)
            }

            self.items = newItems
            self.tableView.reloadData()

        })
    }

    deinit {
        ref.child("users/items").removeObserver(withHandle: databaseHandle)
    }
}

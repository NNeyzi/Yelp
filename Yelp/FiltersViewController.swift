//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Nader Neyzi on 9/23/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate {

    @IBOutlet weak var tableView: UITableView!

    weak var delegate: FiltersViewControllerDelegate?
    var switchStates = [0:[Int:Bool](),3:[Int:Bool]()]
    var checkStates = [1:[Int:Bool](),2:[Int:Bool]()]

    let data = [("", ["Offering a Deal"]),
                ("Distance", ["0.3 mi", "1 mi", "3 mi", "5 mi"]),
                ("Sort By", ["best match", "distance", "highest rated"]),
                ("Category", ["afghan", "american", "caribbean", "indonesian", "mediterranean"])]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "TableViewHeaderView")
    }

    // MARK: - IBActions
    
    @IBAction func onCancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func onSearchButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        var filters = [String: AnyObject]()

        //sort: .Distance, categories: ["asianfusion", "burgers"], deals: true

        if let _ = switchStates[0]?[0] {
            filters["deals"] = true as AnyObject
        }

        var sort = YelpSortMode.bestMatched
        if let sorts = checkStates[2] {
            for (row, _) in sorts {
                sort = YelpSortMode(rawValue: row)!
            }
        }
        filters["sort"] = sort as AnyObject


        var selectedCategories = [String]()
        for (row, isOn) in switchStates[3]! {
            if isOn {
                selectedCategories.append(data[3].1[row])
            }
        }
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }

        delegate?.filtersViewController?(filtersViewController: self, didUpdateFilters: filters)
    }

    // MARK: - TableView dataSource & delegate

    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].1.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 || indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CheckCell", for: indexPath) as! CheckCell

            cell.accessoryType = .none
            if let state = checkStates[indexPath.section]![indexPath.row] {
                if state {
                    cell.accessoryType = .checkmark
                }
            }
            let dataSection = data[indexPath.section].1
            cell.checkLabel.text = dataSection[indexPath.row]

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell", for: indexPath) as! SwitchCell

            cell.delegate = self

            cell.onSwitch.isOn = switchStates[indexPath.section]![indexPath.row] ?? false
            let dataSection = data[indexPath.section].1
            cell.switchLabel.text = dataSection[indexPath.row]

            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TableViewHeaderView")!
        header.textLabel?.text = data[section].0
        return header
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 1 || indexPath.section == 2) {
            if let state = checkStates[indexPath.section]![indexPath.row] {
                checkStates[indexPath.section]![indexPath.row] = !state
            } else {
                checkStates[indexPath.section]![indexPath.row] = true
            }
            tableView.reloadData()
        }
    }

    // MARK: - SwitchCellDelegate

    func switchCell(switchCell: SwitchCell, didChangeValue value: Bool) {
        let indexPath = tableView.indexPath(for: switchCell)!
        switchStates[indexPath.section]![indexPath.row] = value
    }

}

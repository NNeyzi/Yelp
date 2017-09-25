//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FiltersViewControllerDelegate, UISearchBarDelegate {
    
    var businesses: [Business]!
    var searchBar = UISearchBar()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Restaurants"

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)

        navigationController?.navigationBar.barTintColor = .red

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120

        Business.searchWithTerm(term: "Restaurants", completion: { (businesses: [Business]?, error: Error?) -> Void in

            self.businesses = businesses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        })

    }

    // MARK: TableView Delegate & Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCell", for: indexPath) as! BusinessCell

        cell.rowNum = indexPath.row + 1
        cell.business = businesses[indexPath.row]
        
        return cell
    }

    // MARK: - FiltersViewController Delegate

    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {

        let categories = filters["categories"] as? [String]
        let sort = filters["sort"] as? YelpSortMode ?? nil
        let deal = filters["deal"] as? Bool ?? nil

        Business.searchWithTerm(term: "Restaurants", sort: sort, categories: categories, deals: deal) { (businesses: [Business]?, error: Error?) in

            self.businesses = businesses
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }

        }
    }

    // MARK: SearchBar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text != "" {
            Business.searchWithTerm(term: searchBar.text!, completion: { (businesses: [Business]?, error: Error?) -> Void in

                self.businesses = businesses
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            })
        }
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            Business.searchWithTerm(term: searchBar.placeholder!, completion: { (businesses: [Business]?, error: Error?) -> Void in

                self.businesses = businesses
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

            })
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        dismissKeyboard()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let filtersViewController = navController.topViewController as! FiltersViewController
        filtersViewController.delegate = self
    }

    // MARK: - Keyboard

    func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }

}

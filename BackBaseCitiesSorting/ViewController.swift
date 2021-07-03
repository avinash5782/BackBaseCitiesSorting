//
//  ViewController.swift
//  BackBaseCitiesSorting
//
//  Created by Avinash on 03/07/21.
//

import UIKit

import UIKit
import Combine
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cityDetails : CityDataModel = []
    var filteredCityDetails: CityDataModel = []
    var viewModel : ViewModel!
    var mytableView: UITableView!
    var subscriber :AnyCancellable?
    var isSearch : Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytableView = UITableView()
        self.mytableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        
        
        let searchBar:UISearchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = " Search..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        self.view.addSubview(self.mytableView)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: self.view.topAnchor , constant:  50).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        searchBar.widthAnchor.constraint(equalTo: self.view.widthAnchor ).isActive = true
        searchBar.leftAnchor.constraint(equalTo: self.view.leftAnchor ).isActive = true
        searchBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.mytableView.translatesAutoresizingMaskIntoConstraints = false
        self.mytableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor , constant:  20).isActive = true
        self.mytableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor , constant:  -20).isActive = true
        self.mytableView.leftAnchor.constraint(equalTo: self.view.leftAnchor ).isActive = true
        self.mytableView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        setupViewMOdel()
    }
    
    func setupViewMOdel() {
        viewModel = ViewModel()
        obsrableData()
        fetchData()
    }
    func fetchData() {
        viewModel.fetdata()
    }
    func obsrableData() {
        subscriber =  viewModel.passthroughobj.sink(receiveCompletion: { (value) in
            switch value {
            case .failure( _):  break
            case .finished: break
            }
        }) { (data) in
            self.cityDetails = data.sorted {$0.name < $1.name}
            DispatchQueue.main.async {
                self.mytableView.reloadData()
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TestCell")
        var userdata: CityData!
        if isSearch {
            userdata = filteredCityDetails[indexPath.item]
        } else {
            userdata = cityDetails[indexPath.item]
        }
        cell.textLabel?.text = userdata.name + ", " + userdata.country
        cell.detailTextLabel?.text = String ( userdata.coord.lat) + ", " + String(userdata.coord.lon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cityDetails.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
extension ViewController: UISearchBarDelegate {
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        isSearch = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0 {
            isSearch = false
            self.mytableView.reloadData()
        } else {
            filteredCityDetails = cityDetails.filter({ (text) -> Bool in
                let tmp = text
                let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
                return range.location != NSNotFound
            })
            if(filteredCityDetails.count == 0){
                isSearch = false
            } else {
                isSearch = true
            }
            self.mytableView.reloadData()
        }
    }
    
}


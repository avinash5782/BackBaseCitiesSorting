//
//  ViewController.swift
//  BackBaseCitiesSorting
//
//  Created by Shadab on 03/07/21.
//

import UIKit
import Combine
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var cityDetails : CityDataModel = []
    var filteredCityDetails: CityDataModel = []
    var viewModel : ViewModel!
    var mytableView: UITableView!
    var subscriber :AnyCancellable?
    var isSearch : Bool = false
    var searchBar: UISearchBar!
    var activityIndicatorView: UIActivityIndicatorView?
    fileprivate func SetupViews() {
        // adding the the search bar
        
        searchBar = UISearchBar()
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
        activityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        activityIndicatorView?.style = UIActivityIndicatorView.Style.large
        activityIndicatorView?.color = .gray
        activityIndicatorView?.center = self.view.center
        self.view.addSubview(activityIndicatorView ?? UIView())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mytableView = UITableView()
        self.mytableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        self.mytableView.delegate = self
        self.mytableView.dataSource = self
        self.mytableView.keyboardDismissMode = .onDrag
        SetupViews()
        setupViewMOdel()
    }
    override func viewWillAppear(_ animated: Bool) {
    }
    
    func setupViewMOdel() {
        viewModel = ViewModel()
        obsrableData()
        self.activityIndicatorView?.startAnimating()
        DispatchQueue.global(qos: .default).async {
            self.fetchData()
        }
    }
    func fetchData() {
        viewModel.fetchdata()
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
                self.activityIndicatorView?.stopAnimating()
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
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return filteredCityDetails.count
        }else{
            return cityDetails.count
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var userdata: CityData!
        if isSearch {
            userdata = filteredCityDetails[indexPath.item]
        } else {
            userdata = cityDetails[indexPath.item]
        }
        let mapView = ShowMapView(citiData: userdata)
        let navigationVC = UINavigationController(rootViewController: mapView)
        navigationVC.modalPresentationStyle = .fullScreen
        navigationVC.showDetailViewController(mapView, sender: self)
        self.present(navigationVC, animated: true, completion: nil)
    }
}
extension ViewController: UISearchBarDelegate {
    //MARK: UISearchbar delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearch = false
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
            // filtering data from both  CityName and Country, if its found anyone of them add in filtered array
            filteredCityDetails =  cityDetails.filter { $0.name.starts(with: searchText) || $0.country.range(of: searchText, options: .caseInsensitive) != nil
            }
            isSearch = true
            DispatchQueue.main.async {
                self.mytableView.reloadData()
            }
        }
    }
    
}


//
//  ShowMapView.swift
//  BackBaseCitiesSorting
//
//  Created by Avinash on 03/07/21.
//

import Foundation
import UIKit
import MapKit

class ShowMapView: UIViewController {
    var cityData: CityData!
    var mapView: MKMapView!
    init(citiData: CityData) {
        super.init(nibName: nil, bundle: .main)
        self.cityData = citiData
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let back = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(close))
        self.navigationItem.leftBarButtonItems =  [back]
        mapView = MKMapView()
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: self.view.topAnchor ).isActive = true
        mapView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor ).isActive = true
        mapView.leftAnchor.constraint(equalTo: self.view.leftAnchor ).isActive = true
        mapView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
       
    }
   
    @objc func close() {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let location = MKPointAnnotation()
        location.title = cityData.name + " " + cityData.country
        location.coordinate = CLLocationCoordinate2D(latitude:cityData.coord.lat, longitude: cityData.coord.lon )
        self.mapView.addAnnotation(location)
        self.mapView.showAnnotations(self.mapView.annotations, animated: true)

    }
}

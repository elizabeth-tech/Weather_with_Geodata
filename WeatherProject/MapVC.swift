//
//  MapVC.swift
//  WeatherProject
//
//  Created by Elizaveta on 27.11.2020.
//

import UIKit
import MapKit

class MapVC: UIViewController
{
    @IBOutlet weak var myMapView: MKMapView! // аутлет самой карты
    
    var lat = 0.0
    var lon = 0.0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Координаты расположения города
        let cityLocation = CLLocation(latitude: lat, longitude: lon)
        myMapView.centerLocation(cityLocation)
    }
}

extension MKMapView
{
    // regionRadius: CLLocationDistance = 10000 - Указываем, что отдаление должно быть на 10км
    func centerLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 10000)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

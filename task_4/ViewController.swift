//
//  ViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 29.12.2022.
//

import UIKit
import SnapKit
import MapKit

class ViewController: UIViewController {

    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    let locationManager = CLLocationManager()
    private lazy var refreshButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self,
                                                     action: #selector(refreshButtonTapped))

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBar = navigationController?.navigationBar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white

        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "Карта банкоматов"
        navigationItem.rightBarButtonItem = refreshButton

        let pinLocation = CLLocationCoordinate2DMake(54.2093303, 28.4741666)
        let objectAnnotation = MKPointAnnotation()
        objectAnnotation.coordinate = pinLocation
        objectAnnotation.title = "Test"
        mapView.addAnnotation(objectAnnotation)

        view.addSubview(mapView)

        mapView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(0)
            maker.left.equalToSuperview().inset(0)
            maker.right.equalToSuperview().inset(0)
            maker.bottom.equalToSuperview().inset(0)
        }

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkLocationEnabled()
    }

    func checkLocationEnabled() {
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.setupManager()
                self.checkAuthorization()
            } else {
                let message = "Для продолжения работы этому приложению требуется доступ к вашей геолокации." +
                "Вы хотите предоставить доступ?"
                let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
                    if let urlSetting = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(urlSetting)
                    }
                })
                alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func checkAuthorization() {
        switch locationAuthorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
//            locationManager.startUpdatingLocation()
        case .denied:
            let message = "Для продолжения работы этому приложению требуется доступ к вашей геолокации." +
            "Вы хотите предоставить доступ?"
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
                if let urlSetting = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(urlSetting)
                }
            })
            alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

            present(alert, animated: true, completion: nil)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }

    func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }

    @objc func refreshButtonTapped() {
    }

}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 500,
                                            longitudinalMeters: 500)
            mapView.setRegion(region, animated: true)
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorization()
    }

}

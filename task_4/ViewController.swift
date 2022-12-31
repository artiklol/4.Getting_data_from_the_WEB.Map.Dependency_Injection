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

    var test: [WelcomeElement] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let navigationBar = navigationController?.navigationBar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white

        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "Карта банкоматов"
        navigationItem.rightBarButtonItem = refreshButton

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

    func points() {
        for tes in test {
            let pinLocation = tes.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.title = tes.id
            objectAnnotation.subtitle = tes.id
            mapView.addAnnotation(objectAnnotation)
        }

    }

    func setupManager() {
        mapView.delegate = self
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
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        let barButton = UIBarButtonItem(customView: activityIndicator)

        navigationItem.rightBarButtonItem = barButton
        activityIndicator.startAnimating()
        NetworkManager.fetchData { testi in
            self.test = testi
            activityIndicator.stopAnimating()
            self.points()
            self.navigationItem.rightBarButtonItem = self.refreshButton
        }

    }

}

extension ViewController: CLLocationManagerDelegate, MKMapViewDelegate {
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

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let temp = view.annotation?.subtitle, let value = temp else { return }
        var ind = 0
        for index in 0..<test.count where test[index].id == value {
            ind = index
        }
        showPreliminaryDetails(element: test[ind])
        mapView.deselectAnnotation(view.annotation, animated: false)
    }

    private func showPreliminaryDetails(element: WelcomeElement) {
        let preliminaryDetails = PreliminaryDetailsViewController()
        preliminaryDetails.installPlaceLabel.text = element.installPlace
        preliminaryDetails.workTimeLabel.text = element.workTime
        preliminaryDetails.currencyLabel.text = "\(element.currency)"
        preliminaryDetails.cashInLabel.text = "\(element.cashIn)"

        preliminaryDetails.modalPresentationStyle = .formSheet

        if let sheet = preliminaryDetails.sheetPresentationController {
            sheet.detents = [.medium()]
        }

        present(preliminaryDetails, animated: true, completion: nil)
    }

}

//
//  MainViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 29.12.2022.
//

import UIKit
import SnapKit
import MapKit

class MainViewController: UIViewController {

    private lazy var  mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    private lazy var locationManager = CLLocationManager()
    private lazy var refreshButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self,
                                                     action: #selector(refreshButtonTapped))
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Карта", "Список"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = .gray
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        return segmentControl
    }()
    private lazy var listCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    private lazy var ATMs: [WelcomeElement] = []
    private lazy var groupedCityATMs: [String: [WelcomeElement]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        view.addSubview(listCollectionView)
        view.addSubview(segmentControl)

        setSetting()
        setConstraint()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationEnabled()
    }

    private func setSetting() {
        view.backgroundColor = .white

        let navigationBar = navigationController?.navigationBar
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = .white
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "Банкоматы"
        navigationItem.rightBarButtonItem = refreshButton

        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        listCollectionView.register(CollectionViewCell.self,
                                forCellWithReuseIdentifier: CollectionViewCell.identifier)
        listCollectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderCollectionReusableView.reuserId)
        listCollectionView.isHidden = true
    }

    private func setConstraint() {
        mapView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(0)
            maker.left.right.bottom.equalTo(view).inset(0)
        }

        segmentControl.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(10)
            maker.left.right.equalTo(view).inset(40)
            maker.height.equalTo(30)
        }

        listCollectionView.snp.makeConstraints { maker in
            maker.top.equalTo(segmentControl.snp.bottom).offset(10)
            maker.left.right.bottom.equalTo(view).inset(0)
        }
    }

    private func setupManager() {
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func checkLocationEnabled() {
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

    private func annotationATM() {
        for ATM in ATMs {
            let pinLocation = ATM.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.subtitle = ATM.id
            mapView.addAnnotation(objectAnnotation)
        }
    }

    private func checkAuthorization() {
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

    private func locationAuthorizationStatus() -> CLAuthorizationStatus {
        let locationManager = CLLocationManager()
        var locationAuthorizationStatus: CLAuthorizationStatus
        if #available(iOS 14.0, *) {
            locationAuthorizationStatus =  locationManager.authorizationStatus
        } else {
            locationAuthorizationStatus = CLLocationManager.authorizationStatus()
        }
        return locationAuthorizationStatus
    }

    @objc func segmentControlValueChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapView.isHidden = false
            listCollectionView.isHidden = true
        case 1:
            mapView.isHidden = true
            listCollectionView.isHidden = false
        default:
            break
        }
    }

    @objc func refreshButtonTapped() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        let barButton = UIBarButtonItem(customView: activityIndicator)

        navigationItem.rightBarButtonItem = barButton
        activityIndicator.startAnimating()
        NetworkManager.fetchData { testi in
            self.ATMs = testi
            activityIndicator.stopAnimating()
            self.annotationATM()
            self.groupedCityATMs = Dictionary(grouping: self.ATMs, by: { $0.cityType.rawValue + " " + $0.city })
            self.listCollectionView.reloadData()
            self.navigationItem.rightBarButtonItem = self.refreshButton
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
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

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let temp = view.annotation?.subtitle, let value = temp else { return }
        var ind = 0
        for index in 0..<ATMs.count where ATMs[index].id == value {
            ind = index
        }
        showPreliminaryDetails(element: ATMs[ind])
        mapView.deselectAnnotation(view.annotation, animated: false)
    }

    private func showPreliminaryDetails(element: WelcomeElement) {
        let preliminaryDetails = PreliminaryDetailsViewController()
        preliminaryDetails.dataInPreliminaryDetails(element: element)

        if let sheet = preliminaryDetails.sheetPresentationController {
            sheet.detents = [.medium()]
        }

        present(preliminaryDetails, animated: true, completion: nil)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupedCityATMs.keys.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedCityATMs[Array(groupedCityATMs.keys)[section]]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cellATMs = groupedCityATMs[Array(groupedCityATMs.keys)[indexPath.section]]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier,
                                                            for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }
        guard let cellATMs = cellATMs else { return cell }
        cell.dataInCell(element: cellATMs[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath
    ) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: HeaderCollectionReusableView.reuserId, for: indexPath)
        guard let typedHeaderView = header as? HeaderCollectionReusableView else { return header }

        typedHeaderView.setTitleHeader(title: "\(Array(groupedCityATMs.keys)[indexPath.section])")
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension MainViewController: UICollectionViewDelegate {

}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let interItemSpacing: CGFloat = 5
        let width = (collectionView.bounds.width - (interItemSpacing * (itemsPerRow - 1)) - 20) / itemsPerRow
        return CGSize(width: width, height: width)
    }

}

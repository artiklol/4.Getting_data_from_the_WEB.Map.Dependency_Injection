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

    private lazy var mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .unspecified
        return map
    }()
    private lazy var locationManager = CLLocationManager()
    private lazy var refreshButton = UIBarButtonItem(title: "Обновить", style: .plain, target: self,
                                                     action: #selector(refreshButtonTapped))
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Карта", "Список"])
        segmentControl.selectedSegmentIndex = 0
        segmentControl.backgroundColor = UIColor(named: "SegmentControlBackgroundColor")
        guard let borderColor = UIColor(named: "BorderColor") else { return segmentControl }
        segmentControl.layer.borderColor =  UIColor(named: "Color")?.cgColor
        segmentControl.selectedSegmentTintColor = UIColor(named: "Green")
        segmentControl.layer.borderWidth = 0.5

        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "BlackWhite")]
        segmentControl.setTitleTextAttributes(titleTextAttributes as [NSAttributedString.Key: Any], for: .normal)

        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        segmentControl.setTitleTextAttributes(titleTextAttributes1, for: .selected)
        segmentControl.addTarget(self, action: #selector(segmentControlValueChanged(_:)), for: .valueChanged)
        return segmentControl
    }()
    private lazy var listCollectionView: UICollectionView = {
        let viewLayout = UICollectionViewFlowLayout()
        viewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: viewLayout)
        collectionView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        return collectionView
    }()
    private lazy var automatedTellerMachines: [WelcomeElement] = []
    private lazy var groupedCityAutomatedTellerMachines: [String: [WelcomeElement]] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(mapView)
        view.addSubview(listCollectionView)
        view.addSubview(segmentControl)

        setSetting()
        setConstraint()
        fethData()
        checkAuthorization()
    }

    private func setSetting() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        let navigationBar = navigationController?.navigationBar
        navigationBar?.overrideUserInterfaceStyle = .unspecified
        let navBarAppearance = UINavigationBarAppearance()
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "Банкоматы"
        navigationItem.rightBarButtonItem = refreshButton

        mapView.delegate = self

        listCollectionView.dataSource = self
        listCollectionView.delegate = self
        listCollectionView.register(CollectionViewCell.self,
                                    forCellWithReuseIdentifier: CollectionViewCell.identifier)
        listCollectionView.register(HeaderCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                    withReuseIdentifier: HeaderCollectionReusableView.reuserId)

        segmentControlValueChanged(segmentControl)
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

    private func fethData() {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        let barButton = UIBarButtonItem(customView: activityIndicator)

        navigationItem.rightBarButtonItem = barButton
        activityIndicator.startAnimating()
        NetworkManager.fetchData { testi in
            self.automatedTellerMachines = testi
            self.automatedTellerMachines = self.automatedTellerMachines.sorted { $0.id < $1.id }
            activityIndicator.stopAnimating()
            self.addAnnotationAutomatedTellerMachine()
            self.groupedCityAutomatedTellerMachines = Dictionary(grouping: self.automatedTellerMachines,
                                                                 by: { $0.cityType.rawValue + " " + $0.city })
            self.listCollectionView.reloadData()
            self.navigationItem.rightBarButtonItem = self.refreshButton
        }
    }

    private func setRegion(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(region, animated: true)
    }

    private func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    private func addAnnotationAutomatedTellerMachine() {
        for automatedTellerMachine in automatedTellerMachines {
            let pinLocation = automatedTellerMachine.coordinate
            let objectAnnotation = MKPointAnnotation()
            objectAnnotation.coordinate = pinLocation
            objectAnnotation.subtitle = automatedTellerMachine.id
            mapView.addAnnotation(objectAnnotation)
        }
    }

    private func checkAuthorization() {
        switch locationAuthorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true

        case .denied:
            showAlert(title: nil,
                      message: "Для продолжения работы этому приложению требуется доступ к вашей геолокации." +
                      "Вы хотите предоставить доступ?",
                      url: URL(string: UIApplication.openSettingsURLString))
//            setupManager()
//            guard let userCoordinate: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
//            setRegion(coordinate: userCoordinate)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
//            setupManager()
//            guard let userCoordinate: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
//            setRegion(coordinate: userCoordinate)
        default:
            break
        }
        setupManager()
        guard let userCoordinate: CLLocationCoordinate2D = locationManager.location?.coordinate else { return }
        setRegion(coordinate: userCoordinate)
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

    private func showAlert(title: String?, message: String, url: URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Открыть настройки", style: .default) { _ in
            if let urlSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(urlSetting)
            }
        })
        alert.addAction(UIAlertAction(title: "Отменить", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    private func showPreliminaryDetails(element: WelcomeElement) {
        let preliminaryDetails = PreliminaryDetailsViewController()
        preliminaryDetails.dataInPreliminaryDetails(element: element)

        if let sheet = preliminaryDetails.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }

        present(preliminaryDetails, animated: true, completion: nil)
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
        fethData()
    }
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}

extension MainViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let temp = view.annotation?.subtitle, let value = temp else { return }

        var indexResult = 0
        for index in 0..<automatedTellerMachines.count where automatedTellerMachines[index].id == value {
            indexResult = index
        }
        setRegion(coordinate: automatedTellerMachines[indexResult].coordinate)
        showPreliminaryDetails(element: automatedTellerMachines[indexResult])
        mapView.deselectAnnotation(view.annotation, animated: false)
    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return groupedCityAutomatedTellerMachines.keys.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groupedCityAutomatedTellerMachines[Array(groupedCityAutomatedTellerMachines.keys)[section]]?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cellATMs = groupedCityAutomatedTellerMachines[
            Array(groupedCityAutomatedTellerMachines.keys)[indexPath.section]]
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

        typedHeaderView.setTitleHeader(title: "\(Array(groupedCityAutomatedTellerMachines.keys)[indexPath.section])")
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 50)
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = groupedCityAutomatedTellerMachines[
            Array(groupedCityAutomatedTellerMachines.keys)[indexPath.section]]
        guard let selectedItem = selectedItem else { return }
        showPreliminaryDetails(element: selectedItem[indexPath.row])
        segmentControl.selectedSegmentIndex = 0
        segmentControlValueChanged(segmentControl)
        setRegion(coordinate: selectedItem[indexPath.row].coordinate)
    }
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

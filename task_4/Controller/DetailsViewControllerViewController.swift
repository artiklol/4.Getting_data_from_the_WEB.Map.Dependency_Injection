//
//  DetailsViewControllerViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 06.01.2023.
//

import UIKit
import SnapKit
import MapKit

class DetailsViewControllerViewController: UIViewController {

    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    private lazy var idTitleLabel = UILabel()
    private lazy var idLabel = UILabel()
    private lazy var idStackView = UIStackView()
    private lazy var areaTitleLabel = UILabel()
    private lazy var areaLabel = UILabel()
    private lazy var areaStackView = UIStackView()
    private lazy var cityTitleLabel = UILabel()
    private lazy var cityLabel = UILabel()
    private lazy var cityStackView = UIStackView()
    private lazy var addressTitleLabel = UILabel()
    private lazy var addressLabel = UILabel()
    private lazy var addressStackView = UIStackView()
    private lazy var installPlaceTitleLabel = UILabel()
    private lazy var installPlaceLabel = UILabel()
    private lazy var installPlaceStackView = UIStackView()
    private lazy var coordinateTitleLabel = UILabel()
    private lazy var coordinateLabel = UILabel()
    private lazy var coordinateStackView = UIStackView()
    private lazy var workTimeTitleLabel = UILabel()
    private lazy var workTimeLabel = UILabel()
    private lazy var workTimeStackView = UIStackView()
    private lazy var atmTypeTitleLabel = UILabel()
    private lazy var atmTypeLabel = UILabel()
    private lazy var atmTypeStackView = UIStackView()
    private lazy var atmErrorTitleLabel = UILabel()
    private lazy var atmErrorLabel = UILabel()
    private lazy var atmErrorStackView = UIStackView()
    private lazy var atmPrinterTitleLabel = UILabel()
    private lazy var atmPrinterLabel = UILabel()
    private lazy var atmPrinterStackView = UIStackView()
    private lazy var currencyTitleLabel = UILabel()
    private lazy var currencyLabel = UILabel()
    private lazy var currencyStackView = UIStackView()
    private lazy var cashInTitleLabel = UILabel()
    private lazy var cashInLabel = UILabel()
    private lazy var cashInStackView = UIStackView()
    private lazy var createRouteButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Построить маршрут"
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")?.withAlphaComponent(0.7)
            default:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")
            }
        }
        button.addTarget(self, action: #selector(createRouteButtonTap), for: .touchUpInside)
        return button
    }()
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        return scrollView
    }()
    private lazy var atmCoordinate: (x: Double, y: Double) = (0, 0)
    private lazy var coordinateUserLocation: (x: Double, y: Double) = (0, 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        setStartSetting()

        view.addSubview(scrollView)
        view.addSubview(createRouteButton)
        scrollView.addSubview(mainStackView)

        setTitleAndInfoInStackView(titleLabel: idTitleLabel, titleText: "ID банкомата",
                                   infoLabel: idLabel, stackView: idStackView)
        setTitleAndInfoInStackView(titleLabel: areaTitleLabel, titleText: "Область",
                                   infoLabel: areaLabel, stackView: areaStackView)
        setTitleAndInfoInStackView(titleLabel: cityTitleLabel, titleText: "Город",
                                   infoLabel: cityLabel, stackView: cityStackView)
        setTitleAndInfoInStackView(titleLabel: addressTitleLabel, titleText: "Адрес",
                                   infoLabel: addressLabel, stackView: addressStackView)
        setTitleAndInfoInStackView(titleLabel: installPlaceTitleLabel, titleText: "Место установки",
                                   infoLabel: installPlaceLabel, stackView: installPlaceStackView)
        setTitleAndInfoInStackView(titleLabel: coordinateTitleLabel, titleText: "Координаты",
                                   infoLabel: coordinateLabel, stackView: coordinateStackView)
        setTitleAndInfoInStackView(titleLabel: workTimeTitleLabel, titleText: "Режим работы",
                                   infoLabel: workTimeLabel, stackView: workTimeStackView)
        setTitleAndInfoInStackView(titleLabel: atmTypeTitleLabel, titleText: "Тип банкомата",
                                   infoLabel: atmTypeLabel, stackView: atmTypeStackView)
        setTitleAndInfoInStackView(titleLabel: atmErrorTitleLabel, titleText: "Банкомат работает",
                                   infoLabel: atmErrorLabel, stackView: atmErrorStackView)
        setTitleAndInfoInStackView(titleLabel: atmPrinterTitleLabel, titleText: "Печатает чек",
                                   infoLabel: atmPrinterLabel, stackView: atmPrinterStackView)
        setTitleAndInfoInStackView(titleLabel: currencyTitleLabel, titleText: "Валюта",
                                   infoLabel: currencyLabel, stackView: currencyStackView)
        setTitleAndInfoInStackView(titleLabel: cashInTitleLabel, titleText: "Наличие cash in",
                                   infoLabel: cashInLabel, stackView: cashInStackView)

        setConstraint()
    }

    private func setStartSetting() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        let navigationBar = navigationController?.navigationBar
        navigationBar?.overrideUserInterfaceStyle = .unspecified
        let navBarAppearance = UINavigationBarAppearance()
        navigationBar?.standardAppearance = navBarAppearance
        navigationBar?.scrollEdgeAppearance = navBarAppearance
        navigationItem.title = "Информация"

        let backButtonItem = UIBarButtonItem(title: "Назад", style: .done, target: self,
                                             action: #selector(backButtonItemTap))
        navigationItem.leftBarButtonItem  = backButtonItem
    }

    private func setConstraint() {
        scrollView.snp.makeConstraints { maker in
            maker.top.left.right.equalTo(view).inset(0)
            maker.bottom.equalTo(view).inset(100)
        }
        mainStackView.snp.makeConstraints { maker in
            maker.top.equalTo(scrollView).inset(10)
            maker.left.right.bottom.equalTo(scrollView).inset(0)
            maker.width.equalTo(scrollView)
        }
        createRouteButton.snp.makeConstraints { maker in
            maker.left.equalToSuperview().inset(50)
            maker.right.equalToSuperview().inset(50)
            maker.bottom.equalToSuperview().inset(30)
            maker.height.equalTo(40)
        }
    }

    private func setTitleAndInfoInStackView(titleLabel: UILabel, titleText: String,
                                            infoLabel: UILabel, stackView: UIStackView) {
        titleLabel.text = titleText
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textColor = UIColor(named: "Gray")
        titleLabel.textAlignment = .left

        infoLabel.font = infoLabel.font.withSize(18)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .right

        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(infoLabel)

        mainStackView.addArrangedSubview(stackView)

        stackView.snp.makeConstraints { maker in
            maker.right.left.equalTo(mainStackView).inset(10)
            maker.width.equalTo(mainStackView).inset(10)
        }
        titleLabel.snp.makeConstraints { maker in
            maker.width.equalTo(157)
        }

    }

    func dataInDetails(element: WelcomeElement, coord: (x: Double, y: Double)) {
        idLabel.text = element.id
        areaLabel.text = element.area.rawValue
        cityLabel.text = "\(element.cityType.rawValue) \(element.city)"
        addressLabel.text = "\(element.addressType.rawValue) \(element.address) \(element.house)"
        installPlaceLabel.text = element.installPlace
        coordinateLabel.text = "\(element.gpsX), \(element.gpsY)"
        workTimeLabel.text = element.workTime
        atmTypeLabel.text = element.atmType.rawValue
        atmErrorLabel.text = element.atmError.rawValue
        atmPrinterLabel.text = element.atmPrinter.rawValue
        currencyLabel.text = element.currency.rawValue
        cashInLabel.text = element.cashIn.rawValue

        coordinateUserLocation = coord
        atmCoordinate = (element.coordinate.latitude, element.coordinate.longitude)
    }

    @objc func backButtonItemTap() {
        dismiss(animated: true, completion: nil)
    }

    @objc func createRouteButtonTap() {
        let latitude: CLLocationDegrees = coordinateUserLocation.x
        let longitude: CLLocationDegrees = coordinateUserLocation.y
        let source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: latitude, longitude: longitude)))
        source.name = "Мое местоположение"

        let destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(
            latitude: atmCoordinate.x, longitude: atmCoordinate.y)))
        destination.name = "Местоположение банкомата"

        MKMapItem.openMaps(
            with: [source, destination],
            launchOptions: [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
        )

    }

}

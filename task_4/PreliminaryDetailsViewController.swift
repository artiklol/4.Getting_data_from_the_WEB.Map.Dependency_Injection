//
//  TestViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 31.12.2022.
//

import UIKit
import SnapKit

class PreliminaryDetailsViewController: UIViewController {

    private lazy var installPlaceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = label.font.withSize(21)
        label.textAlignment = .center
        return label
    }()
    private lazy var workTimeTitleLabel = UILabel()
    private lazy var workTimeLabel = UILabel()
    private lazy var workTimeStackView = UIStackView()
    private lazy var currencyTitleLabel = UILabel()
    private lazy var currencyLabel = UILabel()
    private lazy var currencyStackView = UIStackView()
    private lazy var cashInTitleLabel = UILabel()
    private lazy var cashInLabel = UILabel()
    private lazy var cashInStackView = UIStackView()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    private lazy var detailButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Подробнее"
        let button = UIButton(configuration: configuration, primaryAction: nil)
        button.configurationUpdateHandler = { button in
            switch button.state {
            case .highlighted:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")?.withAlphaComponent(0.7)
            default:
                button.configuration?.baseBackgroundColor = UIColor(named: "Green")
            }
        }
        button.addTarget(self, action: #selector(detailButtonTap), for: .touchUpInside)
        return button
    }()
    private var element: WelcomeElement?
    private lazy var coordinateUserLocation: (x: Double, y: Double) = (0, 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")

        view.addSubview(mainStackView)
        view.addSubview(installPlaceLabel)
        setTitleAndInfoInStackView(titleLabel: workTimeTitleLabel, titleText: "Режим работы",
                                   infoLabel: workTimeLabel, stackView: workTimeStackView)
        setTitleAndInfoInStackView(titleLabel: currencyTitleLabel, titleText: "Режим работы",
                                   infoLabel: currencyLabel, stackView: currencyStackView)
        setTitleAndInfoInStackView(titleLabel: cashInTitleLabel, titleText: "Наличие cash in",
                                   infoLabel: cashInLabel, stackView: cashInStackView)
        view.addSubview(detailButton)

        setConstraint()
    }

    private func setConstraint() {
        mainStackView.snp.makeConstraints { maker in
            maker.centerX.equalTo(view)
            maker.centerY.equalTo(view)
        }
        workTimeLabel.snp.makeConstraints { maker in
            maker.width.equalTo(300)
        }
        installPlaceLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(20)
            maker.left.equalToSuperview().inset(50)
            maker.right.equalToSuperview().inset(50)
            maker.width.equalTo(300)
        }
        detailButton.snp.makeConstraints { maker in
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
        titleLabel.textAlignment = .center

        infoLabel.font = infoLabel.font.withSize(18)
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center

        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(infoLabel)

        mainStackView.addArrangedSubview(stackView)
    }

    func dataInPreliminaryDetails(element: WelcomeElement, coordinate: (x: Double, y: Double)) {
        installPlaceLabel.text = element.installPlace
        workTimeLabel.text = element.workTime
        currencyLabel.text = element.currency.rawValue
        cashInLabel.text = element.cashIn.rawValue

        self.element = element
        coordinateUserLocation = coordinate
    }

    @objc func detailButtonTap() {
        let details = DetailsViewControllerViewController()
        guard let element = element else { return }
        details.dataInDetails(element: element, coord: coordinateUserLocation)
        let navigationController = UINavigationController(rootViewController: details)

        navigationController.modalPresentationStyle = .fullScreen

        present(navigationController, animated: true, completion: nil)
    }

}

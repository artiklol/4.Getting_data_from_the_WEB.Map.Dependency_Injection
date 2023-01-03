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
    private lazy var workTimeTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Режим работы:"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private lazy var workTimeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    private lazy var workTimeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var currencyTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Валюта:"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var currencyStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var cashInTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Наличие cash in:"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    private lazy var cashInLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    private lazy var cashInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        return stackView
    }()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        return stackView
    }()
    private lazy var detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("Подробнее", for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 15
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(mainStackView)
        view.addSubview(installPlaceLabel)
        workTimeStackView.addArrangedSubview(workTimeTitleLabel)
        workTimeStackView.addArrangedSubview(workTimeLabel)
        currencyStackView.addArrangedSubview(currencyTitleLabel)
        currencyStackView.addArrangedSubview(currencyLabel)
        cashInStackView.addArrangedSubview(cashInTitleLabel)
        cashInStackView.addArrangedSubview(cashInLabel)
        mainStackView.addArrangedSubview(workTimeStackView)
        mainStackView.addArrangedSubview(currencyStackView)
        mainStackView.addArrangedSubview(cashInStackView)
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

    func dataInPreliminaryDetails(element: WelcomeElement) {
        installPlaceLabel.text = element.installPlace
        workTimeLabel.text = element.workTime
        currencyLabel.text = element.currency.rawValue
        cashInLabel.text = element.cashIn.rawValue
    }
}

//
//  TestViewController.swift
//  task_4
//
//  Created by Artem Sulzhenko on 31.12.2022.
//

import UIKit
import SnapKit

class PreliminaryDetailsViewController: UIViewController {

    let installPlaceLabel = UILabel()
    let workTimeTitleLabel = UILabel()
    let workTimeLabel = UILabel()
    let currencyTitleLabel = UILabel()
    let currencyLabel = UILabel()
    let cashInTitleLabel = UILabel()
    let cashInLabel = UILabel()
    let stackView = UIStackView()
    let detailButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        stackView.axis = .vertical
        view.addSubview(stackView)
        view.addSubview(installPlaceLabel)
        stackView.addArrangedSubview(workTimeTitleLabel)
        stackView.addArrangedSubview(workTimeLabel)
        stackView.addArrangedSubview(currencyTitleLabel)
        stackView.addArrangedSubview(currencyLabel)
        stackView.addArrangedSubview(cashInTitleLabel)
        stackView.addArrangedSubview(cashInLabel)
        view.addSubview(detailButton)

        installPlaceLabel.numberOfLines = 3
        installPlaceLabel.font = installPlaceLabel.font.withSize(20)
        installPlaceLabel.textAlignment = .center

        detailButton.setTitle("Подробнее", for: .normal)
        detailButton.backgroundColor = .black
        detailButton.layer.cornerRadius = 15

        workTimeTitleLabel.text = "Режим работы:"
        workTimeTitleLabel.textAlignment = .center
        workTimeLabel.textAlignment = .center
        currencyTitleLabel.text = "Валюта:"
        currencyTitleLabel.textAlignment = .center
        currencyLabel.textAlignment = .center
        cashInTitleLabel.text = "Наличие cash in:"
        cashInTitleLabel.textAlignment = .center
        cashInLabel.textAlignment = .center

        stackView.snp.makeConstraints { maker in
            maker.centerX.equalTo(self.view)
            maker.centerY.equalTo(self.view)
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

}

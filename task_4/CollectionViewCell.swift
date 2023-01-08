//
//  CollectionViewCell.swift
//  task_4
//
//  Created by Artem Sulzhenko on 02.01.2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    static let identifier = "ATMList"

    private lazy var installPlaceLabel: UILabel = {
        let label = UILabel()
        label.font = label.font.withSize(10)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    private lazy var workTimeTitleLabel = UILabel()
    private lazy var workTimeLabel = UILabel()
    private lazy var currencyTitleLabel = UILabel()
    private lazy var currencyLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = UIColor(named: "Green")
        contentView.layer.cornerRadius = 10

        contentView.addSubview(installPlaceLabel)
        setTitleAndInfo(titleLabel: workTimeTitleLabel, titleText: "Режим работы", infoLabel: workTimeLabel)
        setTitleAndInfo(titleLabel: currencyTitleLabel, titleText: "Валюта", infoLabel: currencyLabel)

        setConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setConstraint() {
        installPlaceLabel.snp.makeConstraints { maker in
            maker.top.left.right.equalTo(contentView).inset(5)
        }
        workTimeTitleLabel.snp.makeConstraints { maker in
            maker.left.right.equalTo(contentView).inset(5)
            maker.bottom.equalTo(workTimeLabel.snp.top).inset(3)
        }
        workTimeLabel.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(contentView).inset(5)
            maker.bottom.equalTo(contentView).inset(25)
        }
        currencyTitleLabel.snp.makeConstraints { maker in
            maker.left.right.equalTo(contentView).inset(5)
            maker.bottom.equalTo(contentView).inset(15)
        }
        currencyLabel.snp.makeConstraints { maker in
            maker.left.right.bottom.equalTo(contentView).inset(5)
        }
    }

    private func setTitleAndInfo(titleLabel: UILabel, titleText: String, infoLabel: UILabel) {
        titleLabel.text = titleText
        titleLabel.font = .boldSystemFont(ofSize: 10)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center

        infoLabel.font = infoLabel.font.withSize(10)
        infoLabel.textColor = .white
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center

        contentView.addSubview(titleLabel)
        contentView.addSubview(infoLabel)
    }

    func dataInCell(element: WelcomeElement) {
        installPlaceLabel.text = element.installPlace
        workTimeLabel.text = element.workTime
        currencyLabel.text = element.currency.rawValue
    }
}

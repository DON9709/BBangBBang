//
//  PaymentSection.swift
//  BBangBBang
//
//  Created by 이돈혁 on 6/25/25.
//
//  이돈혁


import UIKit
import SnapKit

class PaymentSectionView: UIView {

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "결제 금액"
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "10,000원"
        label.font = .boldSystemFont(ofSize: 18)
        label.textColor = .black
        return label
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("전체 취소", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 22
        return button
    }()

    private let payButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("결제 하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.backgroundColor = UIColor(hex: "#FEDFA9")
        button.layer.cornerRadius = 22
        return button
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, payButton])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }

    private func setupViews() {
        let hStack = UIStackView(arrangedSubviews: [totalLabel, priceLabel])
        hStack.axis = .horizontal
        hStack.distribution = .equalSpacing

        addSubview(hStack)
        addSubview(buttonStack)

        hStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(24)
        }

        buttonStack.snp.makeConstraints { make in
            make.top.equalTo(hStack.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(24)
            make.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
}

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255
        let b = CGFloat(rgb & 0x0000FF) / 255

        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}

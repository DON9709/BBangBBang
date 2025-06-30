//
//  CartSection.swift
//  BBangBBang
//
//  Created by 이돈혁 on 6/25/25.
//
//  장은새
import UIKit

class CartSection: UITableViewCell {
    static let identifier = "CartSection"
    
    private let nameLabel = UILabel()
    private let minusButton = UIButton(type: .system)
    private let plusButton = UIButton(type: .system)
    private let quantityLabel = UILabel()
    private let priceLabel = UILabel()
    
    var onIncrease: (() -> Void)?
    var onDecrease: (() -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    private func setupUI() {
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        quantityLabel.font = UIFont.systemFont(ofSize: 16)
        quantityLabel.textAlignment = .center
        
        priceLabel.font = UIFont.systemFont(ofSize: 16)
        priceLabel.textAlignment = .right
        
        let buttonColor = UIColor(red: 255/255, green: 230/255, blue: 180/255, alpha: 1.0)
        
        [minusButton, plusButton].forEach {
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            $0.backgroundColor = buttonColor
            $0.setTitleColor(.black, for: .normal)
            $0.layer.cornerRadius = 15
            $0.layer.borderColor = UIColor(red: 255/255, green: 200/255, blue: 120/255, alpha: 1.0).cgColor
            $0.layer.borderWidth = 3
            $0.clipsToBounds = true
            $0.widthAnchor.constraint(equalToConstant: 30).isActive = true
            $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        
        minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        let buttonStack = UIStackView(arrangedSubviews: [minusButton, quantityLabel, plusButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 10
        
        let mainStack = UIStackView(arrangedSubviews: [nameLabel, buttonStack, priceLabel])
        mainStack.axis = .horizontal
        mainStack.alignment = .center
        mainStack.distribution = .equalSpacing
        
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.layer.cornerRadius = 0
        containerView.layer.borderWidth = 0
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        containerView.addSubview(mainStack)
        
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            mainStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            mainStack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            mainStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10),
            mainStack.widthAnchor.constraint(lessThanOrEqualToConstant: 60),
            quantityLabel.widthAnchor.constraint(equalToConstant: 40),
            priceLabel.widthAnchor.constraint(equalToConstant: 75),
            nameLabel.widthAnchor.constraint(equalToConstant: 75)

        ])
    }
    
    @objc private func didTapMinus() {
        onDecrease?()
    }
    
    @objc private func didTapPlus() {
        onIncrease?()
    }
    
    func configure(with item: CartItem) {
        nameLabel.text = item.name
        quantityLabel.text = "\(item.quantity)"
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let totalPrice = item.price * item.quantity
        let priceString = formatter.string(from: NSNumber(value: totalPrice)) ?? "\(totalPrice)"
        priceLabel.text = "\(priceString)원"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

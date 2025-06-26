//
//  TitleSection.swift
//  BBangBBang
//
//  Created by 이돈혁 on 6/25/25.
//
//  타이틀 만드는사람이 picker까지 만드는 걸로 합시다
//  
//  김이든

import UIKit
import SnapKit
//헤더
final class TitleSectionView: UIView {

    private let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let headerBottomBorderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 242/255, green: 229/255, blue: 234/255, alpha: 1)
        return view
    }()
    
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textAlignment = .center
        label.text = "BBangBBang"
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icon"))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.size.equalTo(24) }
        return imageView
    }()
    // lazy var는 self가 완전히 초기화된 후에 실제로 초기화
    private lazy var logoLabelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [logoImageView, headerLabel])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        [headerView, logoLabelStackView, headerBottomBorderView].forEach{ addSubview($0) }
        
        headerView.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
            $0.height.equalTo(66)
        }
        
        headerBottomBorderView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.leading.trailing.equalTo(headerView)
            $0.top.equalTo(headerView.snp.bottom)
        }
        
        logoLabelStackView.snp.makeConstraints {
            $0.center.equalTo(headerView)
        }
    }
}
//탭메뉴
final class TabMenuView: UIView {
    
    private let categoryStackView: UIStackView = {
            let stack = UIStackView()
            stack.axis = .horizontal
            stack.spacing = 12
            stack.distribution = .fillEqually
            return stack
        }()
    
    private let categories = ["빵", "음료", "디저트"]
    private var buttons: [UIButton] = []
    private var selectedIndex = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(categoryStackView)
        
        categories.enumerated().forEach { index, title in
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.darkGray, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            button.tag = index
            button.addTarget(self, action: #selector(categoryTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            categoryStackView.addArrangedSubview(button)
        }

        categoryStackView.snp.makeConstraints {
            $0.height.equalTo(44)
            $0.directionalVerticalEdges.equalToSuperview()
            $0.directionalHorizontalEdges.equalToSuperview().inset(24)
        }

        selectCategory(index: selectedIndex)
    }
    
    @objc private func categoryTapped(_ sender: UIButton) {
        selectCategory(index: sender.tag)
    }

    private func selectCategory(index: Int) {
        for (i, button) in buttons.enumerated() {
            if i == index {
                button.backgroundColor = UIColor(red: 254/255, green: 223/255, blue: 169/255, alpha: 1)
                button.setTitleColor(.black, for: .normal)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor.black.cgColor
                button.layer.cornerRadius = 22
            } else {
                button.backgroundColor = .clear
                button.layer.borderWidth = 0
                button.layer.borderColor = UIColor.clear.cgColor
                button.setTitleColor(.darkGray, for: .normal)
            }
        }
        selectedIndex = index
    }
}

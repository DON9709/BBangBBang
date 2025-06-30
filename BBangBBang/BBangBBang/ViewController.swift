//
//  ViewController.swift
//  BBangBBang
//
//  Created by 이돈혁 on 6/25/25.
//

import UIKit

class ViewController: UIViewController {

    private let titleSectionView = TitleSectionView()
    private let tabMenuView = TabMenuView()
    private let menuView = MenuView()
    private let cartView = CartViewController()
    private let paymentSectionView = PaymentSectionView()
    
    private let scrollView = UIScrollView()
    private let contentStackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHeader()
        setupTabMenu()
        setupScrollableContent()
        setupPaymentSection()
    }
    
    private func setupHeader() {
        
        view.addSubview(titleSectionView)
        
        titleSectionView.snp.makeConstraints {
            $0.height.equalTo(67)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupTabMenu() {
        
        tabMenuView.allButtons().forEach {
            $0.addTarget(self, action: #selector(tabTapped(_:)), for: .touchUpInside)
        }
        
        view.addSubview(tabMenuView)
        
        tabMenuView.snp.makeConstraints {
            $0.top.equalTo(titleSectionView.snp.bottom).offset(24)
            $0.leading.trailing.equalToSuperview()
        }
    }
    
    private func setupScrollableContent() {
        scrollView.showsVerticalScrollIndicator = false
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(tabMenuView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        scrollView.addSubview(contentStackView)
        contentStackView.axis = .vertical
        contentStackView.spacing = 64
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        contentStackView.addArrangedSubview(menuView)
        menuView.snp.makeConstraints {
            $0.height.equalTo(400)
        }

        contentStackView.addArrangedSubview(cartView.view)
        cartView.view.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        menuView.updateCategory(index: sender.tag)
    }
    
    private func setupPaymentSection() {
        view.addSubview(paymentSectionView)

        paymentSectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
    }
    
}

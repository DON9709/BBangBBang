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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupHeader()
        setupTabMenu()
        setupMenuSection()
        
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
    
    private func setupMenuSection() {
        
        view.addSubview(menuView)
        
        menuView.snp.makeConstraints {
            $0.top.equalTo(tabMenuView.snp.bottom).offset(16)
            $0.directionalHorizontalEdges.equalToSuperview()
            $0.height.equalTo(400)
        }
        
    }
    
    @objc private func tabTapped(_ sender: UIButton) {
        menuView.updateCategory(index: sender.tag)
    }
    
}


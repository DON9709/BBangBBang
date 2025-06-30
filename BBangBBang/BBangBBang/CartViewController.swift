//
//  CartViewController.swift
//  BBangBBang
//
//  Created by 이돈혁 on 6/25/25.
//
import UIKit
import SnapKit

class
CartViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let menuView = MenuView()
    
    var cartItems: [CartItem] = []
    
    let cartContainerView = UIView()
    let cartTitleLabel = UILabel()
    let tableView = UITableView()
    let totalLabel = UILabel()
    let checkoutButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        cartItems = []
        
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CartSection.self, forCellReuseIdentifier: CartSection.identifier)
        tableView.tableFooterView = UIView()
        
        checkoutButton.setTitle("결제하기", for: .normal)
        checkoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        checkoutButton.backgroundColor = UIColor.systemBlue
        checkoutButton.setTitleColor(.white, for: .normal)
        checkoutButton.layer.cornerRadius = 10
        checkoutButton.addTarget(self, action: #selector(didReceiveSelectedItem), for: .touchUpInside)
        
        cartContainerView.backgroundColor = UIColor.white
        cartContainerView.layer.cornerRadius = 22
        cartContainerView.clipsToBounds = true
        cartContainerView.layer.borderWidth = 1
        cartContainerView.layer.borderColor = UIColor.systemGray4.cgColor

        view.addSubview(cartContainerView)
        view.addSubview(checkoutButton)
        cartContainerView.addSubview(cartTitleLabel)
        cartContainerView.addSubview(tableView)
        cartContainerView.addSubview(totalLabel)

        cartTitleLabel.text = "장바구니"
        cartTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        cartTitleLabel.textColor = .black

        // Layout with SnapKit
        cartContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(checkoutButton.snp.top).offset(-10)
        }

        checkoutButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(50)
        }

        cartTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(10)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(cartTitleLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(totalLabel.snp.top)
        }

        totalLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(60)
        }
        
        totalLabel.textAlignment = .center
        totalLabel.font = UIFont.boldSystemFont(ofSize: 20)
        totalLabel.backgroundColor = UIColor.systemGray6
        
        updateTotalPrice()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveSelectedItem(_:)), name: NSNotification.Name("SelectedBreadItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(cancelAllItems), name: NSNotification.Name("CancelAllItems"), object: nil)
    }
    
    func updateTotalPrice() {
        let total = cartItems.reduce(0) { $0 + ($1.price * $1.quantity) }
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formattedTotal = formatter.string(from: NSNumber(value: total)) ?? "\(total)"
        totalLabel.text = "결제 금액: \(formattedTotal)원"
    }
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let item = cartItems[row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CartSection.identifier, for: indexPath) as? CartSection else {
            return UITableViewCell()
        }
        
        cell.configure(with: item)
        
        cell.onIncrease = { [weak self, weak cell] in
            guard let self = self,
                  let cell = cell,
                  let indexPath = self.tableView.indexPath(for: cell),
                  self.cartItems.indices.contains(indexPath.row) else { return }
            
            if self.cartItems[indexPath.row].quantity < 100 {
                self.cartItems[indexPath.row].quantity += 1
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.updateTotalPrice()
            }
        }
        
        cell.onDecrease = { [weak self, weak cell] in
            guard let self = self,
                  let cell = cell,
                  let indexPath = self.tableView.indexPath(for: cell),
                  self.cartItems.indices.contains(indexPath.row) else { return }
            
            if self.cartItems[indexPath.row].quantity > 1 {
                self.cartItems[indexPath.row].quantity -= 1
                self.tableView.reloadRows(at: [indexPath], with: .none)
                self.updateTotalPrice()
            } else {
                self.tableView.performBatchUpdates({
                    self.cartItems.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }, completion: { _ in
                    self.updateTotalPrice()
                })
            }
        }
        
        return cell
    }
    
    @objc func didReceiveSelectedItem(_ notification: Notification) {
        guard let item = notification.object as? MenuItem else { return }
            let priceValue = Int(item.price.replacingOccurrences(of: ",", with: "").replacingOccurrences(of: "원", with: "")) ?? 0

            if let index = cartItems.firstIndex(where: { $0.name == item.title }) {
                cartItems[index].quantity += 1
            } else {
                cartItems.append(CartItem(name: item.title, price: priceValue, quantity: 1))
            }
            tableView.reloadData()
            updateTotalPrice()
        }
    
    @objc func cancelAllItems() {
        cartItems.removeAll()
        tableView.reloadData()
        updateTotalPrice()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

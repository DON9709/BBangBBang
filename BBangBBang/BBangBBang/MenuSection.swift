//
//  MenuSection.swift
//  BBangBBang
//
//  Created by 이돈혁 on 6/25/25.
//
//  송명균
import UIKit
import SnapKit

// MARK: - 메뉴 데이터 모델
struct MenuItem {
    let imageName: String
    let title: String
    let price: String
}

// MARK: - 상품 뷰 (각 셀에 들어갈 1개 뷰)
class ProductView: UIView {
    
    let imageView = UIImageView()
    let titleLabel = UILabel()
    let priceLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI() {
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textColor = .black
        priceLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 6
        
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
        imageView.snp.makeConstraints { $0.height.equalToSuperview().multipliedBy(0.65) }
        
        backgroundColor = UIColor(red: 255/255, green: 230/255, blue: 180/255, alpha: 1.0) // 바깥 테두리 색상
        layer.cornerRadius = 22
        layer.borderColor = UIColor(red: 255/255, green: 200/255, blue: 120/255, alpha: 1.0).cgColor
        layer.borderWidth = 10
    }

    func configure(image: UIImage?, title: String, price: String) {
        imageView.image = image
        titleLabel.text = title
        priceLabel.text = price
    }
}

// MARK: - 메뉴 셀 (4개의 ProductView를 포함)
class MenuCell: UICollectionViewCell {
    
    private var productViews: [ProductView] = []
    private var currentItems: [MenuItem] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupProducts()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupProducts() {
        let gridStack = UIStackView()
        gridStack.axis = .vertical
        gridStack.spacing = 8
        gridStack.distribution = .fillEqually
        
        for _ in 0..<2 {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 8
            rowStack.distribution = .fillEqually
            
            for _ in 0..<2 {
                let product = ProductView()
                rowStack.addArrangedSubview(product)
                productViews.append(product)
            }
            gridStack.addArrangedSubview(rowStack)
        }
        
        contentView.addSubview(gridStack)
        gridStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(16) }
    }

    func configure(with items: [MenuItem]) {
        for (index, item) in items.enumerated() {
            if index < productViews.count {
                let productView = productViews[index]
                productView.configure(
                    image: UIImage(named: item.imageName),
                    title: item.title,
                    price: item.price
                )
                productView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(productTapped(_:)))
                productView.addGestureRecognizer(tapGesture)
                productView.tag = index
            }
        }
        self.currentItems = items
    }
    
    @objc private func productTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view else { return }
        let index = view.tag
        guard index < currentItems.count else { return }
        let selectedItem = currentItems[index]
        NotificationCenter.default.post(name: NSNotification.Name("SelectedBreadItem"), object: selectedItem)
    }
}

// MARK: - 메뉴 화면 전체 컨트롤러
class MenuView: UIView {
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPageIndicatorTintColor = .black
        pc.pageIndicatorTintColor = .lightGray
        return pc
    }()
    
    let breadItems = [
        MenuItem(imageName: "WhiteBread", title: "식빵", price: "2,000원"),
        MenuItem(imageName: "RedBeanBun", title: "단팥빵", price: "2,400원"),
        MenuItem(imageName: "Soboro", title: "소보로", price: "2,100원"),
        MenuItem(imageName: "Baguette", title: "바게트", price: "3,000원"),
        MenuItem(imageName: "Croissant", title: "크루아상", price: "2,300원"),
        MenuItem(imageName: "Ang-butter", title: "앙버터", price: "3,500원"),
        MenuItem(imageName: "Croquette", title: "고로케", price: "2,800원"),
        MenuItem(imageName: "Muffin", title: "머핀", price: "1,500원")
    ]

    let drinkItems = [
        MenuItem(imageName: "Americano", title: "아메리카노", price: "2,500원"),
        MenuItem(imageName: "VanillaLatte", title: "바닐라라떼", price: "3,200원"),
        MenuItem(imageName: "CaramelMacchiato", title: "카라멜마끼아또", price: "3,500원"),
        MenuItem(imageName: "Einspanner", title: "아인슈페너", price: "3,800원"),
        MenuItem(imageName: "Milk", title: "우유", price: "2,000원"),
        MenuItem(imageName: "OrangeJuice", title: "오렌지 주스", price: "2,800원"),
        MenuItem(imageName: "StrawberryLatte", title: "딸기라떼", price: "3,800원"),
        MenuItem(imageName: "Matchalatte", title: "말차라떼", price: "3,500원")
    ]

    let dessertItems = [
        MenuItem(imageName: "Macaroon", title: "마카롱", price: "3,000원"),
        MenuItem(imageName: "Tart", title: "타르트", price: "1,500원"),
        MenuItem(imageName: "ChocoCake", title: "초코케익", price: "4,000원"),
        MenuItem(imageName: "ChocoCookie", title: "초코쿠키", price: "1,800원"),
        MenuItem(imageName: "Tiramisu", title: "티라미슈", price: "4,500원"),
        MenuItem(imageName: "AlmondCookie", title: "아몬드쿠키", price: "2,000원"),
        MenuItem(imageName: "CarrotCake", title: "당근케익", price: "4,000원"),
        MenuItem(imageName: "CheeseCake", title: "치즈케익", price: "4,200원")
    ]
    
    var pagedItems: [[MenuItem]] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        setupLayout()
        updateCategory(index: 0)
        
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCollectionView()
        setupLayout()
        updateCategory(index: 0)
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
    }

    private func setupLayout() {
        collectionView.backgroundColor = .white
        addSubview(collectionView)
        addSubview(pageControl)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }

    func updateCategory(index: Int) {
        let source: [MenuItem] = {
            switch index {
            case 0: return breadItems
            case 1: return drinkItems
            case 2: return dessertItems
            default: return []
            }
        }()

        // 4개씩 끊어 pagedItems 재생성
        pagedItems = stride(from: 0, to: source.count, by: 4).map {
            Array(source[$0 ..< min($0 + 4, source.count)])
        }

        // UI 리셋
        pageControl.numberOfPages = pagedItems.count
        pageControl.currentPage   = 0
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
    }
}

// MARK: - CollectionView Delegate & DataSource
extension MenuView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagedItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: pagedItems[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.frame.size
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = page
    }
}

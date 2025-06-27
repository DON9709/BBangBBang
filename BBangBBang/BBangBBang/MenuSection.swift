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
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.textAlignment = .center
        
        priceLabel.font = .boldSystemFont(ofSize: 16)
        priceLabel.textAlignment = .center
        
        let stack = UIStackView(arrangedSubviews: [imageView, titleLabel, priceLabel])
        stack.axis = .vertical
        stack.spacing = 6
        
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        imageView.snp.makeConstraints { $0.height.equalToSuperview().multipliedBy(0.65) }
        
        backgroundColor = .white
        layer.borderColor = UIColor.brown.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 12
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
        gridStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }
    }

    func configure(with items: [MenuItem]) {
        for (index, item) in items.enumerated() {
            if index < productViews.count {
                productViews[index].configure(
                    image: UIImage(named: item.imageName),
                    title: item.title,
                    price: item.price
                )
            }
        }
    }
}

// MARK: - 메뉴 화면 전체 컨트롤러
class MenuViewController: UIViewController {
    
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
    
    var pagedItems: [[MenuItem]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupDummyData()
        setupCollectionView()
        setupLayout()
    }

    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MenuCell.self, forCellWithReuseIdentifier: "MenuCell")
    }

    private func setupLayout() {
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(400)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }
    }

    private func setupDummyData() {
        let breadItems = [
                MenuItem(imageName: "WhiteBread", title: "식빵", price: "2,000원"),
                MenuItem(imageName: "RedBeanBun", title: "단팥빵", price: "2,400원"),
                MenuItem(imageName: "Soboro", title: "소보로", price: "2,100원"),
                MenuItem(imageName: "Baguette", title: "바게트", price: "3,000원"),
                MenuItem(imageName: "Croissant", title: "크루아상", price: "2,300원"),
                MenuItem(imageName: "Ang-butter", title: "앙버터", price: "3,500원"),
                MenuItem(imageName: "Croquette", title: "고로케", price: "2,800원"),
                MenuItem(imageName: "GarlicBread", title: "마늘빵", price: "2,500원")
            ]

            let drinkItems = [
                MenuItem(imageName: "Americano", title: "아메리카노", price: "2,500원"),
                MenuItem(imageName: "VanillaLatte", title: "바닐라라떼", price: "3,200원"),
                MenuItem(imageName: "CaramelMacchiato", title: "카라멜마끼아또", price: "3,500원"),
                MenuItem(imageName: "Einspanner", title: "아인슈페너", price: "3,800원"),
                MenuItem(imageName: "Milk", title: "우유", price: "2,000원"),
                MenuItem(imageName: "OrangeJuice", title: "오렌지 주스", price: "2,800원"),
                MenuItem(imageName: "StrawberryLatte", title: "딸기라떼", price: "3,800원"),
                MenuItem(imageName: "MatchaLatte", title: "말차라떼", price: "3,500원")
            ]

            let dessertItems = [
                MenuItem(imageName: "Macaron", title: "마카롱", price: "3,000원"),
                MenuItem(imageName: "Tart", title: "타르트", price: "1,500원"),
                MenuItem(imageName: "ChocoCake", title: "초코케익", price: "4,000원"),
                MenuItem(imageName: "ChocoCookie", title: "초코쿠키", price: "1,800원"),
                MenuItem(imageName: "Tiramisu", title: "티라미슈", price: "4,500원"),
                MenuItem(imageName: "AlmondCookie", title: "아몬드쿠키", price: "2,000원"),
                MenuItem(imageName: "CarrotCake", title: "당근케익", price: "4,000원"),
                MenuItem(imageName: "Cheesecake", title: "치즈케익", price: "4,200원")
            ]
        pagedItems = stride(from: 0, to: BreadItems.count, by: 4).map {
            Array(BreadItems[$0..<min($0+4, BreadItems.count)])
        }

        pageControl.numberOfPages = pagedItems.count
    }
}

// MARK: - CollectionView Delegate & DataSource
extension MenuViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

//
//  WaterfallVC.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/15.
//

import UIKit

class WaterfallVC: RKBaseVC {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    /// UI
    func setupUI() {
        let layout = RkWaterfallFlowLayout()
        layout.delegate = self
        let collection = UICollectionView(frame: CGRect(x: 0, y: rkNaviHeight, width: rkScreenWidth, height: rkScreenHeight - rkNaviHeight), collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.register(WaterfallCell.self, forCellWithReuseIdentifier: WaterfallCell.identifiers)
        collection.register(WaterfallReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: WaterfallReusableView.header)
        collection.register(WaterfallReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: WaterfallReusableView.footer)
        view.addSubview(collection)
    }

    private func sectionName(section: Int) -> String {
        switch section {
        case 0:
            return "瀑布流布局"
        case 1:
            return "线性列表布局"
        case 2:
            return "九宫格布局"
        default:
            return ""
        }
    }
}

// MARK: - UICollectionViewDelegate、UICollectionViewDataSource

extension WaterfallVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        // 瀑布流
        case 0:
            return 9
        // 线性
        case 1:
            return 3
        // 九宫格
        default:
            return 9
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WaterfallCell.identifiers, for: indexPath) as! WaterfallCell
        cell.nameL.text = " \(indexPath.section) section \(indexPath.row) item"
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: WaterfallReusableView.header,
                for: indexPath
            ) as! WaterfallReusableView
            header.nameL.text = "\(sectionName(section: indexPath.section)) header view"
            header.backgroundColor = .purple
            return header
        } else if kind == UICollectionView.elementKindSectionFooter {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: WaterfallReusableView.footer,
                for: indexPath
            ) as! WaterfallReusableView
            footer.nameL.text = "\(sectionName(section: indexPath.section)) footer view"
            footer.backgroundColor = .systemBlue
            return footer
        }
        return UICollectionReusableView()
    }
}

extension WaterfallVC: RkWaterfallFlowDelegate {
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat {
        switch indexPath.section {
        case 0:
            return CGFloat((arc4random() % 3 + 1) * 30)
        case 1:
            return 90
        default:
            return 60
        }
    }

    func columnNumber(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        default:
            return 3
        }
    }

    func referenceSizeForHeader(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 40)
    }

    func referenceSizeForFooter(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 30)
    }

    func insetForSection(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    func lineSpacing(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGFloat {
        return 5
    }

    func interitemSpacing(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGFloat {
        return 5
    }

    func spacingWithLastSection(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGFloat {
        return 15
    }
}

// MARK: - cell

class WaterfallCell: UICollectionViewCell {
    static let identifiers = "WaterfallCellIdentifiers"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configBaseView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configBaseView() {
        backgroundColor = .darkGray
        addSubview(nameL)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameL.frame = bounds
    }

    lazy var nameL: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}

// MARK: - header

class WaterfallReusableView: UICollectionReusableView {
    static let header = "WaterfallHeader"
    static let footer = "WaterfallFooter"
    override init(frame: CGRect) {
        super.init(frame: frame)
        configBaseView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configBaseView() {
        addSubview(nameL)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        nameL.frame = bounds
    }

    lazy var nameL: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
}

//
//  RkWaterfallFlowLayout.swift
//  RKProject
//
//  Created by yunbao02 on 2025/1/15.
//

import UIKit

@objc protocol RkWaterfallFlowDelegate: NSObjectProtocol {
    /// require
    /// item 高度
    func heightForRowAtIndexPath(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, indexPath: IndexPath, itemWidth: CGFloat) -> CGFloat

    /// optional
    /// 每个section 列数（默认2列）
    @objc optional func columnNumber(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> Int

    /// header高度（默认为0）
    @objc optional func referenceSizeForHeader(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGSize

    /// footer高度（默认为0）
    @objc optional func referenceSizeForFooter(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGSize

    /// 每个section 边距（默认为0）
    @objc optional func insetForSection(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> UIEdgeInsets

    /// 每个section item上下间距（默认为0）
    @objc optional func lineSpacing(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGFloat

    /// 每个section item左右间距（默认为0）
    @objc optional func interitemSpacing(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGFloat

    /// section头部header与上个section尾部footer间距（默认为0）
    @objc optional func spacingWithLastSection(collectionView collection: UICollectionView, layout: RkWaterfallFlowLayout, section: Int) -> CGFloat
}

class RkWaterfallFlowLayout: UICollectionViewFlowLayout {
    weak var delegate: RkWaterfallFlowDelegate?

    private var sectionInsets: UIEdgeInsets = .zero
    private var columnCount = 2
    private var lineSpacing: CGFloat = 0
    private var interitemSpacing: CGFloat = 0
    private var headerSize: CGSize = .zero
    private var footerSize: CGSize = .zero

    // 存放attribute的数组
    private var attrsArray: [UICollectionViewLayoutAttributes] = []
    // 存放每个section中各个列的最后一个高度
    private var columnHeights: [CGFloat] = []
    // collectionView的Content的高度
    private var contentHeight: CGFloat = 0
    // 记录上个section高度最高一列的高度
    private var lastContentHeight: CGFloat = 0
    // 每个section的header与上个section的footer距离
    private var spacingWithLastSection: CGFloat = 0

    override func prepare() {
        super.prepare()
        contentHeight = 0
        lastContentHeight = 0
        spacingWithLastSection = 0
        lineSpacing = 0
        sectionInsets = .zero
        headerSize = .zero
        footerSize = .zero
        columnHeights.removeAll()
        attrsArray.removeAll()

        let sectionCount = collectionView!.numberOfSections
        // 遍历section
        for idx in 0..<sectionCount {
            let indexPath = IndexPath(item: 0, section: idx)
            if let columnCount = delegate?.columnNumber?(collectionView: collectionView!, layout: self, section: indexPath.section) {
                self.columnCount = columnCount
            }
            if let inset = delegate?.insetForSection?(collectionView: collectionView!, layout: self, section: indexPath.section) {
                sectionInsets = inset
            }
            if let spacingLastSection = delegate?.spacingWithLastSection?(collectionView: collectionView!, layout: self, section: indexPath.section) {
                spacingWithLastSection = spacingLastSection
            }
            // 生成header
            let itemCount = collectionView!.numberOfItems(inSection: idx)
            let headerAttri = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            if let header = headerAttri {
                attrsArray.append(header)
                columnHeights.removeAll()
            }
            lastContentHeight = contentHeight
            // 初始化区 y值
            for _ in 0..<columnCount {
                columnHeights.append(contentHeight)
            }
            // 多少个item
            for item in 0..<itemCount {
                let indexPat = IndexPath(item: item, section: idx)
                let attri = layoutAttributesForItem(at: indexPat)
                if let attri = attri {
                    attrsArray.append(attri)
                }
            }

            // 初始化footer
            let footerAttri = layoutAttributesForSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, at: indexPath)
            if let footer = footerAttri {
                attrsArray.append(footer)
            }
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        if let column = delegate?.columnNumber?(collectionView: collectionView!, layout: self, section: indexPath.section) {
            columnCount = column
        }
        if let lineSpacing = delegate?.lineSpacing?(collectionView: collectionView!, layout: self, section: indexPath.section) {
            self.lineSpacing = lineSpacing
        }
        if let interitem = delegate?.interitemSpacing?(collectionView: collectionView!, layout: self, section: indexPath.section) {
            interitemSpacing = interitem
        }

        let attri = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let weight = collectionView!.frame.size.width
        let itemSpacing = CGFloat(columnCount - 1) * interitemSpacing
        let allWeight = weight - sectionInsets.left - sectionInsets.right - itemSpacing
        let cellWeight = allWeight / CGFloat(columnCount)
        let cellHeight: CGFloat = (delegate?.heightForRowAtIndexPath(collectionView: collectionView!, layout: self, indexPath: indexPath, itemWidth: cellWeight))!

        var tmpMinColumn = 0
        var minColumnHeight = columnHeights[0]
        for i in 0..<columnCount {
            let columnH = columnHeights[i]
            if minColumnHeight > columnH {
                minColumnHeight = columnH
                tmpMinColumn = i
            }
        }
        let cellX = sectionInsets.left + CGFloat(tmpMinColumn) * (cellWeight + interitemSpacing)
        var cellY: CGFloat = 0
        cellY = minColumnHeight
        if cellY != lastContentHeight {
            cellY += lineSpacing
        }

        if contentHeight < minColumnHeight {
            contentHeight = minColumnHeight
        }

        attri.frame = CGRect(x: cellX, y: cellY, width: cellWeight, height: cellHeight)
        columnHeights[tmpMinColumn] = attri.frame.maxY
        // 取最大的
        for i in 0..<columnHeights.count {
            if contentHeight < columnHeights[i] {
                contentHeight = columnHeights[i]
            }
        }

        return attri
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attri = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        if elementKind == UICollectionView.elementKindSectionHeader {
            if let headerSize = delegate?.referenceSizeForHeader?(collectionView: collectionView!, layout: self, section: indexPath.section) {
                self.headerSize = headerSize
            }
            contentHeight += spacingWithLastSection
            attri.frame = CGRect(x: 0, y: contentHeight, width: headerSize.width, height: headerSize.height)
            contentHeight += headerSize.height
            contentHeight += sectionInsets.top
        } else if elementKind == UICollectionView.elementKindSectionFooter {
            if let footerSize = delegate?.referenceSizeForFooter?(collectionView: collectionView!, layout: self, section: indexPath.section) {
                self.footerSize = footerSize
            }
            contentHeight += sectionInsets.bottom
            attri.frame = CGRect(x: 0, y: contentHeight, width: footerSize.width, height: footerSize.height)
            contentHeight += footerSize.height
        }
        return attri
    }

    override var collectionViewContentSize: CGSize {
        return CGSize(width: collectionView!.frame.size.width, height: contentHeight)
    }
}


//
//  WallImagesCollectionViewLayout.swift
//  VK Client
//
//  Created by Артём Калинин on 24.03.2021.
//

import UIKit

class WallImagesCollectionViewLayout: UICollectionViewLayout {
    
    var cacheAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    // Хранит атрибуты для заданных индексов
    
    var columnsCount = 2                  // Количество столбцов
    
    private var totalCellsHeight: CGFloat = 0 // Хранит суммарную высоту всех ячеек
    
    override func prepare() {
        self.cacheAttributes = [:] // Инициализируем атрибуты
        
        // Проверяем наличие collectionView
        guard let collectionView = self.collectionView else { return }
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        // Проверяем, что в секции есть хотя бы одна ячейка
        guard itemsCount > 0 else { return }
        
        let width = collectionView.bounds.width
        let horizontalInsets = collectionView.contentInset.left + collectionView.contentInset.right
        let verticalInsets = collectionView.contentInset.top + collectionView.contentInset.bottom
        
        let bigCellWidth = width - horizontalInsets
        let smallCellWidth = (width - horizontalInsets) / CGFloat(self.columnsCount)
        
        let height = collectionView.bounds.height
        let bigCellHeight = height - verticalInsets
        let smallCellHeight = (height - verticalInsets) / CGFloat(self.columnsCount)
        
        var lastY: CGFloat = 0
        var lastX: CGFloat = 0
        
        for index in 0..<itemsCount {
            let indexPath = IndexPath(item: index, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let isLastColumn = (index + 1) % self.columnsCount == 0
            
            if itemsCount == 1 {
                attributes.frame = CGRect(x: 0, y: 0,
                                          width: bigCellWidth, height: bigCellHeight)
                lastY += bigCellHeight
            } else if itemsCount == 2 {
                attributes.frame = CGRect(x: lastX, y: 0,
                                          width: smallCellWidth, height: bigCellHeight)
                if !isLastColumn {
                    lastX += smallCellWidth
                } else {
                    lastY += bigCellHeight
                }
            } else {
                attributes.frame = CGRect(x: lastX, y: lastY,
                                          width: smallCellWidth, height: smallCellHeight)
                if isLastColumn {
                    lastX = 0
                    lastY += smallCellHeight
                } else {
                    lastX += smallCellWidth
                }
            }
            
            cacheAttributes[indexPath] = attributes
        }
        
        self.totalCellsHeight = lastY
        
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cacheAttributes.values.filter { attributes in
            return rect.intersects(attributes.frame)
        }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cacheAttributes[indexPath]
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: self.collectionView?.frame.width ?? 0,
                      height: self.totalCellsHeight)
    }
}

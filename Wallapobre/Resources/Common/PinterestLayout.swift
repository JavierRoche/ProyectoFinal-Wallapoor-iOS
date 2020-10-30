//
//  PinterestLayout.swift
//  UICollectionViewCustomLayout
//
//  Created by Roberto Garrido on 10/05/2020.
//  Copyright © 2020 Roberto Garrido. All rights reserved.
//

import UIKit

protocol PinterestLayoutDelegate: class {
    func collectionView(_ collectionView: UICollectionView, heightForCellAtIndexPath indexPath: IndexPath) -> CGFloat
}

class PinterestLayout: UICollectionViewLayout {

    // El delegate al que consultamos cuál es alto de la celda en un determinado indexPath
    weak var delegate: PinterestLayoutDelegate?

    var numberOfColumns: Int = 2

    // Distancia entre elementos
    private let interItemSpacing: CGFloat = 6

    // La altura total del contenido
    private var contentHeight: CGFloat = 0

    // La anchura total del contenido
    private var contentWidth: CGFloat {
        guard let collectionView = collectionView else { return 0 }

        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }

    // Una cache donde guardaremos los layout attributes y así no recalcularlos cada vez si no es necesario
    private var cache: [UICollectionViewLayoutAttributes] = []

    // Retornar el ancho y alto del contenido de la colección
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }

    // Este método es llamado por UIKit la primera vez que se calcula el layout
    // así como tantas veces como el layout sea invalidado, bien implícita, o explícitamente
    // Aprovechamos para calcular el layout y cachearlo en un array, para luego
    // no tener que volver a hacerlo en layoutAttributesForElements / layoutAttributesForItem
    override func prepare() {
        // Nos aseguramos de que la cache está vacía, sino, no tenemos que hacerlo
        guard cache.isEmpty, let collectionView = collectionView else {
            return
        }

        let columnWidth = contentWidth / CGFloat(numberOfColumns)
        var xOffset: [CGFloat] = []
        for column in 0 ..< numberOfColumns {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        var column = 0
        var yOffset: [CGFloat] = .init(repeating: 0, count: numberOfColumns)

        // Recorremos todos los items de la sección (sólo hay una)
        for item in 0 ..< collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item: item, section: 0)

            // Calculamos el frame de del item actual
            let photoHeight = delegate?.collectionView(collectionView, heightForCellAtIndexPath: indexPath) ?? 180
            let height = interItemSpacing * 2 + photoHeight
            let frame = CGRect(x: xOffset[column],
                               y: yOffset[column],
                               width: columnWidth,
                               height: height)
            let insetFrame = frame.insetBy(dx: interItemSpacing, dy: interItemSpacing)

            // Creamos el objeto attributes de este item, y establecemos el frame que acabamos de calcular
            // Lo añadimos a la cache
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)

            // Expandimos el contentHeight para que contenga el nuevo frame que acabamos de añadir
            // Avanzamos el yOffset para la columna actual
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + height

            // Avanzamos la columna
            column = column < (numberOfColumns - 1) ? (column + 1) : 0
        }
    }

    // Retornar los layout attributes de todas las celdas que existen en el rectángulo
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes: [UICollectionViewLayoutAttributes] = []

        // Recorremos la cache y buscamos los items que están dentro del rect que nos pasan
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        return visibleLayoutAttributes
    }

    // Retornar los layout attributes del item que se encuentra en este indexPath
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
}

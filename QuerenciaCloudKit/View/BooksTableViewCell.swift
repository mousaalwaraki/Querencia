//
//  BooksTableViewCell.swift
//  QuerenciaCloudKit
//
//  Created by Mousa Alwaraki on 11/10/20.
//

import UIKit
import SafariServices

class BooksTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var containingView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var books: [Resource] = []
    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        books.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BooksCollectionCell", for: indexPath) as! BooksCollectionViewCell
        let book = books[indexPath.item]
        
        cell.bookCover.hnk_setImageFromURL(URL(string: book.imageUrl)!)
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let resourceUrlString = books[indexPath.row].actionUrl
        let resourceUrl = URL(string: resourceUrlString)
        let vc = SFSafariViewController(url: resourceUrl!)
        UIApplication.shared.windows.first?.rootViewController?.present(vc, animated: true)
    }
}

class BooksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var bookCover: UIImageView!
    
}


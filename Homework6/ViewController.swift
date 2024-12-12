import UIKit
import SnapKit

/// https://medium.com/@tahaozmn/swift-collection-view-uikit-bf9e528a0491
class ViewController: UIViewController, UICollectionViewDataSource {
    var processedImages: [UIImage] = []
    var imageProcessor = ImageProcessor()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        let imageNames = ["image1", "image2", "image3"]
        var images: [UIImage] = []
        
        for name in imageNames {
            if let image = UIImage(named: name) {
                images.append(image)
                print(image)
            }
        }
        processBatchConcurrently(images: images)
    }

    func processBatchConcurrently(images: [UIImage]) {
        let queue = DispatchQueue(label: "imageProcessing", attributes: .concurrent)
        
        for image in images {
            queue.async {
                if let processedImage = self.imageProcessor.processImage(image: image) {
                    DispatchQueue.main.async {
                        self.processedImages.append(processedImage)
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 300, height: 300)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self

        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCell")

        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return processedImages.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath)
                as? ImageCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        cell.imageView.image = processedImages[indexPath.row]
        return cell
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupImageView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupImageView()
    }

    private func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

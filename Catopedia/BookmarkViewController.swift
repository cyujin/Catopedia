//
//  BookmarkViewController.swift
//  Catopedia
//
//  Created by hansung on 2023/06/17.
//

import UIKit
import Firebase

class BookmarkViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var catBreeds: [CatBreed] = [] //모든 고양이 정보를 저장하는 배열
    var bookmarkedCats: [CatBreed] = [] //북마크된 고양이 정보를 저장하는 배열
    let db = Firestore.firestore() //Firebase Firestore 데이터베이스 인스턴스
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        //delegate, dateSource 설정
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //API로부터 고양이 데이터셋 받아옴
        CatData().fetchCatBreeds { (breeds, error) in
            if let error = error {
                print("Error fetching cat breeds: \(error)")
            } else if let breeds = breeds {
                self.catBreeds = breeds //로드된 데이터를 catBreeds 배열에 저장
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //북마크된 고양이 정보 로드
        loadBookmarkedCats()
    }
    //collectionView에 표시할 아이템 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return bookmarkedCats.count
        }
    //각 아이템에 대한 셀을 반환하는 메소드
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as! CatCollectionViewCell
        let cat = bookmarkedCats[indexPath.item] //해당 인덱스의 고양이 정보를 가져옴
        cell.nameLabel.text = cat.name //셀의 라벨에 고양이 이름을 표시
            
        //고양이 이미지 로드
        let url = URL(string: cat.image?.url ?? "")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("Failed downloading image: ", error)
                return
            }
            DispatchQueue.main.async {
                //셀의 이미지 뷰에 로드한 이미지 설정
                cell.imageView.image = UIImage(data: data!)
            }
        }.resume()

        return cell
    }
    
    //Firestore에서 북마크된 고양이 정보를 로드하는 메소드
    func loadBookmarkedCats() {
        self.bookmarkedCats = [] //배열 초기화
        db.collection("bookmarks").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let id = document.documentID
                    //북마크된 고양이의 id와 일치하는 고양이를 찾아서 bookmarkedCats 배열에 추가
                    if let cat = self.catBreeds.first(where: { $0.id == id }) {
                        self.bookmarkedCats.append(cat)
                    }
                }
                //collectionView 새로고침합니다.
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    //CatBreedDetailViewController로 넘어갈 때 실행
    //세그웨이를 사용하여 선택한 고양이 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCatBreedDetail",
            let detailViewController = segue.destination as? CatBreedDetailViewController,
            let indexPath = collectionView.indexPathsForSelectedItems?.first {
            detailViewController.catBreed = bookmarkedCats[indexPath.row]
        }
    }
}

//셀의 크기, 섹션 내의 아이템 간의 간격, 섹션의 여백 등을 조정
extension BookmarkViewController: UICollectionViewDelegateFlowLayout {
    //셀 크기 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 200)
    }
    //아이템 간의 최소 간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    //섹션의 여백 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20) // 좌우 여백을 원하는 값으로 조정합니다.
    }

}

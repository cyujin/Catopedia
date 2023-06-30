//
//  CatBreedDetailViewController.swift
//  Catopedia
//
//  Created by hansung on 2023/06/16.
//

import UIKit
import Firebase

class CatBreedDetailViewController: UIViewController {
    var catBreed: CatBreed? //전달받은 고양이 품종 정보를 저장할 변수

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var catImageView: UIImageView!
    @IBOutlet weak var bookmarkButton: UIBarButtonItem!
    @IBOutlet weak var originLabel: UILabel!
    @IBOutlet weak var lifespanLabel: UILabel!
    @IBOutlet weak var intelligentLabel: UILabel!
    @IBOutlet weak var energylevelLabel: UILabel!
    @IBOutlet weak var affectionlevelLabel: UILabel!
    @IBOutlet weak var sheddinglevelLabel: UILabel!
    @IBOutlet weak var alergyLabel: UILabel!
    @IBOutlet weak var temperamentLabel: UITextView!

    let db = Firestore.firestore()  //Firestore 데이터베이스 인스턴스 생성
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //catBreed 변수에서 고양이 정보를 가져와서 표시
        nameLabel.text = catBreed?.name
        descriptionTextView.text = catBreed?.description
        originLabel.text = catBreed?.origin
        lifespanLabel.text = catBreed?.life_span
        intelligentLabel.text = String(catBreed?.intelligence ?? 0) + " / 5"
        affectionlevelLabel.text = String(catBreed?.affection_level ?? 0) + " / 5"
        energylevelLabel.text = String(catBreed?.energy_level ?? 0) + " / 5"
        sheddinglevelLabel.text = String(catBreed?.shedding_level ?? 0) + " / 5"
        alergyLabel.text = String(catBreed?.hypoallergenic ?? 0) + " / 5"
        temperamentLabel.text = "성격  :  " + (catBreed?.temperament ?? "")
        
        //고양이 이미지를 로드하고 표시
        if let imageUrlString = catBreed?.image?.url, //옵셔널 바인딩을 이용해서 imageUrl을 추출
            let imageUrl = URL(string: imageUrlString) { //imageUrlString을 URL로 변환

            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageUrl), //이미지 데이터를 로드
                    let image = UIImage(data: imageData) { //이미지 데이터를 UIImage로 변환
                    DispatchQueue.main.async { //메인 스레드에서 이미지 뷰에 이미지를 설정
                        self.catImageView.image = image
                    }
                }
            }
        }
        //북마크 상태를 로드
        loadBookmarkState()
    }
    //Firestore에서 북마크 상태를 로드하는 메소드
    func loadBookmarkState() {
        guard let catBreed = catBreed else { return }
            
        db.collection("bookmarks").document(catBreed.id).getDocument { (document, error) in
            if let error = error {
                print("Error getting document: \(error)")
            } else {
                let isBookmarked = document?.exists ?? false
                self.bookmarkButton.isSelected = isBookmarked //북마크 상태를 바탕으로 버튼의 상태를 업데이트
            }
        }
    }

    @IBAction func bookmarkButtonTapped(_ sender: UIBarButtonItem) {
        guard let catBreed = catBreed else { return }
        
        //북마크 버튼을 눌렀을 때, 현재 북마크의 상태에 따라 북마크를 추가, 제거
        if sender.isSelected {
            //이미 북마크되어 있으면 북마크를 해제
            db.collection("bookmarks").document(catBreed.id).delete() { error in
                if let error = error {
                    print("Error removing document: \(error)")
                } else {
                    sender.isSelected = false
                }
            }
        } else {
            //아직 북마크되어 있지 않으면 북마크를 추가
            db.collection("bookmarks").document(catBreed.id).setData(["id": catBreed.id]) { error in
                if let error = error {
                    print("Error adding document: \(error)")
                } else {
                    sender.isSelected = true
                }
            }
        }
    }
}

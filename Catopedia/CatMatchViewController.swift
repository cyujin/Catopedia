//
//  CatMatchViewController.swift
//  Catopedia
//
//  Created by hansung on 2023/06/17.
//

import UIKit

class CatMatchViewController: UIViewController {

    var catBreeds: [CatBreed] = [] //API에서 받아온 고양이 목록 저장
    var filteredCat: [CatBreed] = [] //필터링된 고양이 목록 저장

    @IBOutlet weak var affectionateButton: UIButton!
    @IBOutlet weak var intelligentButton: UIButton!
    @IBOutlet weak var playfulButton: UIButton!
    @IBOutlet weak var socialButton: UIButton!
    @IBOutlet weak var livelyButton: UIButton!
    @IBOutlet weak var gentleButton: UIButton!
    @IBOutlet weak var loyalButton: UIButton!
    @IBOutlet weak var energeticButton: UIButton!
    @IBOutlet weak var calmButton: UIButton!
    @IBOutlet weak var agileButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //API로부터 고양이 데이터셋 받아옴
        CatData().fetchCatBreeds { (breeds, error) in
            if let error = error {
                print("Error fetching cat breeds: \(error)")
            } else if let breeds = breeds {
                self.catBreeds = breeds //받아온 데이터를 catBreeds 배열에 저장
                self.filteredCat = breeds //필터링 목록을 모든 품종으로 초기화
                for _ in breeds {
                    print("API Data Fetch")
                }
            }
        }
    }
    
    //사용자의 선택에 따라 필터링을 수행하는 메소드
    func filterBreeds() {
        //필터링 목록을 모든 품종으로 초기화
        filteredCat = catBreeds
        
        //각 버튼의 선택 상태에 따라 필터링
        if affectionateButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Affectionate") }
        }
        if intelligentButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Intelligent") }
        }
        if playfulButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Playful") }
        }
        if socialButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Social") }
        }
        if livelyButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Lively") }
        }
        if gentleButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Gentle") }
        }
        if loyalButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Loyal") }
        }
        if energeticButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Energetic") }
        }
        if calmButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Calm") }
        }
        if agileButton.isSelected {
            filteredCat = filteredCat.filter { $0.temperament.contains("Agile") }
        }
        
    }
  
    //CatMatchResultViewController로 넘어갈 때 실행
    //세그웨이를 사용하여 필터링된 고양이 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMatchResult", //세그웨이 식별자
           let resultViewController = segue.destination as? CatMatchResultViewController {

            filterBreeds() //필터링 함수 호출
            
            //필터링된 목록을 다음 뷰 컨트롤러에 전달합니다.
            resultViewController.filteredCat = filteredCat
        }
    }
    //키워드 버튼 탭되었을 때 액션
    @IBAction func affectionateButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds() //필터링 수행
    }
    @IBAction func intelligentButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func playfulButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func socialButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func livelyButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func gentleButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func loyalButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func energeticButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func calmButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    @IBAction func agileButtonTapped(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        filterBreeds()
    }
    
}

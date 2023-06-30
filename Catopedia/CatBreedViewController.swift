//
//  ViewController.swift
//  Catopedia
//
//  Created by hansung on 2023/06/13.
//

import UIKit

class CatBreedViewController: UIViewController {

    @IBOutlet weak var catBreedPickerView: UIPickerView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var catBreeds: [CatBreed] = [] //전체 고양이 데이터셋 저장하는 배열
    var filteredCatBreeds: [CatBreed] = [] //검색으로 필터링된 고양이 저장하는 배열
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate, dateSource 설정
        catBreedPickerView.dataSource = self
        catBreedPickerView.delegate = self
        searchBar.delegate = self

        //API로부터 고양이 데이터셋 받아옴
        CatData().fetchCatBreeds { (breeds, error) in
            if let error = error {
                print("Error fetching cat breeds: \(error)")
            } else if let breeds = breeds {
                self.catBreeds = breeds
                self.filteredCatBreeds = breeds //필터링 목록 초기화
                for breed in breeds {
                    DispatchQueue.main.async {
                        self.catBreedPickerView.reloadAllComponents()
                    }
                    
                    print("Breed ID: \(breed.id), Breed Name: \(breed.name), Description: \(breed.description), Life Span: \(breed.life_span)")
                }
            }
        }
    }
}
//현재 선택된 고양이를 가져오는 메소드
extension CatBreedViewController {
    func getSelectedBreed() -> CatBreed {
        return catBreeds[catBreedPickerView.selectedRow(inComponent: 0)]
    }
}

extension CatBreedViewController: UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate {
    //PickerView의 컴포넌트 개수 반환
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    //PickerView의 각 컴포넌트별 row 개수 반환
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return catBreeds.count
        return filteredCatBreeds.count
    }
    //PickerView의 각 컴포넌트와 row에 대한 title 반환
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredCatBreeds[row].name
    }
    //CatBreedDetailViewController로 넘어갈 때 실행
    //세그웨이를 사용하여 선택한 고양이 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCatBreedDetail",
            let detailViewController = segue.destination as? CatBreedDetailViewController {
                let selectedRow = catBreedPickerView.selectedRow(inComponent: 0)
                detailViewController.catBreed = filteredCatBreeds[selectedRow] //선택한 고양이의 정보를 전달
        }
    }
    //검색 결과에 따라 고양이를 필터링하는 메소드
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCatBreeds = catBreeds
        } else {
            filteredCatBreeds = catBreeds.filter { catBreed in
                catBreed.name.lowercased().contains(searchText.lowercased()) //대소문자 구분하지 않기위해 lowercased()메서드 사용
            }
        }
        catBreedPickerView.reloadAllComponents()
    }

}

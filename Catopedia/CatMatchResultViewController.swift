//
//  CatMatchResultViewController.swift
//  Catopedia
//
//  Created by hansung on 2023/06/17.
//

import Foundation
import UIKit


class CatMatchResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
     
    var filteredCat: [CatBreed] = [] //필터링 된 고양이 데이터
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //delegate, dateSource 설정
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //테이블 뷰의 행 수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCat.count
    }
    //테이블 뷰의 각 행의 내용 반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! CatTableViewCell
        
        let cat = filteredCat[indexPath.row] //현재 행에 해당하는 고양이 데이터를 가져옴
        cell.nameLabel.text = cat.name //고양이 이름을 표시
        cell.accessoryType = .detailDisclosureButton //상세 정보 버튼을 표시
        
        //고양이 이미지를 로드하고 표시
        if let imageURL = cat.image?.url {
            let url = URL(string: imageURL)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print("Failed downloading image: ", error)
                    return
                }
                //메인 스레드에서 이미지 뷰에 이미지를 설정
                DispatchQueue.main.async {
                    cell.catImageView.image = UIImage(data: data!)
                }
            }.resume()
        } else {
            //imageURL이 nil이면 기본 이미지 표시
            cell.catImageView.image = UIImage(named: "defaultImage")
        }
        return cell
    }
    
    //테이블 뷰의 행이 선택되었을 때 호출
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //선택 효과를 해제
    }
    //CatBreedDetailViewController로 넘어갈 때 실행
    //세그웨이를 사용하여 선택한 고양이 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowCatBreedDetail",
            let detailViewController = segue.destination as? CatBreedDetailViewController,
            let indexPath = tableView.indexPathForSelectedRow {
            detailViewController.catBreed = filteredCat[indexPath.row] //선택한 고양이의 정보를 전달
        }
    }

}

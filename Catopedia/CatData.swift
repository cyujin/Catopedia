//
//  CatData.swift
//  Catopedia
//
//  Created by hansung on 2023/06/13.
//

import Foundation

struct Weight: Codable {
    let imperial: String
    let metric: String
}

struct Image: Codable {
    let url: String
}

struct CatBreed: Codable {
    let weight: Weight
    let id: String
    let name: String
    let description: String
    let origin: String
    let life_span: String
    let temperament: String //품종 성격 특성
    let adaptability: Int //환경, 상황의 적응력
    let affection_level: Int //애정 표현 수준
    let child_friendly: Int
    let dog_friendly: Int
    let intelligence: Int
    let stranger_friendly: Int //낯선 사람들에게 친절한지
    let energy_level: Int //활동 수준
    let health_issues: Int //품종 건강 문제
    let shedding_level: Int //털이 얼마나 빠지는지
    let hypoallergenic: Int //알레르기 유발 가능성이 낮은지 여부
    let vocalisation: Int //수다냥이의 점수
    let short_legs: Int //짧은 다리의 품종인지 여부
    let wikipedia_url: String?
    let image: Image?
}

class CatData {
    //API URL
    let baseURL = "https://api.thecatapi.com/v1/breeds"
    //API KEY
    let apiKey = "live_wLFZYYr0K2EzFic3c5VbSmdUvDoJMx3A04peNyX9gj4uDwM8J8GJxWPZ3X5p7m9N"

    //고양이 데이터셋을 가져오는 함수
    func fetchCatBreeds(completion: @escaping ([CatBreed]?, Error?) -> Void) {
        guard let url = URL(string: baseURL) else { return } //URL 객체 생성

        //HTTP 요청 객체 생성 및 설정
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        //네트워크 작업 생성 및 시작
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(nil, error)
            } else if let data = data { //데이터 정상적으로 수신되었을 때
                do {
                    //JSONDecoder를 이용해 JSON 데이터를 모델 객체로 변환
                    let decoder = JSONDecoder()
                    let breeds = try decoder.decode([CatBreed].self, from: data)
                    completion(breeds, nil)
                } catch let decodeError {
                    completion(nil, decodeError)
                }
            }
        }
        task.resume()
    }
}

//
//  GetData.swift
//  Vk black&white
//
//  Created by NIKOLAI BORISOV on 05.04.2021.
//

import Foundation
import Alamofire

class GetOperationData: AsyncOperation {
    var request: DataRequest
    var data: Data?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
}

//
//  DownloadManager.swift
//  RecipePuppy
//
//  Created by Daniel Illescas Romero on 19/10/2018.
//  Copyright © 2018 Daniel Illescas Romero. All rights reserved.
//

import Foundation

class DownloadManager {
	
	private var tasks: [URLSessionTask] = []
	
	func manageData(from url: URL, _ handleData: @escaping ((Data?) -> Void)) {
		
		guard !self.tasks.contains(where: { $0.originalRequest?.url == url }) else {
			return
		}
		
		let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
			DispatchQueue.main.async {
				handleData(data)
			}
		}
		
		task.resume()
		self.tasks.append(task)
	}
	
	func cancelTaskWith(url: URL) {
		if let taskIndex = tasks.index(where: { $0.originalRequest?.url == url }) {
			self.tasks[taskIndex].cancel()
			self.tasks.remove(at: taskIndex)
		}
	}
}

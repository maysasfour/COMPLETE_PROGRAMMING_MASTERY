// Example.swift - HTTP requests via URLSession with NATIVE async/await (Lesson 14) --
// no separate library needed, unlike Rust/C++ covered earlier in this repository -- plus
// Codable (Lesson 10) for JSON. Like every other HTTP client covered in this repository
// EXCEPT Rust's ureq, Swift's URLSession does NOT throw on 404/500 -- it's a normal response.
// NOT COMPILED/RUN -- see course README and Lesson 01 for the disclosed reason.

import Foundation

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}

func run() async throws {
    print("--- GET ---")
    let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
    let (data, response) = try await URLSession.shared.data(from: url)
    if let httpResponse = response as? HTTPURLResponse {
        print("status: \(httpResponse.statusCode)")
    }
    let todo = try JSONDecoder().decode(Todo.self, from: data)
    print("Decoded: id=\(todo.id), userId=\(todo.userId), title=\(todo.title), completed=\(todo.completed)")

    print("\n--- GET a route that returns 404 -- NO exception thrown ---")
    let notFoundURL = URL(string: "https://jsonplaceholder.typicode.com/todos/99999999")!
    let (notFoundData, notFoundResponse) = try await URLSession.shared.data(from: notFoundURL)
    if let httpResponse = notFoundResponse as? HTTPURLResponse {
        print("status: \(httpResponse.statusCode) (a normal response, not a thrown exception, per Swift/Foundation's documented behavior)")
    }
    print("body: \(String(data: notFoundData, encoding: .utf8) ?? "")")

    print("\n--- POST with a JSON body ---")
    var request = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos")!)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    struct NewTodo: Codable { let title: String; let completed: Bool; let userId: Int }
    let newTodo = NewTodo(title: "Learn Swift URLSession", completed: false, userId: 1)
    request.httpBody = try JSONEncoder().encode(newTodo)
    let (postData, postResponse) = try await URLSession.shared.data(for: request)
    if let httpResponse = postResponse as? HTTPURLResponse {
        print("status: \(httpResponse.statusCode)")
    }
    print("body (echoed back with a fake id): \(String(data: postData, encoding: .utf8) ?? "")")
}

Task {
    try? await run()
}

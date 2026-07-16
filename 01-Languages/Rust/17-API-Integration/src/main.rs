// main.rs - HTTP requests with the `ureq` crate (since std provides no HTTP client at all),
// plus serde/serde_json (Lesson 10) for decoding the response into a struct.

use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
struct Todo {
    #[serde(rename = "userId")]
    user_id: i32,
    id: i32,
    title: String,
    completed: bool,
}

#[derive(Serialize)]
struct NewTodo {
    title: String,
    completed: bool,
    #[serde(rename = "userId")]
    user_id: i32,
}

fn main() {
    println!("--- GET https://jsonplaceholder.typicode.com/todos/1 ---");
    let response = ureq::get("https://jsonplaceholder.typicode.com/todos/1").call();
    match response {
        Ok(resp) => {
            println!("status: {}", resp.status());
            let todo: Todo = resp.into_json().expect("failed to parse JSON");
            println!(
                "Decoded: id={}, user_id={}, title={}, completed={}",
                todo.id, todo.user_id, todo.title, todo.completed
            );
        }
        Err(e) => println!("request error: {}", e),
    }

    println!("\n--- GET a route that returns 404 ---");
    // ureq treats non-2xx as an Err(ureq::Error::Status(...)) by default -- unlike every
    // other language course's HTTP client, which returns a normal, non-error response object.
    match ureq::get("https://jsonplaceholder.typicode.com/todos/99999999").call() {
        Ok(resp) => println!("status: {}", resp.status()),
        Err(ureq::Error::Status(code, _)) => {
            println!("status: {} (returned as an Err by ureq's design, unlike most other clients)", code);
        }
        Err(e) => println!("other error: {}", e),
    }

    println!("\n--- POST with a JSON body ---");
    let new_todo = NewTodo {
        title: "Learn ureq".to_string(),
        completed: false,
        user_id: 1,
    };
    match ureq::post("https://jsonplaceholder.typicode.com/todos").send_json(&new_todo) {
        Ok(resp) => {
            println!("status: {}", resp.status());
            let body: serde_json::Value = resp.into_json().expect("failed to parse JSON");
            println!("body (echoed back with a fake id): {}", body);
        }
        Err(e) => println!("request error: {}", e),
    }
}

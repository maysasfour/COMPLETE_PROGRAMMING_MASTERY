// main.go - the built-in net/http client (no dependency needed, unlike Java/C++), plus
// encoding/json (Lesson 10) for decoding the response.
package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

type Todo struct {
	UserID    int    `json:"userId"`
	ID        int    `json:"id"`
	Title     string `json:"title"`
	Completed bool   `json:"completed"`
}

func main() {
	fmt.Println("--- GET https://jsonplaceholder.typicode.com/todos/1 ---")
	resp, err := http.Get("https://jsonplaceholder.typicode.com/todos/1")
	if err != nil {
		panic(err)
	}
	defer resp.Body.Close()

	fmt.Println("status:", resp.StatusCode)
	body, err := io.ReadAll(resp.Body)
	if err != nil {
		panic(err)
	}
	var todo Todo
	if err := json.Unmarshal(body, &todo); err != nil {
		panic(err)
	}
	fmt.Printf("Decoded: UserID=%d, Title=%s, Completed=%t\n", todo.UserID, todo.Title, todo.Completed)

	fmt.Println("\n--- GET a route that returns 404 ---")
	resp2, err := http.Get("https://jsonplaceholder.typicode.com/todos/99999999")
	if err != nil {
		panic(err)
	}
	defer resp2.Body.Close()
	fmt.Println("status:", resp2.StatusCode)
	fmt.Println("net/http does NOT return an error for a 404 -- StatusCode must be checked manually.")

	fmt.Println("\n--- POST with a JSON body ---")
	newTodo := map[string]interface{}{
		"title":     "Learn net/http",
		"completed": false,
		"userId":    1,
	}
	jsonBody, err := json.Marshal(newTodo)
	if err != nil {
		panic(err)
	}
	resp3, err := http.Post(
		"https://jsonplaceholder.typicode.com/todos",
		"application/json",
		bytes.NewBuffer(jsonBody),
	)
	if err != nil {
		panic(err)
	}
	defer resp3.Body.Close()
	fmt.Println("status:", resp3.StatusCode)
	respBody, _ := io.ReadAll(resp3.Body)
	fmt.Println("body (echoed back with a fake id):", string(respBody))
}

// example.cpp - a real HTTP client using cpp-httplib (a single-header library), since neither
// the C++ standard library nor any built-in facility provides HTTP support at all -- a genuine
// gap, one step further than even Java's JSON gap (Lesson 10/17 of the Java course).
//
// Makes real network calls to the public jsonplaceholder.typicode.com test API, the same
// service used throughout this repository's other language courses, over plain HTTP
// (this server accepts it) specifically to avoid requiring an OpenSSL dependency for TLS
// just for this one lesson.

#include <iostream>
#include "httplib.h"

int main() {
    httplib::Client client("http://jsonplaceholder.typicode.com");
    client.set_connection_timeout(5);
    client.set_read_timeout(5);

    std::cout << "--- GET /todos/1 ---" << std::endl;
    auto getResult = client.Get("/todos/1");
    if (getResult) {
        std::cout << "status: " << getResult->status << std::endl;
        std::cout << "body: " << getResult->body << std::endl;
    } else {
        std::cout << "network error: " << httplib::to_string(getResult.error()) << std::endl;
    }

    std::cout << "\n--- GET a route that returns 404 ---" << std::endl;
    auto notFoundResult = client.Get("/todos/99999999");
    if (notFoundResult) {
        std::cout << "status: " << notFoundResult->status << std::endl;
        std::cout << "cpp-httplib does NOT throw on a 404 -- status must be checked manually." << std::endl;
    }

    std::cout << "\n--- POST with a JSON body ---" << std::endl;
    std::string jsonBody = R"({"title":"Learn cpp-httplib","completed":false,"userId":1})";
    auto postResult = client.Post("/todos", jsonBody, "application/json");
    if (postResult) {
        std::cout << "status: " << postResult->status << std::endl;
        std::cout << "body (echoed back with a fake id): " << postResult->body << std::endl;
    }

    return 0;
}

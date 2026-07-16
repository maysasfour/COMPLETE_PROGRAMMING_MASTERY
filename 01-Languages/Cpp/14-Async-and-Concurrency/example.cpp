// example.cpp - std::thread, std::async/future (with real timing), std::mutex.
#include <iostream>
#include <thread>
#include <future>
#include <mutex>
#include <chrono>
#include <string>

void printMessage(const std::string& msg) {
    std::cout << msg << std::endl;
}

int slowCompute(int ms, int value) {
    std::this_thread::sleep_for(std::chrono::milliseconds(ms));
    return value;
}

std::mutex mtx;
int sharedCounter = 0;

void incrementSafely(int times) {
    for (int i = 0; i < times; i++) {
        std::lock_guard<std::mutex> lock(mtx);
        sharedCounter++;
    }
}

int main() {
    std::cout << "--- std::thread ---" << std::endl;
    std::thread t(printMessage, "Hello from a thread");
    t.join();

    std::cout << "\n--- std::async / std::future ---" << std::endl;
    std::future<int> future = std::async(std::launch::async, []() { return 42; });
    std::cout << "future.get(): " << future.get() << std::endl;

    std::cout << "\n--- sequential vs concurrent futures (real timing) ---" << std::endl;
    auto start1 = std::chrono::steady_clock::now();
    int a = slowCompute(80, 1);
    int b = slowCompute(80, 2);
    int c = slowCompute(80, 3);
    auto elapsed1 = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::steady_clock::now() - start1).count();
    std::cout << "Sequential 3x80ms calls took ~" << elapsed1 << "ms (sum=" << (a + b + c) << ")" << std::endl;

    auto start2 = std::chrono::steady_clock::now();
    auto f1 = std::async(std::launch::async, slowCompute, 80, 1);
    auto f2 = std::async(std::launch::async, slowCompute, 80, 2);
    auto f3 = std::async(std::launch::async, slowCompute, 80, 3);
    int total = f1.get() + f2.get() + f3.get();
    auto elapsed2 = std::chrono::duration_cast<std::chrono::milliseconds>(
        std::chrono::steady_clock::now() - start2).count();
    std::cout << "Concurrent std::async of the same 3x80ms tasks took ~" << elapsed2 << "ms (sum=" << total << ")" << std::endl;

    std::cout << "\n--- std::mutex protecting shared state ---" << std::endl;
    std::thread t1(incrementSafely, 1000);
    std::thread t2(incrementSafely, 1000);
    t1.join();
    t2.join();
    std::cout << "sharedCounter after two threads each incrementing 1000 times: " << sharedCounter << std::endl;

    return 0;
}

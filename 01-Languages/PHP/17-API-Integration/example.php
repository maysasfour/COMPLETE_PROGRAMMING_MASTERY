<?php
declare(strict_types=1);
// example.php - HTTP requests via curl (the standard, feature-complete choice) and the
// simpler file_get_contents-with-a-stream-context alternative. Like fetch()/HttpClient/
// net/http in every other language course, PHP's HTTP clients do NOT throw on 404/500 --
// this is verified live below, following the exact same pattern documented in the
// JavaScript, TypeScript, C#, Java, Go, and C++ courses' API-integration lessons.

echo "--- GET via curl ---\n";
$ch = curl_init("https://jsonplaceholder.typicode.com/todos/1");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
$statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);
echo "status: {$statusCode}\n";
$todo = json_decode($response, true);
echo "Decoded: id={$todo['id']}, userId={$todo['userId']}, title={$todo['title']}, completed=" . var_export($todo['completed'], true) . "\n";

echo "\n--- GET a route that returns 404 -- NO exception thrown, just a normal response ---\n";
$ch = curl_init("https://jsonplaceholder.typicode.com/todos/99999999");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
$response = curl_exec($ch);
$statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);
echo "status: {$statusCode} (a normal response, not a thrown exception -- verified live)\n";
echo "body: " . var_export($response, true) . "\n"; // "{}" -- an empty JSON object, still a 404

echo "\n--- POST with a JSON body ---\n";
$payload = json_encode(["title" => "Learn PHP curl", "completed" => false, "userId" => 1]);
$ch = curl_init("https://jsonplaceholder.typicode.com/todos");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, $payload);
curl_setopt($ch, CURLOPT_HTTPHEADER, ["Content-Type: application/json"]);
$response = curl_exec($ch);
$statusCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);
echo "status: {$statusCode}\n";
echo "body (echoed back with a fake id): {$response}\n";

echo "\n--- Simpler alternative: file_get_contents with a stream context ---\n";
$context = stream_context_create([
    "http" => ["method" => "GET", "header" => "Accept: application/json"],
]);
$body = file_get_contents("https://jsonplaceholder.typicode.com/todos/2", false, $context);
$todo2 = json_decode($body, true);
echo "todo 2 title: {$todo2['title']}\n";

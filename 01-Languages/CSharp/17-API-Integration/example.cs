// example.cs - HttpClient GET/POST, JSON deserialization into a record, the 404 trap.

using System.Text;
using System.Text.Json;

AppContext.SetSwitch("System.Text.Json.JsonSerializer.IsReflectionEnabledByDefault", true);

using var client = new HttpClient();

Console.WriteLine("--- GET https://jsonplaceholder.typicode.com/todos/1 ---");
var getResponse = await client.GetAsync("https://jsonplaceholder.typicode.com/todos/1");
Console.WriteLine($"status: {(int)getResponse.StatusCode}, IsSuccessStatusCode: {getResponse.IsSuccessStatusCode}");
string body = await getResponse.Content.ReadAsStringAsync();
Todo? todo = JsonSerializer.Deserialize<Todo>(body, new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
Console.WriteLine($"Deserialized: UserId={todo?.UserId}, Title={todo?.Title}, Completed={todo?.Completed}");

Console.WriteLine("\n--- GET a route that returns 404 ---");
var notFoundResponse = await client.GetAsync("https://jsonplaceholder.typicode.com/todos/99999999");
Console.WriteLine($"status: {(int)notFoundResponse.StatusCode}, IsSuccessStatusCode: {notFoundResponse.IsSuccessStatusCode}");
Console.WriteLine("HttpClient does NOT throw on a 404 by default -- IsSuccessStatusCode must be checked manually.");

Console.WriteLine("\n--- POST with a JSON body ---");
var newTodo = new { title = "Learn HttpClient", completed = false, userId = 1 };
var content = new StringContent(JsonSerializer.Serialize(newTodo), Encoding.UTF8, "application/json");
var postResponse = await client.PostAsync("https://jsonplaceholder.typicode.com/todos", content);
Console.WriteLine($"status: {(int)postResponse.StatusCode}");
string postBody = await postResponse.Content.ReadAsStringAsync();
Console.WriteLine($"Response body (echoed back with a fake id): {postBody}");

Console.WriteLine("\n--- EnsureSuccessStatusCode throws for a non-2xx response ---");
try {
    notFoundResponse.EnsureSuccessStatusCode();
} catch (HttpRequestException e) {
    Console.WriteLine($"EnsureSuccessStatusCode correctly threw: {e.Message}");
}

record Todo(int UserId, int Id, string Title, bool Completed);

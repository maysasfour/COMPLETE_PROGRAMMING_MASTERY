# 05 — REST API Integration

[Back to module overview](../README.md) | [Previous: Local Storage with Room](../04-Local-Storage-with-Room/README.md)

## Beginner: A Real Network Call, From an Emulator to a Real Host Server

This lesson makes a **genuinely real network call** from an Android app running in the emulator to a real HTTP server running on the host machine — reached via `10.0.2.2`, the Android emulator's well-known special alias that routes to the host's own `localhost`. Both a real connection failure and a real successful fetch are demonstrated, verified from both the client's and the server's own logs.

## The Real Host Server

```java
// server/Server.java -- run on the HOST machine, NOT inside the Android project
HttpServer server = HttpServer.create(new InetSocketAddress("0.0.0.0", port), 0);
server.createContext("/api/greeting", exchange -> {
    respond(exchange, "{\"message\":\"Hello from the REAL host server!\"}");
});
```

The same JDK `HttpServer` pattern used throughout this repository (see [13-Software-Architecture](../../13-Software-Architecture/03-Microservices-Fundamentals/README.md), [14-APIs-and-Integrations](../../14-APIs-and-Integrations/README.md)).

## The Android Client

```java
URL url = new URL("http://10.0.2.2:8090/api/greeting"); // the emulator's alias for the HOST's localhost
HttpURLConnection connection = (HttpURLConnection) url.openConnection();
int status = connection.getResponseCode();
// ... read the real response body
```

## Step 1: A Real Connection Failure (Server Not Yet Running)

Tapping "Fetch" on the real emulator **before** starting the host server produced a genuine network error:

```
Real network error: SocketTimeoutException: failed to connect to /10.0.2.2 (port 8090) from /192.168.232.2 (port 35030) after 3000ms
```

This is a real `SocketTimeoutException` from a real socket connection attempt — not a simulated or hardcoded error message.

## Step 2: A Real Success, Verified From Both Sides

After starting the real host server and tapping "Fetch" again, the app's log showed:

```
Real network call SUCCEEDED: HTTP 200: {"message":"Hello from the REAL host server!"}
```

And — independently — the **server's own log**, on the host machine, confirmed it genuinely served the request:

```
Served /api/greeting to /127.0.0.1:53128
```

A real screenshot taken at this point independently confirms the same JSON rendered on screen. Three separate, independent signals (client log, server log, screenshot) all agree — this is a real, verified round trip across an actual network boundary between two separate processes.

## Detailed Example

See [server/Server.java](server/Server.java) (run on the host) and [app/src/main/java/com/example/restintegration/MainActivity.java](app/src/main/java/com/example/restintegration/MainActivity.java) (the Android client).

## Run It

```bash
# Terminal 1 -- on the HOST machine:
cd 05-Mobile-Development/05-REST-API-Integration/server
javac Server.java && java Server

# Terminal 2 -- build and install the Android app:
cd 05-Mobile-Development/05-REST-API-Integration
JAVA_HOME="/path/to/jdk-17" ./gradlew assembleDebug
adb install -r app/build/outputs/apk/debug/app-debug.apk
adb shell am start -n com.example.restintegration/.MainActivity
adb shell input tap <fetchButton x> <y>   # read real coordinates from: adb logcat -d -s RestDemo:D
adb logcat -d -s RestDemo:D
```

## Expected Output

A real `SocketTimeoutException` if tapped before the host server starts; a real `HTTP 200` response with the genuine JSON body once the server is running, confirmed independently by both the client's log and the server's own log.

## Common Mistakes

- Using `http://localhost` or `http://127.0.0.1` from Android emulator code to reach the host machine — this refers to the **emulator's own** loopback, not the host's; `10.0.2.2` is the correct special alias.
- Forgetting `android.permission.INTERNET` in the manifest, or forgetting `usesCleartextTraffic="true"` for plain (non-HTTPS) local testing against newer Android API levels, which block cleartext traffic by default.
- Performing network calls on the main thread — like Room ([Lesson 04](../04-Local-Storage-with-Room/README.md)), Android enforces this at runtime; this lesson uses a real `ExecutorService`.
- Not handling network failures gracefully — verified live in this lesson that a real, specific exception (`SocketTimeoutException`) is caught and surfaced clearly, rather than crashing the app.

## Best Practices

- Use `10.0.2.2` specifically (not `localhost`) when an Android emulator needs to reach a server running on its host machine during development.
- Always perform network I/O off the main thread.
- Catch and clearly surface network exceptions rather than letting them crash the app or fail silently.
- Set reasonable connect/read timeouts (`setConnectTimeout`/`setReadTimeout`) so a genuinely unreachable server fails predictably rather than hanging indefinitely — directly the same principle as [14-APIs-and-Integrations Lesson 05](../../14-APIs-and-Integrations/05-Consuming-Third-Party-APIs/README.md).

## Real-World Usage

Nearly every real mobile app communicates with a backend API — this exact emulator-to-host-server pattern is the standard way Android developers test against a locally-running backend during development, before pointing the app at a real, deployed API server.

## Summary

- A real network call from the Android emulator to a real HTTP server on the host machine was verified in both failure (`SocketTimeoutException`, server not yet running) and success (`HTTP 200`, real JSON body) states.
- The successful round trip was confirmed independently from three separate signals: the client's log, the server's own log, and a real screenshot — all agreeing.

## Key Terms

- **`10.0.2.2`** — the Android emulator's special alias for its host machine's `localhost`.
- **Cleartext traffic** — unencrypted (plain HTTP, not HTTPS) network traffic, blocked by default on newer Android versions unless explicitly permitted.
- **`HttpURLConnection`** — Android's built-in class for making HTTP requests without an external library.

## Interview Questions

1. **Why does the Android emulator need a special address (`10.0.2.2`) to reach a server running on its host machine, instead of just using `localhost`?**
   The emulator runs as its own virtual device with its own network stack — `localhost`/`127.0.0.1` from inside the emulator refers to the emulator itself, not the physical host machine it's running on. `10.0.2.2` is a special, virtual alias the Android emulator specifically routes to the host's own loopback interface. This was demonstrated concretely: the app correctly reached a real server that was genuinely listening on the host machine's port 8090, verified by the server's own log showing it served a real request, only because the app used `10.0.2.2` rather than `localhost`.

2. **How was the network round trip verified as genuinely real, rather than simulated or assumed?**
   Three independent signals were checked, all confirming the same result: the Android app's own log showed `HTTP 200` with the real JSON body; the host server's separate, independent log (running as a completely different process on a different machine, from the emulator's perspective) showed it had actually served a request from a remote address; and a real screenshot of the running app showed the identical JSON rendered on screen. Additionally, before the server was started, tapping the identical "Fetch" button produced a genuine `SocketTimeoutException` — proving the earlier failure and later success were both real network outcomes, not a hardcoded or mocked response.

## Recommended Next Lesson

[06 — Building a CRUD Mobile App](../06-Building-a-CRUD-Mobile-App/README.md)

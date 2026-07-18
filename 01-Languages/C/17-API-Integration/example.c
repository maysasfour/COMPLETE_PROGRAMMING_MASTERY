/* example.c -- C has ZERO built-in HTTP client support -- not even the
   minimal socket-wrapping convenience C++ at least has via third-party
   single-header libraries used elsewhere in this repository. On
   Windows, WinHTTP (a genuine OS-provided library, not part of the C
   standard at all) is the least-manual real option; this example uses
   it directly against the same live jsonplaceholder.typicode.com API
   this repository's other language courses use, to make the point
   concrete rather than theoretical. */
#include <stdio.h>
#include <windows.h>
#include <winhttp.h>

#pragma comment(lib, "winhttp.lib")

int main(void) {
    /* WinHTTP is a Windows-specific API, NOT part of C or its standard
       library at all -- this is a genuinely different, more manual
       starting point than even C++'s cpp-httplib single-header
       approach, which at least is portable C++ source. A cross-platform
       C program would need an entirely different implementation on
       Linux/macOS (raw BSD sockets + hand-rolled HTTP/manual TLS, or a
       library like libcurl) -- there is nothing in ISO C to fall back
       on portably. */
    HINTERNET session = WinHttpOpen(L"C-Course-Example/1.0",
                                     WINHTTP_ACCESS_TYPE_DEFAULT_PROXY,
                                     WINHTTP_NO_PROXY_NAME,
                                     WINHTTP_NO_PROXY_BYPASS, 0);
    if (session == NULL) {
        fprintf(stderr, "WinHttpOpen failed: %lu\n", GetLastError());
        return 1;
    }

    HINTERNET connect = WinHttpConnect(session, L"jsonplaceholder.typicode.com",
                                        INTERNET_DEFAULT_HTTPS_PORT, 0);
    if (connect == NULL) {
        fprintf(stderr, "WinHttpConnect failed: %lu\n", GetLastError());
        WinHttpCloseHandle(session);
        return 1;
    }

    HINTERNET request = WinHttpOpenRequest(connect, L"GET", L"/todos/1",
                                             NULL, WINHTTP_NO_REFERER,
                                             WINHTTP_DEFAULT_ACCEPT_TYPES,
                                             WINHTTP_FLAG_SECURE);   /* HTTPS */
    if (request == NULL) {
        fprintf(stderr, "WinHttpOpenRequest failed: %lu\n", GetLastError());
        WinHttpCloseHandle(connect);
        WinHttpCloseHandle(session);
        return 1;
    }

    BOOL sent = WinHttpSendRequest(request, WINHTTP_NO_ADDITIONAL_HEADERS, 0,
                                     WINHTTP_NO_REQUEST_DATA, 0, 0, 0);
    BOOL received = sent && WinHttpReceiveResponse(request, NULL);

    if (!received) {
        fprintf(stderr, "Request failed: %lu\n", GetLastError());
    } else {
        DWORD statusCode = 0;
        DWORD statusSize = sizeof(statusCode);
        WinHttpQueryHeaders(request,
            WINHTTP_QUERY_STATUS_CODE | WINHTTP_QUERY_FLAG_NUMBER,
            WINHTTP_HEADER_NAME_BY_INDEX, &statusCode, &statusSize, WINHTTP_NO_HEADER_INDEX);
        printf("GET https://jsonplaceholder.typicode.com/todos/1 -> HTTP %lu\n", statusCode);

        /* Read the raw response body -- there is no JSON parsing at all
           here; C has no built-in JSON support (same gap as Lesson 10),
           so this prints the raw bytes as text, exactly as received. */
        char buffer[4096];
        DWORD bytesRead = 0;
        printf("Response body:\n");
        BOOL readOk = WinHttpReadData(request, buffer, sizeof(buffer) - 1, &bytesRead);
        while (readOk && bytesRead > 0) {
            buffer[bytesRead] = '\0';
            printf("%s", buffer);
            readOk = WinHttpReadData(request, buffer, sizeof(buffer) - 1, &bytesRead);
        }
        printf("\n");
    }

    WinHttpCloseHandle(request);
    WinHttpCloseHandle(connect);
    WinHttpCloseHandle(session);
    return 0;
}

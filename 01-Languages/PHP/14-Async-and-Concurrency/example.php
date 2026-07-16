<?php
declare(strict_types=1);
// example.php - PHP has NO built-in async/await and no userland OS threads by default
// (the `pthreads` extension exists but isn't bundled in standard CLI builds, and doesn't
// work with most extensions). PHP IS request-per-process/thread on a web server, and CLI
// scripts run single-threaded, top to bottom, by default -- genuinely different from every
// other language in this course's language order so far. PHP 8.1+ added Fibers: cooperative,
// single-threaded coroutines (not parallelism) -- and curl_multi_* provides REAL concurrent
// I/O (verified with real timing below) despite PHP itself being single-threaded.

echo "--- Fibers (PHP 8.1+): cooperative multitasking, NOT parallelism ---\n";
$fiber = new Fiber(function (): void {
    echo "fiber: step 1\n";
    $resumeValue = Fiber::suspend("paused after step 1"); // yields control back to the caller
    echo "fiber: resumed with '{$resumeValue}'\n";
    echo "fiber: step 2\n";
});

$suspendedValue = $fiber->start();
echo "main: fiber suspended with message: '{$suspendedValue}'\n";
echo "main: doing other work while the fiber is paused...\n";
$fiber->resume("go ahead");
echo "main: fiber finished? " . ($fiber->isTerminated() ? "yes" : "no") . "\n";

echo "\n--- Fibers run on ONE thread -- no true parallel CPU work happens ---\n";
// A Fiber's body only runs while explicitly start()/resume()d -- it never runs
// "in the background" on its own the way a goroutine or a Rust thread does.

echo "\n--- Real concurrent I/O via curl_multi_*, verified with real timing ---\n";
function fetchSequential(array $urls): float {
    $start = microtime(true);
    foreach ($urls as $url) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_exec($ch);
        curl_close($ch);
    }
    return microtime(true) - $start;
}

function fetchConcurrent(array $urls): float {
    $start = microtime(true);
    $mh = curl_multi_init();
    $handles = [];
    foreach ($urls as $url) {
        $ch = curl_init($url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_multi_add_handle($mh, $ch);
        $handles[] = $ch;
    }
    $running = null;
    do {
        curl_multi_exec($mh, $running);
        curl_multi_select($mh);
    } while ($running > 0);
    foreach ($handles as $ch) {
        curl_multi_remove_handle($mh, $ch);
        curl_close($ch);
    }
    curl_multi_close($mh);
    return microtime(true) - $start;
}

$urls = array_fill(0, 4, "https://jsonplaceholder.typicode.com/todos/1");
$seqTime = fetchSequential($urls);
$concTime = fetchConcurrent($urls);
printf("sequential: %.3fs, concurrent (curl_multi): %.3fs\n", $seqTime, $concTime);
if ($concTime < $seqTime) {
    echo "confirmed: curl_multi_exec's overlapping I/O beat sequential requests\n";
}

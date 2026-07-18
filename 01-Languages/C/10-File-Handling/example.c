/* example.c -- <stdio.h> FILE*, fopen/fwrite/fread/fclose, and the same
   "no built-in JSON" gap this repository's C++/Java/Kotlin courses note. */
#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int id;
    char name[32];
    double score;
} Record;

int main(void) {
    const char* path = "records.bin";

    /* Writing binary records with fwrite -- no serialization format is
       built in; this writes the struct's raw memory layout directly,
       which is why it's not portable across compilers/platforms with
       different struct padding/alignment (a real, worth-noting gap). */
    Record toWrite[3] = {
        {1, "Alice", 91.5},
        {2, "Bob", 84.0},
        {3, "Carol", 97.25},
    };

    FILE* out = fopen(path, "wb");
    if (out == NULL) {
        fprintf(stderr, "failed to open %s for writing\n", path);
        return 1;
    }
    size_t written = fwrite(toWrite, sizeof(Record), 3, out);
    fclose(out);
    printf("wrote %zu records to %s\n", written, path);

    /* Reading them back with fread. */
    Record readBack[3];
    FILE* in = fopen(path, "rb");
    if (in == NULL) {
        fprintf(stderr, "failed to open %s for reading\n", path);
        return 1;
    }
    size_t readCount = fread(readBack, sizeof(Record), 3, in);
    fclose(in);

    printf("read %zu records back:\n", readCount);
    for (size_t i = 0; i < readCount; i++) {
        printf("  id=%d name=%s score=%.2f\n", readBack[i].id, readBack[i].name, readBack[i].score);
    }

    /* Text-mode file I/O with fprintf/fgets -- the more common case for
       human-readable formats (logs, CSV, config files). */
    const char* textPath = "notes.txt";
    FILE* textOut = fopen(textPath, "w");
    fprintf(textOut, "line one\nline two\nline three\n");
    fclose(textOut);

    printf("\nreading %s line by line:\n", textPath);
    FILE* textIn = fopen(textPath, "r");
    char line[128];
    while (fgets(line, sizeof(line), textIn) != NULL) {
        /* fgets keeps the trailing newline -- strip it for clean printing. */
        line[strcspn(line, "\n")] = '\0';
        printf("  \"%s\"\n", line);
    }
    fclose(textIn);

    /* Clean up the files this example created. */
    remove(path);
    remove(textPath);
    printf("\ncleaned up %s and %s\n", path, textPath);

    /* C has NO built-in JSON (or any structured-data format) support at
       all -- same gap as this repository's C++/Java/Kotlin courses.
       Real C code either hand-writes a simple format (as above, raw
       structs or line-based text) or links a third-party library like
       cJSON/jansson for real JSON. */
    printf("\n(C has no built-in JSON support -- same gap noted in the C++/Java/Kotlin courses;\n"
           " real C JSON needs a third-party library like cJSON.)\n");

    return 0;
}

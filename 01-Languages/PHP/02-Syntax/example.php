<?php
// example.php - basic PHP syntax: tags, statements, comments, output.

// Everything PHP executes must be inside an opening tag and a closing tag (the closing
// tag is conventionally omitted in pure-PHP files to avoid accidental trailing whitespace
// output, and ALSO because writing the literal closing-tag sequence inside a comment --
// as this sentence originally did -- ends PHP mode right there, mid-comment, no matter
// what kind of comment it's inside; verified live: it broke this exact file the first time.

// Single-line comment.
# Also a single-line comment (shell-style, less common).
/* Multi-line
   comment block. */

echo "Statements end with a semicolon.\n";
print "print is an alternative to echo (a language construct, not a function).\n";

// Variables are always prefixed with $, and PHP is dynamically typed -- no declared type.
$name = "World";
echo "Hello, {$name}!\n"; // string interpolation inside double quotes

echo 'Single quotes do NOT interpolate: $name stays literal.' . "\n";

// var_dump shows a value's actual type and content -- essential for debugging PHP's
// dynamic typing, used throughout this course instead of guessing types from context.
var_dump(42);
var_dump(3.14);
var_dump("text");
var_dump(true);
var_dump(null);

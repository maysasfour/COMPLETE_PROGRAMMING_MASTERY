#!/usr/bin/env perl
use strict;
use warnings;

# `use strict; use warnings;` at the top of every file is non-negotiable in
# modern Perl -- every lesson in this course has used both from Lesson 03
# onward, precisely to model the always-on convention.

# ---- Anti-pattern, reproduced live: relying on symbolic references / no
# strict, letting a typo silently create a new global instead of erroring ----
package BadExample {
    sub demo_without_strict {
        no strict 'vars';    # deliberately re-enabled here ONLY to show the bug
        $totall = 10;         # typo of $total -- silently creates a NEW global!
        $total  = $total + 5; # reads the OTHER (still-undef) global -- bug!
        return $total;
    }
}
my $bad_result = BadExample::demo_without_strict();
print "anti-pattern result (should be 15, is actually wrong): ", (defined $bad_result ? $bad_result : "undef"), "\n";

# ---- Fixed version: `use strict` makes the same typo a COMPILE ERROR ----
package GoodExample {
    use strict;
    use warnings;
    sub demo_with_strict {
        my $total = 10;
        # my $totall = $total + 5;  # a typo here would be a harmless new
                                     # lexical (still undesirable), but --
                                     # critically -- assigning to a bare,
                                     # undeclared $totall without `my` at all
                                     # is a COMPILE-TIME error under strict,
                                     # not a silent runtime bug:
                                     #   Global symbol "$totall" requires
                                     #   explicit package name
        $total = $total + 5;
        return $total;
    }
}
print "fixed result (genuinely correct): ", GoodExample::demo_with_strict(), "\n";

# Clear naming: prefer descriptive names over terse ones, and consistent
# snake_case for variables/subs (the Perl community convention), reserving
# StudlyCaps for package/class names only.
my $user_signup_count = 42;   # clear
# my $usc = 42;                # unclear -- avoid

# Best practices summary demonstrated across this course:
# - Always `use strict; use warnings;` (this lesson, reproduced live above).
# - Use `my` lexicals by default; reach for `our` package globals only when
#   genuinely needed (Lesson 03).
# - Prefer `eq`/`==` deliberately, never interchangeably (Lesson 04).
# - Prefer parameterized queries over string-built SQL (Lesson 16's
#   conceptual DBI section) -- the same rule this repository enforces live
#   with a real reproduced SQL injection in several other language courses.
print "\nBest practices reinforced: see comments above and the rest of this course.\n";

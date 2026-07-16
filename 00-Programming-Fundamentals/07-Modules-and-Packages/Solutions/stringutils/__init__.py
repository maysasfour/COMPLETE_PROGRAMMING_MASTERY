# Re-exporting here means `from stringutils import shout, word_count`
# works without the caller needing to know shout() lives in casing.py
# and word_count() lives in counting.py.
from .casing import shout
from .counting import word_count

__all__ = ["shout", "word_count"]

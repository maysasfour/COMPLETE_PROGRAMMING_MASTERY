# Throwaway helper module used only by example.py to demonstrate that
# importing a .py file causes CPython to write a compiled .pyc cache
# to __pycache__ before any interpretation happens.

def noop():
    return None

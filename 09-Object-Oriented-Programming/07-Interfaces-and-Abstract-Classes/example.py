"""
Lesson 07 - Interfaces and Abstract Classes
Demonstrates: the same "logging" contract expressed three ways - duck
typing (no formal contract), typing.Protocol (structural, statically
checked), and abc.ABC (nominal, enforced at instantiation, and able to
share real implementation code across subclasses).

Run with:
    python example.py

Expected output:
    --- Duck typing: works, no formal contract at all ---
    [file] starting task
    [console] starting task

    --- Protocol: structural contract, no inheritance required ---
    [file] starting task (via Protocol-typed function)
    [console] starting task (via Protocol-typed function)
    isinstance check with @runtime_checkable: True

    --- ABC: nominal contract, enforced at instantiation, shares code ---
    [console] starting task
    [console] ERROR: disk full   <- log_error is INHERITED, not reimplemented
    Blocked as expected: Can't instantiate abstract class BrokenLogger without an implementation for abstract method 'log'
"""

from abc import ABC, abstractmethod
from typing import Protocol, runtime_checkable


# --- Duck typing: no formal type at all --------------------------------
class FileLogger:
    def log(self, msg):
        print(f"[file] {msg}")


class ConsoleLogger:
    def log(self, msg):
        print(f"[console] {msg}")


def run_task_duck(logger):
    # No type declared at all - this works purely because whatever is
    # passed in happens to have a .log() method.
    logger.log("starting task")


print("--- Duck typing: works, no formal contract at all ---")
run_task_duck(FileLogger())
run_task_duck(ConsoleLogger())


# --- Protocol: structural, no inheritance required ----------------------
@runtime_checkable
class LoggerProtocol(Protocol):
    def log(self, msg: str) -> None: ...


def run_task_protocol(logger: LoggerProtocol) -> None:
    logger.log("starting task (via Protocol-typed function)")


print("\n--- Protocol: structural contract, no inheritance required ---")
# FileLogger/ConsoleLogger satisfy LoggerProtocol WITHOUT inheriting from
# it - Protocol matching is based purely on having a compatible log().
run_task_protocol(FileLogger())
run_task_protocol(ConsoleLogger())
print(f"isinstance check with @runtime_checkable: {isinstance(ConsoleLogger(), LoggerProtocol)}")


# --- ABC: nominal, enforced, and can share real code --------------------
class Logger(ABC):
    @abstractmethod
    def log(self, msg: str) -> None: ...

    def log_error(self, msg: str) -> None:
        # A concrete method living on the ABC itself - every subclass
        # gets this behavior for free, with zero duplication.
        self.log(f"ERROR: {msg}")


class ConsoleABCLogger(Logger):
    def log(self, msg: str) -> None:
        print(f"[console] {msg}")


print("\n--- ABC: nominal contract, enforced at instantiation, shares code ---")
abc_logger = ConsoleABCLogger()
abc_logger.log("starting task")
# log_error was never defined on ConsoleABCLogger - it's inherited
# straight from Logger, proving ABC can bundle real shared logic.
abc_logger.log_error("disk full")


class BrokenLogger(Logger):
    pass  # forgot to implement log()


try:
    BrokenLogger()   # abstract method missing -> cannot be instantiated
except TypeError as error:
    print(f"Blocked as expected: {error}")

"""
Lesson 06 - Composition vs. Inheritance
Demonstrates: a "bad" inheritance-only design suffering combinatorial
explosion (a subclass per channel x urgency combination), then the
composition-based refactor that decomposes it into independent,
swappable pieces combined at runtime.

Run with:
    python example.py

Expected output:
    --- BAD: inheritance hierarchy, one subclass per combination ---
    EmailNotification: Email: Server down
    UrgentEmailNotification: URGENT Email: Server down
    SMSNotification: SMS: Server down
    UrgentSMSNotification: URGENT SMS: Server down
    Subclasses needed for 2 channels x 2 urgency levels: 4

    --- GOOD: composition, independent pieces combined at runtime ---
    Notifier(EmailChannel(), urgent=False): Email: Server down
    Notifier(EmailChannel(), urgent=True): Email: URGENT Server down
    Notifier(SMSChannel(), urgent=False): SMS: Server down
    Notifier(SMSChannel(), urgent=True): SMS: URGENT Server down
    Classes needed regardless of how many combinations: 2 channels + Notifier

    --- Adding a third channel: no new combination classes required ---
    Notifier(PushChannel(), urgent=True): Push: URGENT Server down
"""

from abc import ABC, abstractmethod

MESSAGE = "Server down"


# --- BAD: inheritance-only design ------------------------------------
class Notification(ABC):
    @abstractmethod
    def send(self, message: str) -> str: ...


class EmailNotification(Notification):
    def send(self, message: str) -> str:
        return f"Email: {message}"


class UrgentEmailNotification(EmailNotification):
    def send(self, message: str) -> str:
        return f"URGENT Email: {message}"


class SMSNotification(Notification):
    def send(self, message: str) -> str:
        return f"SMS: {message}"


class UrgentSMSNotification(SMSNotification):
    def send(self, message: str) -> str:
        return f"URGENT SMS: {message}"


print("--- BAD: inheritance hierarchy, one subclass per combination ---")
for cls in [EmailNotification, UrgentEmailNotification, SMSNotification, UrgentSMSNotification]:
    print(f"{cls.__name__}: {cls().send(MESSAGE)}")
# 2 channels x 2 urgency levels already needed 4 subclasses - a third
# channel or a third dimension (e.g. "logged") would multiply this further.
print("Subclasses needed for 2 channels x 2 urgency levels: 4")


# --- GOOD: composition-based refactor ---------------------------------
class Channel(ABC):
    @abstractmethod
    def deliver(self, message: str) -> str: ...


class EmailChannel(Channel):
    def deliver(self, message: str) -> str:
        return f"Email: {message}"


class SMSChannel(Channel):
    def deliver(self, message: str) -> str:
        return f"SMS: {message}"


class Notifier:
    def __init__(self, channel: Channel, urgent: bool = False):
        # The channel is COMPOSED (held as data), not inherited - swapping
        # it out never requires touching Notifier's class definition.
        self.channel = channel
        self.urgent = urgent

    def notify(self, message: str) -> str:
        if self.urgent:
            message = f"URGENT {message}"
        # Delegation: Notifier doesn't know HOW to deliver a message,
        # it just asks its composed channel to do it.
        return self.channel.deliver(message)


print("\n--- GOOD: composition, independent pieces combined at runtime ---")
for channel_cls in [EmailChannel, SMSChannel]:
    for urgent in [False, True]:
        notifier = Notifier(channel_cls(), urgent=urgent)
        print(f"Notifier({channel_cls.__name__}(), urgent={urgent}): {notifier.notify(MESSAGE)}")
print("Classes needed regardless of how many combinations: 2 channels + Notifier")


class PushChannel(Channel):
    def deliver(self, message: str) -> str:
        return f"Push: {message}"


print("\n--- Adding a third channel: no new combination classes required ---")
# No UrgentPushNotification class was needed - PushChannel plugs straight
# into the existing Notifier, because urgency and channel were never coupled.
push_notifier = Notifier(PushChannel(), urgent=True)
print(f"Notifier(PushChannel(), urgent=True): {push_notifier.notify(MESSAGE)}")

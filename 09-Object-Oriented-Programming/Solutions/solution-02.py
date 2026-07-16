"""Solution to Exercise 02 -- Validated Properties."""


class Temperature:
    ABSOLUTE_ZERO_C = -273.15

    def __init__(self, celsius):
        # Routed through the property setter (not `self._celsius = celsius` directly) so the
        # constructor can't create an invalid object -- the validation lives in exactly one
        # place and applies whether the value arrives at construction or via later assignment.
        self.celsius = celsius

    @property
    def celsius(self):
        return self._celsius

    @celsius.setter
    def celsius(self, value):
        if value < self.ABSOLUTE_ZERO_C:
            raise ValueError(
                f"{value}°C is below absolute zero ({self.ABSOLUTE_ZERO_C}°C)"
            )
        self._celsius = value

    @property
    def fahrenheit(self):
        # Read-only: computed on the fly from celsius, no setter defined at all, so any
        # attempt to assign t.fahrenheit = ... raises AttributeError automatically.
        return self._celsius * 9 / 5 + 32


t = Temperature(25)
print(t.celsius)     # 25
print(t.fahrenheit)   # 77.0

try:
    t.celsius = -300
except ValueError as e:
    print(f"Rejected: {e}")

try:
    t.fahrenheit = 100
except AttributeError as e:
    print(f"Rejected: {e}")


# Reflection 1: Routing the constructor's initial value through the `celsius` property setter
# avoids duplicating the validation logic in two places (constructor and setter). If the rule
# ever changes (e.g. tightened tolerance), there's exactly one line to update, and it's
# impossible to construct a Temperature that bypasses the check.
#
# Reflection 2: A plain public attribute (`self.celsius = celsius` with no property) would let
# any caller do `t.celsius = -500`, silently creating a physically impossible temperature that
# would then produce nonsense downstream (e.g. corrupted Fahrenheit conversions, or worse,
# feeding invalid data into a physics calculation) with no error raised anywhere.

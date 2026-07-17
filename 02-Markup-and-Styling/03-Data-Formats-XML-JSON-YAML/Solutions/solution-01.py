import os

import yaml


def _resolve_path(data, dotted_path):
    current = data
    for segment in dotted_path.split("."):
        if segment.isdigit():
            current = current[int(segment)]
        else:
            current = current[segment]
    return current


def safe_load_with_string_check(path, string_fields):
    with open(path, encoding="utf-8") as f:
        data = yaml.safe_load(f)

    for field_path in string_fields:
        value = _resolve_path(data, field_path)
        if not isinstance(value, str):
            raise ValueError(
                f"Field '{field_path}' was expected to be a string but YAML parsed it as "
                f"{type(value).__name__} ({value!r}) -- likely an unquoted value that "
                f"collided with YAML's implicit boolean/null conversion (the 'Norway problem')."
            )

    return data


if __name__ == "__main__":
    catalog_path = os.path.join(os.path.dirname(__file__), "..", "catalog.yaml")

    print("=== Checking catalog.yaml's shipsFrom fields ===")
    try:
        safe_load_with_string_check(
            catalog_path,
            string_fields=["catalog.books.0.shipsFrom", "catalog.books.1.shipsFrom"],
        )
        print("No issues found.")
    except ValueError as e:
        print(f"Caught the real bug: {e}")

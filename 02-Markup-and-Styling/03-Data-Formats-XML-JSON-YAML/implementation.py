"""Data Formats: XML, JSON, and YAML -- the same catalog data modeled in all
three, parsed with real libraries, plus a genuine, famous YAML gotcha (the
"Norway problem") reproduced directly rather than just described."""

import json
import xml.etree.ElementTree as ET
import yaml


def parse_xml(path):
    tree = ET.parse(path)
    root = tree.getroot()
    books = []
    for book_element in root.findall("book"):
        price_element = book_element.find("price")
        books.append({
            "id": book_element.get("id"),
            # XML attributes are ALWAYS strings -- there is no native boolean
            # type in XML the way JSON/YAML have one. Converting "true"/"false"
            # text to a real bool is the caller's own responsibility.
            "inStock": book_element.get("inStock") == "true",
            "title": book_element.find("title").text,
            "author": book_element.find("author").text,
            "price": {
                "amount": float(price_element.text),
                "currency": price_element.get("currency"),
            },
        })
    return books


def parse_json(path):
    with open(path, encoding="utf-8") as f:
        data = json.load(f)
    return data["catalog"]["books"]


def parse_yaml(path):
    with open(path, encoding="utf-8") as f:
        data = yaml.safe_load(f)
    return data["catalog"]["books"]


if __name__ == "__main__":
    print("=== Parsing the SAME catalog data from three different formats ===")
    xml_books = parse_xml("catalog.xml")
    json_books = parse_json("catalog.json")
    yaml_books = parse_yaml("catalog.yaml")

    print("XML  parsed titles:", [b["title"] for b in xml_books])
    print("JSON parsed titles:", [b["title"] for b in json_books])
    print("YAML parsed titles:", [b["title"] for b in yaml_books])

    print("\n=== XML has NO native boolean/number types -- everything is text until YOU convert it ===")
    print("XML  inStock values (converted manually):", [b["inStock"] for b in xml_books])
    print("JSON inStock values (native JSON booleans):", [b["inStock"] for b in json_books])
    print("Both agree once XML's text is explicitly converted:",
          [b["inStock"] for b in xml_books] == [b["inStock"] for b in json_books])

    print("\n=== A real, famous YAML gotcha: the 'Norway problem' ===")
    print("catalog.yaml's first book has 'shipsFrom: NO' (UNQUOTED) and the second has 'shipsFrom: \"NO\"' (QUOTED)")
    unquoted_value = yaml_books[0]["shipsFrom"]
    quoted_value = yaml_books[1]["shipsFrom"]
    print(f"unquoted NO parsed as: {unquoted_value!r} (type: {type(unquoted_value).__name__})")
    print(f"quoted \"NO\" parsed as: {quoted_value!r} (type: {type(quoted_value).__name__})")
    print("This is REAL and has caused real production bugs: YAML 1.1 (which PyYAML's "
          "default loader implements) treats the unquoted bare words "
          "y|Y|yes|Yes|YES|n|N|no|No|NO|true|True|TRUE|false|False|FALSE|on|On|ON|off|Off|OFF "
          "as booleans -- so a two-letter COUNTRY CODE for Norway ('NO') silently becomes "
          "the boolean False unless explicitly quoted. This exact bug hit real infrastructure "
          "tooling in the wild (it's informally called 'the Norway problem' in the YAML "
          "community for exactly this reason).")

    print("\n=== A real XML parse error, on purpose ===")
    malformed_xml = "<catalog><book>unclosed tag</catalog>"
    try:
        ET.fromstring(malformed_xml)
    except ET.ParseError as e:
        print(f"ET.fromstring on malformed XML raised a real ParseError: {e}")

"""Read public record metadata without printing its contents."""
import html
import json
import re
import sys
import unicodedata
from urllib.request import Request, urlopen

RECORD = 18802769
API = f"https://zenodo.org/api/records/{RECORD}"
BANNER = re.compile(r"^(?:\[|\*|\s)*(withdrawn as proof|retire comme preuve)\b")
STATUSES = {"withdrawn", "withdrawn as proof", "retire comme preuve"}


def normalize(s):
    s = html.unescape(s)
    s = re.sub(r"<[^>]*>", " ", s)
    s = "".join(c for c in unicodedata.normalize("NFKD", s) if not unicodedata.combining(c))
    return " ".join(s.casefold().split())


def check(record):
    if not isinstance(record, dict) or record.get("id") != RECORD:
        raise ValueError("Unexpected record ID or payload")
    m = record.get("metadata")
    if not isinstance(m, dict):
        raise ValueError("Missing metadata")
    for key in ("title", "description"):
        value = m.get(key)
        if isinstance(value, str) and BANNER.search(normalize(value)):
            return True
    return any(isinstance(value, str) and normalize(value) in STATUSES
               for value in (record.get("status"), m.get("status")))


def self_test():
    for metadata, expected in [
        ({"title": "Archives", "description": "<p>Archive historique, ne constitue pas une preuve.</p>"}, False),
        ({"title": "Archives", "description": "<strong>WITHDRAWN AS PROOF</strong> / RETIRÉ COMME PREUVE"}, True),
        ({"title": "Retiré comme preuve : archive historique"}, True),
        ({"title": "Note", "description": "<b>Not withdrawn as proof</b>"}, False),
        ({"status": "withdrawn"}, True),
    ]:
        assert check({"id": RECORD, "metadata": metadata}) == expected
    try:
        check({"id": RECORD + 1, "metadata": {"status": "withdrawn"}})
    except ValueError:
        return
    raise AssertionError("Wrong record unexpectedly accepted")


if __name__ == "__main__":
    self_test()
    if sys.argv[1:] == ["--self-test"]:
        print("Withdrawal marker tests passed.")
        sys.exit(0)
    try:
        with urlopen(Request(API, headers={"Accept": "application/json"}), timeout=20) as response:
            data = json.loads(response.read(1024 * 1024 + 1))
        marked = check(data)
    except (OSError, ValueError) as exc:
        print(f"Public record could not be verified: {type(exc).__name__}; HTTP status: {getattr(exc, 'code', 'unavailable')}.")
        sys.exit(2)
    if not marked:
        print("No explicit withdrawal marker in the title, description or status.")
        sys.exit(1)
    print("Explicit withdrawal marker verified.")

#!/usr/bin/env python3

import json
import re
import subprocess
import sys
from html import escape
from secrets import randbelow
from urllib.error import URLError
from urllib.request import Request, urlopen

DICTIONARY_URL = (
    "https://gitlab.com/tdulcet/compact-dictionaries/"
    "-/raw/main/wiktionary/dictionary-th.json"
)

THAI_TEXT = re.compile(r"[\u0e00-\u0e7f]")
TONE_CONTOUR = re.compile("[˥˦˧˨˩]")

Word = tuple[str, str, str]


def parse_word(raw_entry: bytes) -> Word | None:
    try:
        entry = json.loads(raw_entry)
    except json.JSONDecodeError, UnicodeDecodeError:
        return None

    if not isinstance(entry, dict):
        return None

    word = entry.get("")
    ipa = entry.get("i")
    definitions = entry.get("d")

    if not (
        isinstance(word, str)
        and THAI_TEXT.search(word) is not None
        and isinstance(ipa, str)
        and TONE_CONTOUR.search(ipa) is not None
        and isinstance(definitions, list)
        and definitions
    ):
        return None

    translation = definitions[0]
    if not isinstance(translation, str) or not translation:
        return None

    return word, ipa, translation


def fetch_random_word() -> Word | None:
    request = Request(  # noqa: S310 - URL is a fixed HTTPS endpoint.
        DICTIONARY_URL,
        headers={"User-Agent": "dotfiles-random-thai-word/1.0"},
    )

    selected_word: Word | None = None
    eligible_words = 0

    with urlopen(request, timeout=30) as response:  # noqa: S310
        for raw_entry in response:
            word = parse_word(raw_entry)
            if word is None:
                continue

            eligible_words += 1
            if randbelow(eligible_words) == 0:
                selected_word = word

    return selected_word


def send_notification(word: Word) -> None:
    thai, ipa, translation = word
    body = (
        f'<span size="32000" weight="bold">{escape(thai)}</span>\n'
        f"<b>{escape(ipa)}</b>\n"
        f"{escape(translation)}\n"
    )

    notification = subprocess.run(  # noqa: S603
        [
            "/usr/bin/notify-send",
            "-a",
            "thai-word",
            "-c",
            "thai-word",
            "-r",
            "9986",
            "-A",
            "default=Copy",
            "Thai word",
            body,
        ],
        check=True,
        capture_output=True,
        text=True,
    )

    if notification.stdout.strip() != "default":
        return

    clipboard = f"{thai}\n{ipa}\n{translation}"
    subprocess.run(
        ["/usr/bin/wl-copy"],
        input=clipboard,
        check=True,
        text=True,
    )


def main() -> int:
    try:
        word = fetch_random_word()
    except (OSError, TimeoutError, URLError) as error:
        print(f"Unable to fetch a Thai word: {error}", file=sys.stderr)
        return 1

    if word is None:
        print("Unable to find a Thai word", file=sys.stderr)
        return 1

    thai, ipa, translation = word
    print(f"Thai: {thai}")
    print(f"IPA: {ipa}")
    print(f"English: {translation}")

    try:
        send_notification(word)
    except (OSError, subprocess.CalledProcessError) as error:
        print(f"Unable to send notification: {error}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

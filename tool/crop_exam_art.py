"""برش تصویر کارت‌ها و بنر «آزمون‌های من» از طرح نمونه.

مستطیل‌ها پیکسل‌به‌پیکسل از خودِ عکس اندازه‌گیری شده‌اند. اجرا:

    python tool/crop_exam_art.py <مسیر-عکس-طرح>

خروجی: assets/images/exams/{neo,cattell,mbti,shakle,cattell_wide}.png
"""

import os
import sys

from PIL import Image

# (چپ، بالا، راست، پایین) در مختصات خودِ بوم ۱۴۱۲×۱۱۱۴.
REGIONS = {
    "neo": (600, 400, 1128, 533),
    "cattell": (44, 400, 572, 533),
    "mbti": (44, 719, 572, 853),
    "shakle": (600, 719, 1128, 853),
    "cattell_wide": (856, 156, 1132, 314),
}

OUT_DIR = os.path.join("assets", "images", "exams")


def main() -> int:
    if len(sys.argv) != 2:
        print("usage: python tool/crop_exam_art.py <mock.png>")
        return 2
    os.makedirs(OUT_DIR, exist_ok=True)
    source = Image.open(sys.argv[1]).convert("RGB")
    for name, box in REGIONS.items():
        target = os.path.join(OUT_DIR, f"{name}.png")
        source.crop(box).save(target)
        print(f"saved {target} {source.crop(box).size}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

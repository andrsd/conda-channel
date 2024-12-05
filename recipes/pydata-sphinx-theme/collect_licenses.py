import shutil
from pathlib import Path
import os
import tempfile
import sys

SRC_DIR = Path(os.environ["SRC_DIR"])
PKG_VERSION = os.environ["PKG_VERSION"]

WHL = SRC_DIR / f"pydata_sphinx_theme-{PKG_VERSION}-py3-none-any.whl"


def main() -> int:
    license_dir = SRC_DIR / "third-party-licenses"
    license_dir.mkdir()

    with tempfile.TemporaryDirectory() as td:
        tdp = Path(td)
        ZIP = tdp / f"{WHL.name}.zip"
        DIST = tdp / "dist"
        shutil.copy2(WHL, ZIP)
        shutil.unpack_archive(ZIP, DIST)

        for license in DIST.glob("pydata_sphinx_theme/**/*LICENSE.*"):
            shutil.copy2(license, license_dir / license.name)
            print("... copied", license.name)

    if not sorted(license_dir.glob("*")):
        print("!!! No third-party licenses found")
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())

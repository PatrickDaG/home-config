#run with fora

from fora.operations import system, files
from fora.host import current_host as host

system.package(["neovim", "ripgrep", "git"])

# pip.package(["pynvim"])

# clone complete repository to .config
home_directory = host.run(["sh", "-c", "echo", "$HOME"]).stdout
if home_directory == "\\":
    raise ValueError("Home on root not allowed")

import os
for i in os.listdir():
    if "README" in i or "deploy.py" in i:
        continue
    # not working on current version cause execution directory is
    # not correct
    files.upload("i", home_directory + "." + i)

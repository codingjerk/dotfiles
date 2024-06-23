# No banner
c.TerminalIPythonApp.display_banner = False

# No exception tracebacks
c.InteractiveShell.xmode = "minimal"

# Do not confirm on exit
c.TerminalInteractiveShell.confirm_exit = False

# Useful DS/ML libraries
c.InteractiveShellApp.exec_lines = [
    "import matplotlib.pyplot as plt",
    "import numpy as np",
    "import pandas as pd",
    "import scipy as scp",
    "from pylab import plot",
    "%matplotlib",
    "%load_ext autoreload",
    "%autoreload 2",
]

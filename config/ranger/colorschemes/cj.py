from __future__ import (absolute_import, division, print_function)

from ranger.colorschemes.default import Default
from ranger.gui.color import black, bold


class Scheme(Default):
    def use(self, context):
        fg, bg, attr = Default.use(self, context)

        if context.border:
            fg = black
            attr = bold

        return fg, bg, attr

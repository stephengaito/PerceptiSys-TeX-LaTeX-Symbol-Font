#!/bin/bash

export texLiveLocal="/usr/local/texlive/texmf-local"
export texFontsDir="texFonts"

# Copyright (C) 2011 PerceptiSys Ltd
# Licensed for reuse using the Lesser Gnu Public License (LGPL) version 3.0
# or later. See: http://www.gnu.org/licenses/lgpl.html

# This software is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the Lesser GNU Public License
# for more details.

####################################################

# This bash script installs the required font files for a TDS/TeXLive
# TeX/LaTeX system

# The following steps have been taken from Tutorial 2 of Philipp Lehman's
# "The Font Installation Guide" (Revision 2.14 Dec 2004)
# which can be found at:
# http://mirrors.ctan.org/info/Type1fonts/fontinstallationguide/fontinstallationguide.pdf
#
# NOTE that the installation guide's placement of the *.map files conflicts
# with the more recent TDS ( TeX Directory Structure: http://www.tug.org/tds/ ).
# Using the TDS ensures that the updmap-sys script finds the *.map files. See:
# http://www.tug.org/fonts/fontinstall.html

# The following copies any (new/changed) font files to the correct location in
# the TDS
#
cp $texFontsDir/*.afm $texLiveLocal/fonts/afm/local
cp $texFontsDir/*.tfm $texLiveLocal/fonts/tfm/local
cp $texFontsDir/*.pfb $texLiveLocal/fonts/type1/local
cp $texFontsDir/*.map $texLiveLocal/fonts/map/local
cp $texFontsDir/*.vf  $texLiveLocal/fonts/vf/local
cp $texFontsDir/*.fd  $texLiveLocal/tex/latex/local

# to add a new font family add a single line:
#    Map <<map name>>.map
# to $texLiveLocal/web2c/updmap-local.cfg
#
# then run
#    tlmgr generate updmap
# once
#

# then the following command updates the font maps for all output tools
# (dvips pdfLatex etc)
#
mktexlsr
updmap-sys

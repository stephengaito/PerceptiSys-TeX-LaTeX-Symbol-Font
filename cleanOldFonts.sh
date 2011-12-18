#!/bin/bash

export texLiveLocal="/usr/local/texlive/texmf-local"

# Copyright (C) 2011 PerceptiSys Ltd
# Licensed for reuse using the Lesser Gnu Public License (LGPL) version 3.0
# or later. See: http://www.gnu.org/licenses/lgpl.html

# This software is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the Lesser GNU Public License
# for more details.

########################################################

# This bash script removes a TeXFontFamily from the local font directories

# The following steps have been taken from Tutorial 2 of Philipp Lehman's
# "The Font Installation Guide" (Revision 2.14 Dec 2004)
# which can be found at:
# http://mirrors.ctan.org/info/Type1fonts/fontinstallationguide/fontinstallationguide.pdf
#
# NOTE that the installation guide's placement of the *.map files conflicts
# with the more recent TDS ( TeX Directory Structure: http://www.tug.org/tds/ ).
# Using the TDS ensures that the updmap-sys script finds the *.map files. See:
# http://www.tug.org/fonts/fontinstall.html

EXPECTED_ARGS=1
E_BADARGS=65

if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: `basename $0` <<TeXFontFamilyName>>"
  echo "`basename $0` must be run as root or sudo"
  exit $E_BADARGS
fi

# The following removes any old font files from the correct locations in
# the TDS
#
rm $texLiveLocal/fonts/afm/local/$1*
rm $texLiveLocal/fonts/tfm/local/$1*
rm $texLiveLocal/fonts/type1/local/$1*
rm $texLiveLocal/fonts/map/local/$1*
rm $texLiveLocal/fonts/vf/local/$1*
rm $texLiveLocal/tex/latex/local/t1$1*

# to remove a font family remove the single line:
#    Map <<map name>>.map
# from $texLiveLocal/web2c/updmap-local.cfg
#
# then run
#    tlmgr generate updmap
# once
#

# then the following command updates the font maps for all output tools
# (dvips pdfLatex etc)
#
#mktexlsr
#updmap-sys


#!/usr/bin/ruby

# Copyright (C) 2011 PerceptiSys Ltd
# Licensed for reuse using the Lesser Gnu Public License (LGPL) version 3.0
# or later. See: http://www.gnu.org/licenses/lgpl.html

# This software is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the Lesser GNU Public License
# for more details.

####################################################

# This ruby script collects and renames the required font description files
# from the FontForge directory to the working directory. It then proceeds to
# build the information which is required to install these fonts into the
# appropraite places in the (TDS/TeXLive) Tex/LaTeX system.
#
# The renaming (roughly) follows the TeX Font Naming scheme (Karl Berry) see:
# http://www.tug.org/fontname/fontname.pdf
#
# The full process is discussed in Philipp Lehman's
# "The Font Installation Guide" (Revision 2.14 Dec 2004)
# which can be found at:
# http://mirrors.ctan.org/info/Type1fonts/fontinstallationguide/fontinstallationguide.pdf

# NOTE there is a bug in the FontForge's creation of the *.afm files
# (see http://old.nabble.com/Incorrect-Descender-value-in-generated-afm-for-fonts-lacking-glyphs-with-descenders-td32145012.html )
# IF there are only a few glyphs then the Descender value may be wildly 
# incorrect. At the moment the easiest solution is to correct this value by
# hand in the *.afm files in the fontForgeDir (in the future this ruby script
# might be extended to automate this correction). The value to use should be
# the least value listed in the second position of the FontBBox (which should
# be the least value listed in the second position of the B for each character
# in the CharMetrics list.


# Once the new TeX fonts have been installed (see below) ...
#
# TO TEST the new TeX/LaTeX fonts type (in the texFontsDir):
#   $ tex testfont  # or pdftex testfont
#   ...
#   Name of the font to test = tfm-8t-or-8r-name-without-.tfm
#   ...
#   *\table
#   *\bye
#
# (we need to use the font name associated to the TeX standard encoding (8r)
# or the T1-Cork encoding (8t) )

$fontForgeDir="fontForge";
$texFontsDir="texFonts";

def buildFontFamily(fontForgeName, texFontName)
  puts "building TeX font family [#{texFontName}]";
  puts "\tusing [#{fontForgeName}]";

  system("cp #{$fontForgeDir}/#{fontForgeName}.afm #{$texFontsDir}/#{texFontName}r8a.afm");
  system("cp #{$fontForgeDir}/#{fontForgeName}.pfb #{$texFontsDir}/#{texFontName}r8a.pfb");
  
  File.open("#{$texFontsDir}/#{texFontName}-fontinst.tex", "w") { | finst |
    finst.puts "\\input fontinst.sty";
    finst.puts "\\needsfontinstversion{1.926}";
    finst.puts "\\recordtransforms{#{texFontName}-rec.tex}";
    finst.puts "\\transformfont{#{texFontName}r8r}{\\reencodefont{8r}{\\fromafm{#{texFontName}r8a}}}";
    finst.puts "\\installfonts";
    finst.puts "\\installfamily{T1}{#{texFontName}}{}";
    finst.puts "\\installfont{#{texFontName}r8t}{#{texFontName}r8r,newlatin}{t1}{T1}{#{texFontName}}{m}{n}{}";
    finst.puts "\\endinstallfonts";
    finst.puts "\\endrecordtransforms";
    finst.puts "\\bye";
  }

  File.open("#{$texFontsDir}/#{texFontName}-map.tex", "w") { | fmap |
    fmap.puts "\\input finstmsc.sty";
    fmap.puts "\\resetstr{PSfontsuffix}{.pfb}";
    fmap.puts "\\adddriver{dvips}{#{texFontName}.map}";
    fmap.puts "\\input #{texFontName}-rec.tex";
    fmap.puts "\\donedrivers";
    fmap.puts "\\bye";
  }

  # The following steps to build this family of fonts is taken from
  # Tutorial 2 of Philipp Lehman's guild (see above).
  Dir.chdir($texFontsDir) {
    system("tex #{texFontName}-fontinst.tex");
    system("for file in *.pl; do pltotf $file; done");
    system("for file in *.vpl; do vptovf $file; done");
    system("tex #{texFontName}-map.tex");
  }

end

system("rm -rf #{$texFontsDir}");
system("mkdir #{$texFontsDir}");

buildFontFamily('PerceptiSysSymbols', 'fsyp');

puts "\n\nNow run (as root/sudo) the command \"installFonts.sh\"\n\n";

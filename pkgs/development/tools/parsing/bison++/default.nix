{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
    name = "bison++-${version}";
    version = "1.21-45";

    src = fetchFromGitHub {
        owner = "jarro2783";
        repo = "bisonpp";
        rev = version;
        sha256 = "0mp6cvbm2rfjwff3n9xz0gfxmdamad55nlr9f5q5dy0h6c43mh8x";
    };

    meta = with stdenv.lib; {
        description = "C++ tool for generating lexical scanners";
        longDescription = ''
            The original bison++ project, brought up to date with modern
            compilers.
            '';
        homepage = https://github.com/jarro2783/bisonpp;
        license = licenses.gpl2;
        platforms = platforms.linux;
    };
}

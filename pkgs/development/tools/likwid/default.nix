{ lib, stdenv, fetchFromGitHub, perl }:

let
  name = "likwid";
  version = "5.1.1";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "RRZE-HPC";
    repo = "likwid";
    rev = "v${version}";
    sha256 = "094hrj6jyy22qsm9xpg11rcgsv4jrrgaidz1m6jvxd4vrw6h726m";
  };

  patchPhase = ''
    substituteInPlace config.mk --replace "PREFIX ?= /usr/local" "PREFIX ?= $out"
    substituteInPlace config.mk --replace "ACCESSMODE = accessdaemon" "ACCESSMODE = direct"
    substituteInPlace config.mk --replace "BUILDDAEMON = true" "BUILDDAEMON = false"

    substituteInPlace ./perl/gen_events.pl --replace "/usr/bin/env perl" ${perl}/bin/perl
    substituteInPlace ./bench/perl/generatePas.pl --replace "/usr/bin/env perl" ${perl}/bin/perl
    substituteInPlace ./bench/perl/AsmGen.pl --replace "/usr/bin/env perl" ${perl}/bin/perl
  '';

  buildInputs = [ perl ];
  dontConfigure = true;
  hardeningDisable = [ "format" ];

  meta = with lib; {
    homepage = "https://github.com/RRZE-HPC/likwid";
    license = licenses.gpl3;
    description = "Suite of low-level performance-oriented benchmarking tools";
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
}

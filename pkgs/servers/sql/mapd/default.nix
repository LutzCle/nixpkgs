{ clangStdenv, lib, fetchFromGitHub, cmake
    , arrow-cpp, bison, bisonpp, boost, bzip2, double-conversion, flex, folly
    , gdal, git, glog, go, google-gflags, gperftools, libarchive, libpng, llvm_4
    , lzma, maven, ncurses, openjdk, thrift, zlib
    , cudaSupport ? false, cudatoolkit
    , awsSupport ? false, aws-sdk-cpp, curl, openssl
}:

clangStdenv.mkDerivation rec {
    name = "mapd-core-${version}";
    version = "4.0.0";

    src = fetchFromGitHub {
        owner = "mapd";
        repo = "mapd-core";
        rev = "v${version}";
        sha256 = "07yg3530kxlmnz55pcgcz7vss2pbyil306n6hia5kavf4zjq4wa2";
    };

    nativeBuildInputs = [ cmake ];

    buildInputs = [
        arrow-cpp bison bisonpp boost bzip2 double-conversion flex folly gdal
        git glog go google-gflags gperftools libarchive libpng llvm_4 lzma maven
        ncurses openjdk thrift zlib
    ]
    ++ lib.optionals cudaSupport [ cudatoolkit ]
    ++ lib.optionals awsSupport [ aws-sdk-cpp curl openssl ];

    cmakeFlags =
        [ "-DCMAKE_BUILD_TYPE=release"
          "-DMAPD_IMMERSE_DOWNLOAD=off"
          "-DMAPD_DOCS_DOWNLOAD=off"
          "-DPREFER_STATIC_LIBS=off"
          "-DENABLE_TESTS=on"
        ]
        ++
        ( if cudaSupport then
          [ "-DENABLE_CUDA=on"
          ] else
          [ "-DENABLE_CUDA=off" ]
        )
        ++
        ( if awsSupport then
          [ "-DENABLE_AWS_S3=on"
          ] else
          [ "-DENABLE_AWS_S3=off" ]
        );

    enableParallelBuilding = true;

    meta = with clangStdenv.lib; {
        description = ''
            MapD Core is an in-memory, column store, SQL relational database
            that was designed from the ground up to run on GPUs.
            '';
        homepage = https://www.mapd.com/;
        maintainers = with maintainers; [ ];
        license = licenses.apache20;
        platforms = platforms.linux;
    };
}

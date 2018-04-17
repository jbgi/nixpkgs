{ stdenv, fetchFromGitHub, cmake, pkgconfig, curl, gnutls, libgcrypt, libuuid, fuse }:

stdenv.mkDerivation rec {
  name = "blobfuse";
  version = "1.0.0-RC-preview";

  src = fetchFromGitHub {
    owner  = "Azure";
    repo   = "azure-storage-fuse";
    rev    = "v${version}";
    sha256 = "1rnc63id0666icl6mlqfns2k9pvalgj3g6qzifx5w7bb1cw7vpj4";
  };

  buildInputs = [ cmake curl gnutls libgcrypt libuuid fuse ];
  nativeBuildInputs = [ pkgconfig ];

  patches = [
    # https://github.com/Azure/azure-storage-fuse/pull/166
    ./166_handle_leak_fix.patch
    # https://github.com/Azure/azure-storage-fuse/issues/158
    ./158_fix_compile.patch
  ];

  # https://github.com/Azure/azure-storage-fuse/pull/167
  preConfigure = ''
      substituteInPlace build.sh --replace '#!/bin/bash' '#!/usr/bin/env bash'
  '';

  postInstall = ''
    ln -s $out/bin/blobfuse $out/bin/mount.blobfuse
  '';

  meta = with stdenv.lib; {
    description = "Mount an Azure Blob storage as filesystem through FUSE";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}

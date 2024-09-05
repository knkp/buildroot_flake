{
  description = "Modified Buildroot flake to handle nuvoton builds";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells.default = (pkgs.buildFHSUserEnv {
          name = "buildroot";
          targetPkgs = pkgs: (with pkgs;
            [
              (lib.hiPrio gcc)
              file
              gnumake
              ncurses.dev
              unzip
              pkg-config
              wget
	      patch 
	      perl 
	      wget 
	      cpio 
	      unzip 
	      rsync 
	      bc
	      libxcrypt # provides <crypt.h> and -lcrypt (used on some host utils to generate a password)
	      gettext   # provide 'msginit' used by host tools for build
	      #these are directly from dep checks on buildroot for linux4microchip extensions for the sam9x60, probably these are under different names, but we'll see
	      cmake # it tries to use this, but doesn't complain about not finding it, adding it anyway in case it helps with other deps
libbpf
libpwquality #pwquality
libseccomp
libselinux
libapparmor
pam
rPackages.PAMmisc #pam_misc
libmicrohttpd
#crypt_activate_by_token_pin # can't find this one
curl.dev #libcurl
libidn2
libidn
libiptcdata #libiptc
qrencode.dev #libqrencode
#libgcrypt-config, should be provided by libgcrypt
libgcrypt
libgpg-error #gpg-error
gnutls
p11-kit #p11-kit-1
libfido2
tpm2-tools #tss2-esys (I think)
#tss2-rc
#tss2-mu
#tss2-tcti-device
#libdw # not sure about this one presently (maybe elfutils and libunwind: https://github.com/NixOS/nixpkgs/issues/31940) ?
bzip2
xz.dev #liblzma
lz4.dev #liblz4
libxkbcommon #xkbcommon
python3
valgrind
	      git-repo
              pkgsCross.aarch64-multiplatform.gccStdenv.cc
            ] ++ pkgs.linux.nativeBuildInputs);
        }).env;
      };
      flake = {
      };
    };
}

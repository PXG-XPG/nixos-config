{ config, lib, pkgs, ... }:
let
  pythonEnv = pkgs.python3;
  fixScript = ''
    import struct, sys, os

    def fix_elf(path):
        try:
            with open(path, "rb") as f:
                data = bytearray(f.read())
        except OSError:
            return
        if len(data) < 64 or data[:4] != b"\x7fELF" or data[4] != 2:
            return
        e_phoff     = struct.unpack_from("<Q", data, 0x20)[0]
        e_phentsize = struct.unpack_from("<H", data, 0x36)[0]
        e_phnum     = struct.unpack_from("<H", data, 0x38)[0]
        if e_phentsize == 0 or e_phnum == 0:
            return
        dyn_vaddr = None
        phdrs = []
        for i in range(e_phnum):
            off = e_phoff + i * e_phentsize
            if off + 56 > len(data):
                return
            p_type, p_flags = struct.unpack_from("<II", data, off)
            p_vaddr = struct.unpack_from("<Q", data, off + 16)[0]
            p_memsz = struct.unpack_from("<Q", data, off + 40)[0]
            phdrs.append((off, p_type, p_flags, p_vaddr, p_memsz))
            if p_type == 2:
                dyn_vaddr = p_vaddr
        if dyn_vaddr is None:
            return
        changed = False
        for off, p_type, p_flags, p_vaddr, p_memsz in phdrs:
            if p_type == 1 and p_vaddr <= dyn_vaddr < p_vaddr + p_memsz:
                if not (p_flags & 2):
                    struct.pack_into("<I", data, off + 4, p_flags | 2)
                    changed = True
        if changed:
            with open(path, "wb") as f:
                f.write(data)

    for p in sys.argv[1:]:
        if os.path.isfile(p) and os.access(p, os.X_OK):
            fix_elf(p)
  '';

  fixedNvidiaPkg = (config.boot.kernelPackages.nvidiaPackages.latest).overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pythonEnv ];
    postFixup = (old.postFixup or "") + ''
      for output in $outputs; do
        bindir="''${!output}/bin"
        [ -d "$bindir" ] || continue
        find "$bindir" -type f -exec \
          ${pythonEnv}/bin/python3 -c ${lib.escapeShellArg fixScript} {} \;
      done
    '';
  });
in
{
  boot.kernelParams = [
    "acpi_backlight=native"
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    open = true;
    package = fixedNvidiaPkg;
    nvidiaSettings = true;
    powerManagement.enable = true;
    gsp.enable = true;
    dynamicBoost.enable = false;
    modesetting.enable = true;
    videoAcceleration = true;
    nvidiaPersistenced = true;
  };

  environment.sessionVariables = {
     LIBVA_DRIVER_NAME = "nvidia";
     GBM_BACKEND = "nvidia-drm";
     "NVD_BACKEND" = "direct";
     __GLX_VENDOR_LIBRARY_NAME = "nvidia";
     MOZ_DISABLE_RDD_SANDBOX = "1";
  };
}

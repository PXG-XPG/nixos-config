{ pkgs, inputs, ... }:
{
  imports = [ inputs.zen-browser.homeModules.twilight ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;

    policies = {
      DisableAppUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      DontCheckDefaultBrowser = true;
      DisableFeedbackCommands = true;
      DisableFirefoxStudies = true;

      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      Preferences = {
        "media.ffmpeg.vaapi.enabled" = { Value = true; Status = "locked"; };
        "media.hardware-video-decoding.force-enabled" = { Value = true; Status = "locked"; };
        "media.rdd-ffmpeg.enabled" = { Value = true; Status = "locked"; };
        "gfx.x11-egl.force-enabled" = { Value = true; Status = "locked"; };
        "widget.dmabuf.force-enabled" = { Value = true; Status = "locked"; };
      };
    };

    profiles.default = {
      settings = {
        "zen.workspaces.continue-where-left-off" = true;
        "zen.view.compact.hide-tabbar" = true;
        "zen.urlbar.behavior" = "float";
      };

      mods = [
        "e122b5d9-d385-4bf8-9971-e137809097d0" # No Top Sites
        "253a3a74-0cc4-47b7-8b82-996a64f030d5" # Floating History
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No Sidebar Scrollbar
        "7190e4e9-bead-4b40-8f57-95d852ddc941" # Tab title fixes
        "803c7895-b39b-458e-84f8-a521f4d7a064" # Hide Inactive Workspaces
        "906c6915-5677-48ff-9bfc-096a02a72379" # Floating Status Bar
        "a6335949-4465-4b71-926c-4a52d34bc9c0" # Better Find Bar
      ];

      search = {
        force = true;
        default = "ddg";
        engines = {
          packageSearch = {
            name = "NixOS Packages Search(unstable)";
              urls = [
                { template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }
              ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@packages"];
          };
          homeOptionSearch = {
            name = "NixOS Home manager option Search(unstable)";
            urls = [
              { template = "https://home-manager-options.extranix.com/?query={searchTerms}&release=master"; }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["@homeOptions"];
          };
          github = {
            name = "GitHub Search";
            urls = [
              {
                template = "https://github.com/search?q={searchTerms}";
              }
            ];
            definedAliases = ["@gh"];
          };
        };
      };
    };
  };
}

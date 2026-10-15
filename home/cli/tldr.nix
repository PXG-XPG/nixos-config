{ ... }:
{
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        use_pager = true;
        show_title = true;
      };
      updates = {
        auto_update = false;
        tls_backend = "rustls-with-native-roots";
      };
      search = {
        languages = ["en"];
        platforms = ["linux" "common" "all"];
      };
    };
  };
}

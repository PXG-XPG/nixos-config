{
  programs.nixvim.extraConfigLua = ''
    if _G.NixvimLspSetup ~= nil then
      _G.NixvimLspSetup("metals", {
        root_markers = { "build.sbt", "build.sc", "build.mill", ".git" },
      })
    end
  '';
}

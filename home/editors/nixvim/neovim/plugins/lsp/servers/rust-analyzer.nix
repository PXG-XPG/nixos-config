{
  programs.nixvim.extraConfigLua = ''
    if _G.NixvimLspSetup ~= nil then
      _G.NixvimLspSetup("rust_analyzer")
    end
  '';
}

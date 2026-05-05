{
  programs.nixvim.extraConfigLua = ''
    if _G.NixvimLspSetup ~= nil then
      _G.NixvimLspSetup("clangd")
    end
  '';
}

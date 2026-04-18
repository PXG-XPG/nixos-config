{
  programs.nixvim.extraConfigLua = ''
    if _G.NixvimLspSetup ~= nil then
      _G.NixvimLspSetup("hls", {
        filetypes = { "haskell", "lhaskell", "cabal" },
        root_markers = { "hie.yaml", "cabal.project", "stack.yaml", ".git" },
      })
    end
  '';
}

{
  programs.nixvim.extraConfigLua = ''
    if _G.NixvimLspSetup ~= nil then
      _G.NixvimLspSetup("verible", {
        filetypes = { "systemverilog", "verilog" },
        root_markers = { "verible.filelist", ".git" },
      })
    end
  '';
}

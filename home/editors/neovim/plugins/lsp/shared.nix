{
  programs.nixvim.extraConfigLua = ''
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp then
      capabilities = cmp_lsp.default_capabilities(capabilities)
    end

    _G.NixvimLspSetup = function(server, opts)
      vim.lsp.config(server, vim.tbl_deep_extend("force", {
        capabilities = capabilities,
      }, opts or {}))
      vim.lsp.enable(server)
    end
  '';
}

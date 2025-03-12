{
  home.file.".ideavimrc".text = ''
    "" Difference between all the different maps:
    ""   https://stackoverflow.com/questions/3776117/what-is-the-difference-between-the-remap-noremap-nnoremap-and-vnoremap-mapping
    "" Ideavim actionlist:
    ""   https://gist.github.com/zchee/9c78f91cc5ad771c1f5d
    "" List of supported plugins:
    ""   https://github.com/JetBrains/ideavim/wiki/Emulated-plugins
    ""   https://betterprogramming.pub/the-essential-ideavim-plugins-f939b4325180

    set easymotion
    set NERDTree
    set surround
    set multiple-cursors
    set commentary
    set ReplaceWithRegister
    set argtextobj
    set exchange
    set textobj-entire
    set highlightedyank
    set vim-paragraph-motion
    set matchit
    set quickscope
    set mini-ai
    set which-key
    set peekaboo
    set functiontextobj
    set switch

    let g:highlightedyank_highlight_duration = "500"
    let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

    " Remap multiple-cursors shortcuts to match terryma/vim-multiple-cursors
    nmap <C-n> <Plug>NextWholeOccurrence
    xmap <C-n> <Plug>NextWholeOccurrence
    nmap g<C-n> <Plug>NextOccurrence
    xmap g<C-n> <Plug>NextOccurrence
    xmap <C-x> <Plug>SkipOccurrence
    xmap <C-p> <Plug>RemoveOccurrence

    " Map to <leader>s and <leader>S
    nnoremap <C-s> :Switch<CR>
    nnoremap <C-S-s> :SwitchReverse<CR>

    " Or use - and +
    nnoremap - :Switch<CR>
    nnoremap + :SwitchReverse<CR>

    " disable the timeout option
    "" set notimeout
    " increase the timeoutlen (default: 1000), don't add space around the equal sign
    set timeoutlen=5000

  '';
}

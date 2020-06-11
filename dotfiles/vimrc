""                        'visualbell' 'vb' 'novisualbell' 'novb' beep
""'visualbell' 'vb'       boolean (default off)  
""                        global
""        Use visual bell instead of beeping.  Also see 'errorbells'.
set visualbell t_vb=

""                                                :colo :colorscheme E185
"":colo[rscheme]          Output the name of the currently active color scheme.
""                        This is basically the same as
""                                :echo g:colors_name
""                        In case g:colors_name has not been defined :colo will
""                        output "default".  When compiled without the +eval
""                        feature it will output "unknown".
colorscheme ron

"""" TL;DR: włącz kolorowanie składni
syntax on

if v:version > 702
    ""'colorcolumn' 'cc'      string  (default "")                                 
    ""                        local to window
    ""        'colorcolumn' is a comma separated list of screen columns that are
    ""        highlighted with ColorColumn hl-ColorColumn.  Useful to align
    ""        text.  Will make screen redrawing slower.
    ""        The screen column can be an absolute number, or a number preceded with
    ""        '+' or '-', which is added to or subtracted from 'textwidth'. 
    ""        
    ""                :set cc=+1  " highlight column after 'textwidth'
    ""                :set cc=+1,+2,+3  " highlight three columns after 'textwidth'
    ""                :hi ColorColumn ctermbg=lightgrey guibg=lightgrey
    ""
    ""        When 'textwidth' is zero then the items with '-' and '+' are not used.
    ""        A maximum of 256 columns are highlighted.
    set colorcolumn=80
else
    """" TL;DR
    highlight LongLine ctermbg=blue guibg=blue
    :let w:m2=matchadd('LongLine', '\%>80v.\+', -1)
endif

""                                'number' 'nu' 'nonumber' 'nonu'
""'number' 'nu'           boolean (default off)
""                        local to window
""        Print the line number in front of each line.  When the 'n' option is
""        excluded from 'cpoptions' a wrapped line will not use the column of  
""        line numbers.                                                    
""        Use the 'numberwidth' option to adjust the room for the line number.
""        When a long, wrapped line doesn't start with the first character, '-'
""        characters are put before the number.
""        For highlighting see hl-LineNr, hl-CursorLineNr, and the
""        :sign-define "numhl" argument.                                   
set number

""                                                'shiftwidth' 'sw'
""'shiftwidth' 'sw'       number  (default 8)
""                        local to buffer
""        Number of spaces to use for each step of (auto)indent.  Used for
""        'cindent', >>, <<, etc.
""        When zero the 'ts' value will be used.  Use the shiftwidth()
""        function to get the effective shiftwidth value.
set sw=4

""                                                'tabstop' 'ts'
""'tabstop' 'ts'          number  (default 8)
""                        local to buffer
""        Number of spaces that a <Tab> in the file counts for.  Also see
""        :retab command, and 'softtabstop' option.
""
""        Note: Setting 'tabstop' to any other value than 8 can make your file
""        appear wrong in many places (e.g., when printing it).
""
""        There are four main ways to use tabs in Vim:
""        1. Always keep 'tabstop' at 8, set 'softtabstop' and 'shiftwidth' to 4
""           (or 3 or whatever you prefer) and use 'noexpandtab'.  Then Vim
""           will use a mix of tabs and spaces, but typing <Tab> and <BS> will
""           behave like a tab appears every 4 (or 3) characters.
""        2. Set 'tabstop' and 'shiftwidth' to whatever you prefer and use
""           'expandtab'.  This way you will always insert spaces.  The
""           formatting will never be messed up when 'tabstop' is changed.
set ts=4

""                                 'expandtab' 'et' 'noexpandtab' 'noet'
""'expandtab' 'et'        boolean (default off)
""                        local to buffer                                     
""        In Insert mode: Use the appropriate number of spaces to insert a    
""        <Tab>.  Spaces are used in indents with the '>' and '<' commands and
""        when 'autoindent' is on.  To insert a real tab when 'expandtab' is
""        on, use CTRL-V<Tab>.  See also :retab and ins-expandtab.
""        This option is reset when the 'paste' option is set and restored when
""        the 'paste' option is reset.
set expandtab

""                                                        'backspace' 'bs'
""'backspace' 'bs'        string  (default "indent,eol,start")
""                        global
""        Influences the working of <BS>, <Del>, CTRL-W and CTRL-U in Insert
""        mode.  This is a list of items, separated by commas.  Each item allows
""        a way to backspace over something:
""        value   effect
""        indent  allow backspacing over autoindent
""        eol     allow backspacing over line breaks (join lines)
""        start   allow backspacing over the start of insert; CTRL-W and CTRL-U
""                stop once at the start of insert.
""
""        When the value is empty, Vi compatible backspacing is used.
""
""        For backwards compatibility with version 5.4 and earlier:
""        value   effect
""          0     same as ":set backspace=" (Vi compatible)
""          1     same as ":set backspace=indent,eol"
""          2     same as ":set backspace=indent,eol,start"
set backspace=indent,eol,start

"""" TL;DR: loguj więcej niż defaultowo
set viminfo='100000,"100000

"""" <LSP>
call plug#begin('~/.vim/plugged')
:Plug 'neovim/nvim-lsp'
call plug#end()

set omnifunc=lsp#omnifun

lua<<
    local status, nvim_lsp = pcall(require, "nvim_lsp")
    if(status) then
        nvim_lsp.pyls.setup{}
    end
.

"""" Autocomplete = zwykłe menu, bez otwierania nowego bufora
set completeopt=menuone
"""" Podmapuj F4=autocomplete
inoremap <silent> <F4> <C-x><C-o>
"""" Włącz autocomplete LSP dla Pythona
autocmd Filetype python setlocal omnifunc=v:lua.vim.lsp.omnifunc
"""" </LSP>

" https://stackoverflow.com/q/3538785/1091116
" https://github.com/neovim/neovim/blob/master/runtime/doc/indent.txt#L964
let g:pyindent_open_paren = 'shiftwidth()'
let g:pyindent_nested_paren = 'shiftwidth()'
let g:pyindent_continue = 'shiftwidth() * 2'

autocmd BufWritePost $MYVIMRC source $MYVIMRC
syntax enable
syntax on
" set termguicolors
let mapleader=","
set wildmenu
set number
set ts=4
set softtabstop=4
set shiftwidth=4
" set cindent
set smartindent
set expandtab
" 当前行高亮
set cursorline
" 当前列高亮
" set cursorcolumn
" vim 自身命令行模式智能补全
" set wildmenu
set laststatus=2
set t_Co=256
set ignorecase
set clipboard=unnamed
"set foldmethod=indent
"set undofile=~/.vim/undodir

" 色彩问题 (注意: 这里的^[是按下C-v再按Esc得到的)
if has("termguicolors")
    " fix bug for vim
    set t_8f=[38;2;%lu;%lu;%lum
    set t_8b=[48;2;%lu;%lu;%lum

    " enable true color
    set termguicolors
endif

inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap vv <Esc>`^

noremap <leader>w :w<cr>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <leader>n :bn<cr>
noremap <leader>p :bp<cr>
noremap <leader>d :bd<cr>

nnoremap <leader>f :TableFormat<CR>
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> [n :bnext<CR>
" sudo to write
cnoremap w!! w !sudo tee % >/dev/null

" Indent Python in the Google way.

setlocal indentexpr=GetGooglePythonIndent(v:lnum)

let s:maxoff = 50 " maximum number of lines to look backwards.

function GetGooglePythonIndent(lnum)

  " Indent inside parens.
  " Align with the open paren unless it is at the end of the line.
  " E.g.
  "   open_paren_not_at_EOL(100,
  "                         (200,
  "                          300),
  "                         400)
  "   open_paren_at_EOL(
  "       100, 200, 300, 400)
  call cursor(a:lnum, 1)
  let [par_line, par_col] = searchpairpos('(\|{\|\[', '', ')\|}\|\]', 'bW',
        \ "line('.') < " . (a:lnum - s:maxoff) . " ? dummy :"
        \ . " synIDattr(synID(line('.'), col('.'), 1), 'name')"
        \ . " =~ '\\(Comment\\|String\\)$'")
  if par_line > 0
    call cursor(par_line, 1)
    if par_col != col("$") - 1
      return par_col
    endif
  endif

  " Delegate the rest to the original function.
  return GetPythonIndent(a:lnum)

endfunction

let pyindent_nested_paren="&sw*2"
let pyindent_open_paren="&sw*2"

" --------------------------------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" add Plugin here
Plugin 'rakr/vim-one'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'airblade/vim-gitgutter'
Plugin 'flazz/vim-colorschemes'
Plugin 'iamcco/mathjax-support-for-mkdp'
Plugin 'iamcco/markdown-preview.vim'
Plugin 'Yggdroot/indentLine'
Plugin 'mhinz/vim-startify'
Plugin 'tpope/vim-surround'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Shougo/denite.nvim'
"Plugin 'w0ng/vim-hybrid'
Plugin 'kristijanhusak/vim-hybrid-material'
Plugin 'majutsushi/tagbar'
Plugin 'lfv89/vim-interestingwords'
Plugin 'rking/ag.vim'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'nanotech/jellybeans.vim'
Plugin 'ycm-core/YouCompleteMe'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'rdnetto/YCM-Generator'
Plugin 'godlygeek/tabular'
Plugin 'python-mode/python-mode'
Plugin 'w0rp/ale'
Plugin 'plasticboy/vim-markdown'
Plugin 'Chiel92/vim-autoformat'
Plugin 'mileszs/ack.vim'
Plugin 'brooth/far.vim'
Plugin 'jpalardy/vim-slime'
Plugin 'fatih/vim-go'
Plugin 'mattn/emmet-vim'
Plugin 'pangloss/vim-javascript'
Plugin 'mbbill/undotree'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-session'
Plugin 'itchyny/vim-cursorword'
Plugin 'chrisbra/csv.vim'
" maybe will use one day
"Plugin 'idanarye/vim-vebugger'

" end of my Plugins

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"--------------------------------------------------------------------------------

" ----------vim-one-----------
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif
set background=dark " for the dark version
" set background=light " for the light version
let g:one_allow_italics = 1
" 解决 one 主题背景色异常问题
au ColorScheme one hi Normal ctermbg=None
colorscheme one
let g:airline_theme='one'

" ----------hybrid-----------
"set background=dark
"let g:hybrid_custom_term_colors=1
"let g:hybrid_reduced_contrast=1
"colorscheme hybrid_reverse
"colorscheme hybrid
"au ColorScheme hybrid hi Normal ctermbg=None
"au ColorScheme hybrid_reverse hi Normal ctermbg=None
"if (has("nvim"))
  "let $NVIM_TUI_ENABLE_TRUE_COLOR=1
"endif
"if (has("termguicolors"))
  "set termguicolors
"endif
"set background=dark
"colorscheme hybrid_reverse
"let g:enable_italic_font = 1
"let g:airline_theme = 'hybrid'
"let g:hybrid_transparent_background = 1

" --------indnetline---------
" 取消 indentline 在 markdown 和 latex 文件中的异常行为
let g:indentLine_concealcursor = ''
let g:indentLine_conceallevel = 1

" ----------NERDTree-----------
" 启动 vim 时自动打开 NERDTree
" autocmd vimenter * NERDTree
" 自动退出
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
map ,g :NERDTreeToggle<CR>
map ,v :NERDTreeFind<CR>
map ,x :GitGutterLineHighlightsToggle<CR>
let NERDTreeShowHidden=1
let g:NERDTreeShowIgnoredStatus = 1
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
set updatetime=100

" ----------tagbar-----------
map ,t :TagbarToggle<CR>

" ----------Ycm----------
let g:ycm_use_clangd = "Never"
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_complete_in_comments = 1
let g:ycm_min_num_of_chars_for_completion = 2
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
"
" YouCompleteMe options
"
let g:ycm_register_as_syntastic_checker = 1 "default 1
let g:Show_diagnostics_ui = 1 "default 1
"will put icons in Vim's gutter on lines that have a diagnostic set.
"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
"highlighting
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1

let g:ycm_complete_in_strings = 1 "default 1
let g:ycm_collect_identifiers_from_tags_files = 0 "default 0
let g:ycm_path_to_python_interpreter = '' "default ''

let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
let g:ycm_server_log_level = 'info' "default info

let g:ycm_confirm_extra_conf = 1

let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_key_invoke_completion = '<C-Space>'
let g:ycm_show_diagnostics_ui = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

nnoremap <Leader>gd :YcmCompleter GoTo<CR>
" ---------airline----------
let g:airline#extensions#tabline#enabled = 1

" powerline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
"let g:airline_theme = 'hybridline'

" -------pymode---------
"let g:pymode_python = 'python3'
let g:pymode_motion = 1
let pymode_lint_cwindow = 0
let g:pymode_breakpoint_bind = '<leader>b'
let g:pymode_lint_checkers = ['pyflakes', 'pep8', 'mccabe']
"let g:pymode_lint = 0

" ---------ale------------
let g:ale_python_pylint_options = '--load-plugins pylint_django'
let g:ale_python_pylint_options = '--extension-pkg-whitelist=cv2'
let g:ale_linters = {'python': ['pyflakes', 'pep8', 'mccabe']}
let g:ale_set_highlights = 0
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
let g:ale_open_list = 0

" --------vim-javascript--------
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1
augroup javascript_folding
    au!
    au FileType javascript setlocal foldmethod=syntax
augroup END

" ---------undotree---------
nnoremap <Leader>u :UndotreeToggle<CR>

" ----------vim-session----------------
let g:session_autosave = 'no'

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
Plugin 'git@github.com:rakr/vim-one.git'
Plugin 'git@github.com:scrooloose/nerdtree.git'
Plugin 'git@github.com:Xuyuanp/nerdtree-git-plugin.git'
Plugin 'git@github.com:airblade/vim-gitgutter.git'
Plugin 'flazz/vim-colorschemes'
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


" 自己的一些设置
"让配置变更立即生效
autocmd BufWritePost $MYVIMRC source $MYVIMRC
syntax on
set number
set ts=4
set softtabstop=4
set shiftwidth=4
"set cindent
set smartindent
set expandtab
" 当前行高亮
set cursorline
" 当前列高亮
set cursorcolumn
"filetype on
"filetype plugin on

"enable powerline
set rtp+=/usr/lib/python3.7/site-packages/powerline/bindings/vim
set laststatus=2
set t_Co=256
"inoremap ( ()<LEFT>
"inoremap [ []<LEFT>
"inoremap { {}<LEFT>

"开启实时搜索功能
"set incsearch
"搜索时大小写不敏感
set ignorecase
set clipboard=unnamed
"关闭兼容模式
"set nocompatible
"vim自身命令行模式智能补全
"set wildmenu

" vim-one 设置
"Credit joshdick
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
  "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
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
" let g:airline_theme='one'

" NERDTree 设置
" 启动vim时自动打开NERDTree
" autocmd vimenter * NERDTree
" 自动退出
" autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" 设置Ctrl-n来开启或关闭NERDTree
map <C-n> :NERDTreeToggle<CR>
" 设置Ctrl-x来开启或关闭git diff高亮
map <C-x> :GitGutterLineHighlightsToggle<CR>
" 显示隐藏文件
let NERDTreeShowHidden=1
" 显示ignored
let g:NERDTreeShowIgnoredStatus = 1
" 显示行号
let NERDTreeShowLineNumbers=1
let NERDTreeAutoCenter=1
" git 信息显示
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

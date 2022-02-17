"        _
" __   _(_)_ __ ___  _ __ ___
" \ \ / / | '_ ` _ \| '__/ __|
"  \ V /| | | | | | | | | (__
"   \_/ |_|_| |_| |_|_|  \___|
"


"Pathogen enabled
"""""""""""""""""""""""""""""""""""""""
execute pathogen#infect()
call pathogen#helptags()

"Sourcing settings for ycm lsp servers
"""""""""""""""""""""""""""""""""""""""
source /home/glazov/.vim/bundle/ycm-lsp/vimrc.generated 


"Key mappings
"""""""""""""""""""""""""""""""""""""""
" Move between open buffers.
map <C-n> :bnext<CR>
map <C-p> :bprev<CR>

"Create and move between tabs
nnoremap <C-t> :tabe<CR>
nnoremap <C-l> :tabnext<CR>
nnoremap <C-h> :tabprevious<CR>

"Esc with pressing jj in insert mode
imap jj <Esc>

" You don't know what you're missing if you don't use this.
nmap <C-e> :e#<CR>

"Macroses for tmux
nmap cc :call TmuxPaneClear()<CR>
nmap rr :call TmuxPaneRepeat()<CR>
"======================================
" Use \c to add some space in a tmux pane.
function TmuxPaneClear()
  silent execute ':!tmux send-keys -t' g:tmux_server_pane 'C-j' 'C-j' 'C-j' 'C-j' 'C-j' 'C-j' 'C-j'
  redraw!
endfunction

" Use \r to repeat the last command in a tmux pane of my choosing.
function TmuxPaneRepeat()
  write
  silent execute ':!tmux send-keys -t' g:tmux_console_pane 'C-p' 'C-j'
  redraw!
endfunction
"======================================

" Why not use the space or return keys to toggle folds?
nnoremap <space> za
vnoremap <space> zf

" Make j & k linewise {{{2
" turn off linewise keys -- normally, the `j' and `k' keys move the cursor down
" one entire line. with line wrapping on, this can cause the cursor to actually
" skip a few lines on the screen because it's moving from line N to line N+1 in
" the file. I want this to act more visually -- I want `down' to mean the next
" line on the screen
map j gj
map k gk


"Vim options
"""""""""""""""""""""""""""""""""""""""
set nu						"Setting line numbers
syntax enable				"Enable syntax
filetype plugin indent on	"turn on nerdtree features
let g:jsx_ext_required = 0  "jsx syntax
set autoindent              " Carry over indenting from previous line
set directory-=.            " Don't store temp files in cwd
set encoding=utf8           " UTF-8 by default
set clipboard=unnamed		"Setting clipboard availability
set fileformats=unix,dos,mac  " Prefer Unix
set fillchars=vert:\ ,stl:\ ,stlnc:\ ,fold:-,diff:┄
                            " Unicode chars for diffs/folds, and rely on
                            " Colors for window borders
silent! set foldmethod=marker " Use braces by default
set formatoptions=tcqn1     " t - autowrap normal text
                            " c - autowrap comments
                            " q - gq formats comments
                            " n - autowrap lists
                            " 1 - break _before_ single-letter words
                            " 2 - use indenting from 2nd line of para
set history=200             " How many lines of history to save
set hlsearch                " Hilight searching
set ignorecase              " Case insensitive
set incsearch               " Search as you type
set infercase               " Completion recognizes capitalization
set laststatus=2            " Always show the status bar
set linebreak               " Break long lines by word, not char
silent! set mouse=nvc       " Use the mouse, but not in insert mode
set nobackup                " No backups left after done editing
set showmatch               " Hilight matching braces/parens/etc.
set smartcase               " Lets you search for ALL CAPS
set tabstop=2               " The One True Tab
set textwidth=100           " 100 is the new 80
set wildmenu                " Show possible completions on command line
set wildmode=list:longest,full " List all options and complete
set wildignore=*.class,*.o,*~,.git,node_modules  " Ignore certain files in tab-completion


"Commands and functions
"""""""""""""""""""""""""""""""""""""""
" http://stackoverflow.com/questions/1005/getting-root-permissions-on-a-file-inside-of-vi
cmap w!! w !sudo tee >/dev/null %

" Close all buffers except this one
command! BufCloseOthers %bd|e#


"Plugin settings
"""""""""""""""""""""""""""""""""""""""
" for any plugins that use this, make their keymappings use comma
let mapleader = ","
let maplocalleader = ","

"""NERDTree"""
"--------------------------------------
" Start NERDTree and leave the cursor in it.
"autocmd VimEnter * NERDTree

" Make Nerdtree show .files by default
let NERDTreeShowHidden=1

" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"--------------------------------------

"""FZF"""
"(fuzzy search)
"--------------------------------------
set rtp+=/usr/local/opt/fzf
set rtp+=~/.fzf
nmap ; :Buffers<CR>
nmap <Leader>r :Tags<CR>
nmap <Leader>t :Files<CR>
nmap <Leader>a :Ag<CR>
"--------------------------------------

"""Lightline"""
"--------------------------------------
let g:lightline = {
\ 'colorscheme': 'dracula',
\ 'active': {
\   'left': [['mode', 'paste'], ['filename', 'modified']],
\   'right': [['lineinfo'], ['percent'], ['readonly', 'linter_warnings', 'linter_errors', 'linter_ok']]
\ },
\ 'component_expand': {
\   'linter_warnings': 'LightlineLinterWarnings',
\   'linter_errors': 'LightlineLinterErrors',
\   'linter_ok': 'LightlineLinterOK'
\ },
\ 'component_type': {
\   'readonly': 'error',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error'
\ },
\ }

autocmd User ALELint call s:MaybeUpdateLightline()

"======================================
function! LightlineLinterWarnings() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ◆', all_non_errors)
endfunction

function! LightlineLinterErrors() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '' : printf('%d ✗', all_errors)
endfunction

function! LightlineLinterOK() abort
  let l:counts = ale#statusline#Count(bufnr(''))
  let l:all_errors = l:counts.error + l:counts.style_error
  let l:all_non_errors = l:counts.total - l:all_errors
  return l:counts.total == 0 ? '✓ ' : ''
endfunction

" Update and show lightline but only if it's visible (e.g., not in Goyo)
function! s:MaybeUpdateLightline()
  if exists('#lightline')
    call lightline#update()
  end
endfunction
"======================================
"--------------------------------------

"""ALE"""
"--------------------------------------
let g:ale_sign_warning = '▲'

let g:ale_sign_error = '✗'
highlight link ALEWarningSign String
highlight link ALEErrorSign Title
"--------------------------------------

"""Closetag"""
"--------------------------------------
" filenames like *.xml, *.html, *.xhtml, ...
" These are the file extensions where this plugin is enabled.
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'

" filenames like *.xml, *.xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'

" filetypes like xml, html, xhtml, ...
" These are the file types where this plugin is enabled.
let g:closetag_filetypes = 'html,xhtml,phtml'

" filetypes like xml, xhtml, ...
" This will make the list of non-closing tags self-closing in the specified files.
let g:closetag_xhtml_filetypes = 'xhtml,jsx'

" integer value [0|1]
" This will make the list of non-closing tags case-sensitive (e.g. `<Link>` will be closed while `<link>` won't.)
let g:closetag_emptyTags_caseSensitive = 1

" dict
" Disables auto-close if not in a "valid" region (based on filetype)
let g:closetag_regions = {
    \ 'typescript.tsx': 'jsxRegion,tsxRegion',
    \ 'javascript.jsx': 'jsxRegion',
    \ 'typescriptreact': 'jsxRegion,tsxRegion',
    \ 'javascriptreact': 'jsxRegion',
    \ }

" Shortcut for closing tags, default is '>'
let g:closetag_shortcut = '>'

" Add > at current position without closing the current tag, default is ''
let g:closetag_close_shortcut = '<leader>>'
"--------------------------------------


"Colorscheme settings
"""""""""""""""""""""""""""""""""""""""
colo dracula


" should be replaced by vim-plug but not all plugins are found yet just using
" Plug
call pathogen#infect()


call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
"Plug 'junegunn/seoul256.vim'
"Plug 'junegunn/vim-easy-align'
Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean carp dancer highlight-all-pragmas moose test-more try-tiny' }

Plug 'alfredodeza/pytest', { 'for': 'python' }
" disabled, incompatible with syntastic
"Plug 'nvie/vim-flake8', { 'for': 'python' }
Plug 'fisadev/vim-isort', { 'for': 'python' }
Plug 'tpope/vim-fugitive'
Plug 'moll/vim-bbye'
Plug 'airblade/vim-gitgutter'
" TODO bufferline in status line only confuses me with tabs. I use buffer
" mainly to work on these in a stack, don't want to switch back and forth for
" which I normally use tabs instead
"Plug 'bling/vim-bufferline'
Plug 'alfredodeza/coveragepy.vim', { 'for': 'python' }

Plug 'yko/mojo.vim'
Plug 'tpope/vim-unimpaired'
Plug 'lervag/file-line'
Plug 'vim-syntastic/syntastic'

" CAUTION conflicts with flake8, either enable flake8 or python mode
" TODO python mode seems to have some performance impact, maybe configure better
"Plug 'klen/python-mode', { 'for': 'python' }

" cool statusbar, it is only enabled in a single buffer window with
" 'set laststatus=2' (or with multiple windows)
Plug 'bling/vim-airline'
"Plug 'itchyny/lightline.vim'

" Group dependencies, vim-snippets depends on ultisnips
"Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
"Plug 'tpope/vim-fireplace', { 'for': 'clojure' }

" Using git URL
"Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" Using a non-master branch
"Plug 'rdnetto/YCM-Generator', { 'branch': 'stable' }

" Plugin options
"Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }

" Plugin outside ~/.vim/plugged with post-update hook
"Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug 'madox2/vim-ai'

" Unmanaged plugin (manually installed and updated)
"Plug '~/my-prototype-plugin'

" colorschemes
Plug 'kshenoy/vim-sol' " nearly no color within quotes, e.g. strings
Plug 'endel/vim-github-colorscheme'  " only dark
Plug 'dhruvasagar/vim-railscasts-theme'  " only dark
Plug 'altercation/vim-colors-solarized'  " only workable with dark
Plug 'reedes/vim-colors-pencil'  " highlight unreadable as well as selection if not on 256-colors

" Add plugins to &runtimepath
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" File

" Set the file format type to unix, so all of the ^M characters are visible
"set fileformats=unix

" Make sure the swap is synced every time we write to it - uses sync() instead
" of the default fsync() - any non empty value enables this feature
"set swapsync=sync

" The number of characters typed before doing an update of the swap file
set updatecount=20

"Nunber of milliseconds before doing an update
set updatetime=10000

" Read/write a .viminfo file, remember filemarks for 500 files and store 2000
" lines of registers
"set viminfo='500,\"2000

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
"set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

set encoding=utf-8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Formatting

" Round indent to a multiple of 'shiftwidth'
set shiftround

" Disable automatically formating text as it is typed (see next option)
"set formatoptions-=t

" Automatically format comments at 78 characters
set textwidth=78

" break the line after 78 characters at word-boundaries
set wrapmargin=78

" Smart indent (overridden by cindent if it is on)
set smartindent

 " set indentation to 4 space widths and put spaces instead of tabs
set tabstop=4
set shiftwidth=4
set expandtab

" show EOL whitespace
let c_space_errors=1
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

" Show overlength lines
" Note: Use the lower lines instead of this one
"highlight OverLength ctermbg=darkred ctermfg=white guibg=#592929
"match OverLength /\%81v.\+/
"
if has("colorcolumn")
  set colorcolumn=80
else
  au BufWinEnter *.[ch]* let w:m2=matchadd('ErrorMsg', '\%>160v.\+', -1)
  au BufWinEnter *.py let w:m2=matchadd('ErrorMsg', '\%>160v.\+', -1)
endif

" Enabled file type detection
" Use the default filetype settings. If you also want to load indent files
" to automatically do language-dependent indenting add 'indent' as well.
filetype plugin indent on

if has("autocmd")
else
  set autoindent    " always set autoindenting on
endif " has ("autocmd")

"
" Specific file types
"

augroup filetype
   " CMake files
   autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in runtime! indent/cmake.vim
   autocmd BufRead,BufNewFile *.cmake,CMakeLists.txt,*.cmake.in set filetype=cmake tabstop=4 shiftwidth=4 expandtab
   autocmd BufRead,BufNewFile *.ctest,*.ctest.in set filetype=cmake
   " Text Files
   "autocmd BufNewFile,BufRead *.txt set filetype=human

   autocmd BufRead,BufNewFile *.t set filetype=perl
augroup END

" In human-language files, automatically format everything at 72 chars:
"autocmd FileType human,text set formatoptions+=t textwidth=72

" Behave like a wordprocessor for text files
" Visually word wrap (on entire words, not characters), but only enter line
" breaks when the enter key is explicitely hit
autocmd FileType human,text,tex set formatoptions=l lbr wrap

" For C-like programming, have automatic indentation:
" TODO is this good?
"autocmd FileType c,cpp,slang set cindent

" For actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" For Perl programming, have things in braces indenting themselves and use spaces
autocmd FileType perl set smartindent tabstop=4 shiftwidth=4 expandtab

" For CSS, also have things in braces indented:
autocmd FileType css set smartindent

" For HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" In makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
autocmd FileType make set noexpandtab shiftwidth=8

autocmd FileType python set wrapmargin=160 textwidth=160
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User Interface

" Have the mouse enabled all the time
"set mouse=a

" Disable line wraps
"set nowrap

" Enable line numbres
"set number

" When displaying line numbers, don't use an annoyingly wide number column. This
" doesn't enable line numbers -- :set number will do that. The value given is a
" minimum width to use for the number column, not a fixed size.
if v:version >= 700
  set numberwidth=3
endif

" Always keep 2 lines on the top and bottom of the screen
set scrolloff=2

" Turn off visual bell
"set novisualbell

" Show a title in the console's title bar (the status line)
set title

" Smoother redrawing of the screen, uses more characters to draw (don't use on
" tty line)
set ttyfast

" Short messages
" set shortmess=atI

" Show matching brace briefely when closing a brace
set showmatch

" Set the fold column, so we can use the mouse to open and close folds
" set foldcolumn=2

" Set the maximum number of tabs (default: 10)
set tabpagemax=15

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search and replace

" Make pattern matching smart, match non-case-sensitive if the pattern has
" upper case characters, used for the following commands: / ? n N :g :s
" not used for: * # gd tag search, after * and # can use a / to use smartcase
" and recall from history
set ignorecase
set smartcase

" Do incremental searching, so we see the 'best match so far'
set incsearch

" Assume the /g flag on :s substitutions to replace all matches in a line:
" set gdefault

"To highlight all search matches in a file, set the following option:
set hlsearch

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Spelling

" Try to avoid misspelling words in the first place -- have the insert mode
" <Ctrl>+N/<Ctrl>+P keys perform completion on partially-typed words by
" checking the Linux word list and the personal `Ispell' dictionary; sort out
" case sensibly (so that words at starts of sentences can still be completed
" with words that are in the dictionary all in lower case):
set dictionary+=~/.ispell_en
set dictionary+=~/.ispell_en.US
set complete=.,w,k
set infercase

" Turn on spellcheck for text files
"autocmd FileType human,text set spell spelllang=en_us
"autocmd FileType tex set spell spelllang=en_us


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Moving Around

" Have the h and l cursor keys wrap between lines (like <Space> and <BkSpc> do
" by default), and ~ covert case over line breaks; also have the cursor keys
" wrap in insert mode:
set whichwrap=h,l,~,[,]

" Page down with <Space> (like in `Lynx', `Mutt', `Pine', `Netscape Navigator',
" `SLRN', `Less', and `More'); page up with - (like in `Lynx', `Mutt', `Pine'),
" or <BkSpc> (like in `Netscape Navigator'):
"noremap <Space> <PageDown>
"noremap <BS> <PageUp>
"noremap - <PageUp>
" [<Space> by default is like l, <BkSpc> like h, and - like k.]

" Scroll the window (but leaving the cursor in the same place) by a couple of
" lines up/down with <Ins>/<Del> (like in `Lynx'):
noremap <Ins> 2<C-Y>
noremap <Del> 2<C-E>
" [<Ins> by default is like i, and <Del> like x.]

" Use <F6> to cycle through split windows (and <Shift>+<F6> to cycle backwards,
" where possible):
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W

" Use <Ctrl>+N/<Ctrl>+P to cycle through files:
nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>
" [<Ctrl>+N by default is like j, and <Ctrl>+P like k.]

" Have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>

" Have <F1> prompt for a help topic, rather than displaying the introduction
" page, and have it do this from any mode:
nnoremap <F1> :help<Space>
vmap <F1> <C-C><F1>
omap <F1> <C-C><F1>
map! <F1> <C-C><F1>

" Have f9 and f10 be previous / next tab
nnoremap <F9> :tabp<CR>
nnoremap <F10> :tabn<CR>
nnoremap <C-\> :tabnew<CR>
inoremap <F9> <Esc>:tabp<CR>
inoremap <F10> <Esc>:tabn<CR>
inoremap <C-\> <Esc>:tabnew<CR>
vnoremap <F9> <Esc>:tabp<CR>
vnoremap <F10> <Esc>:tabn<CR>
vnoremap <C-\> <Esc>:tabnew<CR>

" Always display the tab bar
"set showtabline=2

" FuzzyFinder
"map <C-p> :FuzzyFinderFile<CR>
" FuzzyFinder open with directory of current directory (not directory of
" buffer)
"nnoremap <C-p> :FuzzyFinderFile <C-r>=fnamemodify(getcwd(), ':p')<CR><CR>
" FuzzyFinder open with directory of the current buffer
nnoremap <C-p> :FuzzyFinderFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
inoremap <C-p> <Esc>:FuzzyFinderFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>
vnoremap <C-p> <Esc>:FuzzyFinderFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>

" TagList
nnoremap <silent> <F8> :TlistToggle<CR>
inoremap <silent> <F8> <Esc>:TlistToggle<CR>
vnoremap <silent> <F8> <Esc>:TlistToggle<CR>
" Automatically open
"let Tlist_Auto_Open=1
" Automatically close the taglist window when selecting a file or tag
let Tlist_Close_On_Select=1
" Close vim when only the taglist window remains
let Tlist_Exit_OnlyWindow=1
" Only require one click to select
let Tlist_Use_SingleClick=1
" Always process files, even if the taglist window is not open
let Tlist_Process_File_Always=1
" Sorting order of tags (options are order and name)
let Tlist_Sort_Type='name'
" Show the current tag in the status line
"set statusline=%<%f%=%([%{Tlist_Get_Tagname_By_Line()}]%)
"set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)
" Show the current tag in the window title
"set title titlestring=%<%f\ %([%{Tlist_Get_Tagname_By_Line()}]%)
" Split to the right of the window, instead of the left
let Tlist_Use_Right_Window=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Formatting

" Have Q reformat the current paragraph (or selected text if there is any)
" (default keybinding switches to 'ex' mode):
nnoremap Q gqap
vnoremap Q gq

" Have the usual indentation keystrokes still work in visual mode:
vnoremap <C-T> >
vnoremap <C-D> <LT>
vmap <Tab> <C-T>
vmap <S-Tab> <C-D>

" Have Y behave analogously to D and C rather than to dd and cc (which is
" already done by yy):
noremap Y y$


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Toggles
"
" Keystrokes to toggle options are defined here.  They are all set to normal
" mode keystrokes beginning \t but some function keys (which won't work in all
" terminals) are also mapped.

" Have \tp ("toggle paste") toggle paste on/off and report the change, and
" where possible also have <F4> do this both in normal and insert mode:
nnoremap \tp :set invpaste paste?<CR>
nmap <F4> \tp
imap <F4> <C-O>\tp
set pastetoggle=<F4>

" Have \tl ("toggle list") toggle list on/off and report the change:
nnoremap \tl :set invlist list?<CR>
nmap <F2> \tl

" Have \th ("toggle highlight") toggle highlighting of search matches, and
" report the change:
nnoremap \th :set invhls hls?<CR>

" Have \tf ("toggle format") toggle the automatic insertion of line breaks
" during typing and report the change:
nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
  \ endif <Bar> set fo?<CR>
"nmap <F7> \tf
"imap <F7> <C-O>\tf

" Have \tw ("toggle wrap") toggle wrapping of text
nnoremap \tw :set invwrap wrap?<CR>
nmap <F7> \tw

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Insert Mode

" Allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

" Have <Tab> (and <Shift>+<Tab> where it works) change the level of
" indentation:
"inoremap <Tab> <C-T>
"inoremap <S-Tab> <C-D>
" [<Ctrl>+V <Tab> still inserts an actual tab character.]


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes - Misc

nmap <silent> <C-D> :NERDTreeToggle<CR>
nnoremap <silent> <C-L> :noh<CR><C-L>
nmap <silent> ,/ :noh<CR>

" Execute make on Ctrl-B
nnoremap <C-B> :make<CR>
" save current and make
"nnoremap <C-M> :w<CR>:make<CR>

nnoremap \wm :w<CR>:!./%<CR>
nmap <C-m> \wm
" visual mode also catches the CR keypress, at least from neo keyboard, which
" it shouldn't
"inoremap <C-m> <ESC>\wm

"Fast quit and save from normal and insert mode
:map <C-X> <ESC>:x<CR>
:imap <C-X> <ESC>:x<CR>

" Press Space to turn off highlighting and clear any message already
" displayed.
"noremap <silent> <Space> :silent noh<Bar>echo<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc

" Get a dialog when a command fails
" set confirm

" For debugging
" set verbose=9

"
" Highlighting
"

" enables syntax highlighting
syntax on

" highlight the LOG macro with its definitions like preprocessor directives
syntax keyword cLog LOG LOG_DEBUG LOG_INFO LOG_NOTICE LOG_WARNING LOG_WARN LOG_ERR LOG_CRIT
highlight link cLog Preproc

" for txt2tags syntax highlighting
"au BufNewFile,BufRead *.txt set ft=txt2tags

augroup taskjuggler
       " taskjuggler files highlighting
       au! BufNewFile,BufRead *.tj{p,i} set ft=tjp
augroup END


" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif

augroup END

" let g:lightline = {
"       \ 'colorscheme': 'landscape',
"       \ 'active': {
"       \   'left': [ [ 'mode', 'paste' ],
"       \             [ 'fugitive', 'filename' ] ]
"       \ },
"       \ 'component_function': {
"       \   'fugitive': 'LightLineFugitive',
"       \   'readonly': 'LightLineReadonly',
"       \   'modified': 'LightLineModified',
"       \   'filename': 'LightLineFilename'
"       \ },
"       \ 'separator': { 'left': '', 'right': '' },
"       \ 'subseparator': { 'left': '', 'right': '' }
"       \ }
" 
" function! LightLineModified()
"   if &filetype == "help"
"     return ""
"   elseif &modified
"     return "+"
"   elseif &modifiable
"     return ""
"   else
"     return ""
"   endif
" endfunction
" 
" function! LightLineReadonly()
"   if &filetype == "help"
"     return ""
"   elseif &readonly
"     return ""
"   else
"     return ""
"   endif
" endfunction
" 
" function! LightLineFugitive()
"   if exists("*fugitive#head")
"     let _ = fugitive#head()
"     return strlen(_) ? ' '._ : ''
"   endif
"   return ''
" endfunction
" 
" function! LightLineFilename()
"   return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
"        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
"        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
" endfunction

let g:solarized_termcolors=256
let g:solarized_contrast="high"
let g:pencil_higher_contrast_ui = 1

"colorscheme default
"colorscheme torte
"colorscheme peaksea
"let g:zenburn_high_Contrast=1
"colorscheme zenburn
"colorscheme desert
" pencil looks nice but it does not work on non-256 color terminals, just forget about colorschemes for now, default actually works ok with light bg if we call
" default after that so set both
colorscheme pencil
colorscheme default
"colorscheme sol
"colorscheme railscasts
"colorscheme solarized
"

" with pencil
hi Search ctermbg=LightGrey


" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
"set background=dark

set background=light
" In "vimdiff"
if &diff
    " 'evening' seems to work ok on dark screen maybe? could not read it
    " properly nowadays, also using desert here, too, for now
    "colorscheme evening
    colorscheme sol
endif

" vimdiff color scheme
" http://hackerslab.eu/blog/2011/11/vimdiff-color-scheme/
"highlight DiffChange cterm=none ctermfg=black ctermbg=LightGreen gui=none guifg=bg guibg=LightGreen
"highlight DiffText cterm=none ctermfg=black ctermbg=Red gui=none guifg=bg guibg=Red


if filereadable("~/.vim/plugin/cscope_maps.vim")
	source ~/.vim/plugin/cscope_maps.vim
endif

"if filereadable("/home/los-archiv/projekte_los/Betriebssysteme/Linux/vanilla/tags")
"    set tags=./tags,./TAGS,tags,TAGS,/home/los-archiv/projekte_los/Betriebssysteme/Linux/vanilla/tags
"endif

" add any database in current directory
if filereadable("cscope.out")
    cs add cscope.out
" else add database pointed to by environment
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif

" vimgdb settings
" source ~/.vim/macros/gdb_mappings.vim
set previewheight=12		" set gdb window initial height
"set asm=0				" don't show any assembly stuff
"set gdbprg=gdb_invocation		" set GDB invocation string (default 'gdb')
"set gdbprg=sparc_auto_unitas		" set GDB invocation string (default 'gdb')

 " disable annoying audible bell
set visualbell t_vb=

" for ctag-txt2tags to work in VIM
let tlist_txt2tags_settings='txt2tags;d:Titles'

" Supertab and Omnicomplete but set like in eclipse:
" (This does not work in console vim)
"let g:SuperTabMappingForward = '<c-space>'
"let g:SuperTabMappingBackward = '<s-c-space>'

" (This also does not work)
"if has("gui")
"    " C-Space seems to work under gVim on both Linux and win32
"    inoremap <C-Space> <C-n>
"else " no gui
"  if has("unix")
"    inoremap <Nul> <C-n>
"  else
"  " I have no idea of the name of Ctrl-Space elsewhere
"  endif
"endif

" turn on omnicompletion, this option is usually set by a filetype plugin
"set ofu=syntaxcomplete#Complete

"let g:SuperTabDefaultCompletionType = "context"

" When enabled and 'longest' is in your |completeopt| setting, supertab will
" provide an enhanced longest match support where typing one or more letters and
" hitting tab again while in a completion mode will complete the longest common
" match using the new text in the buffer.
let g:SuperTabLongestEnhanced = 1


" Tag autocomplete
" configure tags - add additional tags here or comment out not-used ones
"set tags+=~/.vim/tags/cpp
" build tags of your own project with CTRL+F12
"map <C-l> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
" OmniCppComplete
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_MayCompleteDot = 1
let OmniCpp_MayCompleteArrow = 1
let OmniCpp_MayCompleteScope = 1
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]
" automatically open and close the popup menu / preview window
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" change file name autocomplete behave more like BASH
set wildmode=longest,list

" Connect path for gdb4vim
let g:gdb_dbus_server_path = '~/.vim/dbus_gdb/gdb_dbus_server.py'

" copy current line number into x clipboard
nmap ,ln :call setreg('*', line('.'))<CR>

" http://nvie.com/posts/how-i-boosted-my-vim/
" One particularly useful setting is hidden. Its name isn’t too descriptive, though. It hides buffers instead of closing them. This means that you can have unwritten changes to a file and open a new file using :e, without being forced to write or undo your changes first. Also, undo buffers and marks are preserved while the buffer is open. This is an absolute must-have.
set hidden
" Also, I like Vim to have a large undo buffer, a large history of commands, ignore some file extensions when completing names by pressing Tab, and be silent about invalid cursor moves and other errors.
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo

"Vim can highlight whitespaces for you in a convenient way:
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

" In some files, like HTML and XML files, tabs are fine and showing them is really annoying, you can disable them easily using an autocmd declaration:
"autocmd filetype html,xml set listchars-=tab:>.

" check perl code with :make
autocmd FileType perl set makeprg=perl\ -c\ %\ $*
autocmd FileType perl set errorformat=%f:%l:%m
autocmd FileType perl set autowrite

" my perl includes pod
let perl_include_pod = 1
" syntax color complex things like @{${"foo"}}
let perl_extended_vars = 1

nmap _c :!perl -wc %<CR>
nmap _t :!prove -wlv t/*.t<CR>
"nmap ,p :!perltidy -q l=0 -fbl -nsfs -baao -bbao -pt=2 -bt=2 -sbt=2 -sct %<CR>
nnoremap <silent> _p :%!perltidy -q l=0 -fbl -nsfs -baao -bbao -pt=2 -bt=2 -sbt=2 -sct<CR>
vnoremap <silent> _p :!perltidy -q l=0 -fbl -nsfs -baao -bbao -pt=2 -bt=2 -sbt=2 -sct<CR>


" Pytest
nmap <silent><Leader>f <Esc>:Pytest file<CR>
nmap <silent><Leader>c <Esc>:Pytest class<CR>
nmap <silent><Leader>m <Esc>:Pytest method<CR>

" disabled, incompatible with syntastic
""" " flake8
""" autocmd FileType python map <buffer> <F3> :call Flake8()<CR>
""" " check every time you write a Python file
""" " TODO pymode seems to also check, let's not call it twice or multiple times on python files
""" autocmd BufWritePost *.py call Flake8()

" https://github.com/fisadev/vim-isort
" vim is using internal python not able to find external modules, e.g. from local pip cache or virtualenv
" modules, also see https://github.com/fisadev/fisa-vim-config/issues/65#issuecomment-34627224
" Got it to work on linux-28d6 by installing "python-pip" (for python2) and then "sudo pip install isort"
let g:vim_isort_map = '<C-i>'

set laststatus=2 " Always display the statusline in all windows
"set showtabline=2 " Always display the tabline, even if there is only one tab
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)

let g:airline_powerline_fonts = 1

" see https://github.com/moll/vim-bbye
nnoremap <Leader>q :Bdelete<CR>

" To customise your sign column's background color, first tell vim-gitgutter
" to leave it alone
let g:gitgutter_override_sign_column_highlight = 0
highlight SignColumn ctermbg=lightgrey
"let g:gitgutter_sign_column_always = 1

source ~/.vimrc.gittoken
" When this is set to 1, github-issues will use upstream issues (if repo is fork). This will require extra requests for the Github API, however.
let g:github_upstream_issues = 1
"let g:gissues_lazy_load = 0
let g:gissues_async_omni = 1
let g:pymode_folding = 1

" https://github.com/yko/mojo.vim
let mojo_highlight_data = 1

" http://vim.wikia.com/wiki/Map_Ctrl-S_to_save_current_or_new_files
" the ref suggests another command which only saves if file changed but
" sometimes I want another command to pickup the modification of the time w/o
" any actual changes, e.g. to start a test, like 'touch' so just map C-S to :w
nnoremap <silent> <C-S> :w<CR>
inoremap <C-S> <C-O>:w<CR>
vmap <C-S> <esc>:w<CR>gv

" prevent inotifywait to trigger on CLOSE_WRITE multiple times or actually too
" early when the target file is not there yet but only the temporary one
" see
" https://stackoverflow.com/questions/10300835/too-many-inotify-events-while-editing-in-vim
set nowritebackup

set nu

let g:syntastic_yaml_checkers = ['yamllint']

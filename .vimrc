set nocompatible
set nu
" edit this file...
execute 'nnoremap \ev :new ~/.vimrc<CR>'

" * pathogen
call pathogen#infect()

" * Terminal Settings

" `XTerm', `RXVT', `Gnome Terminal', and `Konsole' all claim to be "xterm";
" `KVT' claims to be "xterm-color":
if &term =~ 'xterm'
" `Gnome Terminal' fortunately sets $COLORTERM; it needs <BkSpc> and <Del>
  " fixing, and it has a bug which causes spurious "c"s to appear, which can be
  " fixed by unsetting t_RV:
  if $COLORTERM == 'gnome-terminal'
    execute 'set t_kb=' . nr2char(8)
    " [Char 8 is <Ctrl>+H.]
    fixdel
    set t_RV=

  " `XTerm', `Konsole', and `KVT' all also need <BkSpc> and <Del> fixing;
  " there's no easy way of distinguishing these terminals from other things
  " that claim to be "xterm", but `RXVT' sets $COLORTERM to "rxvt" and these
  " don't:
  elseif $COLORTERM == ''
    execute 'set t_kb=' . nr2char(8)
    fixdel

  " The above won't work if an `XTerm' or `KVT' is started from within a `Gnome
  " Terminal' or an `RXVT': the $COLORTERM setting will propagate; it's always
  " OK with `Konsole' which explicitly sets $COLORTERM to "".

  endif
endif

""""""""""""""""""""""""""""""""""""""'
" User Interface
" have syntax highlighting in terminals which can display colors:
if has('syntax') && (&t_Co > 2)
  set t_Co=256
  syntax on
endif

" have fifty lines of command-line (etc) history:
set history=50
" remember all of these between sessions, but only 10 search terms; also
" remember info for 10 files, but never any on removable disks, don't remember
" marks in files, don't rehighlight old search patterns, and only save up to
" 100 lines of registers; including @10 in there should restrict input buffer
" but it causes an error for me:
set viminfo=/10,'10,r/mnt/zip,r/mnt/floppy,f0,h,\"100

" have command-line completion <Tab> (for filenames, help topics, option names)
" first list the available options and complete the longest common part, then
" have further <Tab>s cycle through the possibilities:
set wildmode=list:longest,full

" don't select the first completion item, but rather inserts the longest
" common text of all matches; show menu even if there's only one match.
set completeopt=longest,menuone

" use "[RO]" for "[readonly]" to save space in the message line:
set shortmess+=ratI

" display the current mode and partially-typed commands in the status line:
set showmode
set showcmd

" when using list, keep tabs at their full width and display `arrows':
execute 'set listchars+=tab:' . nr2char(187) . nr2char(183)
" (Character 187 is a right double-chevron, and 183 a mid-dot.)

" have the mouse enabled all the time:
set mouse=a

" don't have files trying to override this .vimrc:
set nomodeline

""""""""""""""""""""""""""""
" abbreviations, mappings of various sorts
""""""""""""""""""""""""""""
" commentify in a shellscript
noremap \xc 0i#<Esc>

" type blah,,, to get <blah></blah> (with cursor where you'd expect)
imap ,,, <esc>bdwa<<esc>pa><cr></<esc>pa><esc>kA

inoreab xdate <C-R>=strftime("%Y%m%d")<CR>

noremap \xs :r ~/.xsig<CR>
inoreab xfunc /*******************************************************<Esc>o<CR>*******************************************************/<Esc>2kI

inoremap \xl $logger->log('', Zend::Log(INFO));<esc>B3hi

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" enclosing things in backquotes (rst specific, mostly)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""

" eB avoids backing up a line if we are in first column
" word in single `backquotes`
map \bw eBi`<Esc>ea`<Esc> 

" word in double ``backquotes``
map \bW eBi``<Esc>ea``<Esc> 

" ``line in single backquotes``
map \bb I`<Esc>A`<Esc>

" ``line in double backquotes``
map \bB I``<Esc>A``<Esc>

" line into named (h)yperlink
"LINE becomes .. _`LINE`: 
map \bh A`:<Esc>I..<Space>_`<Esc>

" enclose (v)isually selected area in backquotes
"+ have to turn it into blockwise mode, to use the v_A v_I commands
"+ if we were ALREADY in blockwise visual mode, it wont work
" does not work from linewise visual mode, only plain old visual mode
"vnoremap \bv <C-v>I`<Esc>gvllA`<Esc>f`;
" better is:
vmap \bv  "zdi`<C-r>z`<Esc>

"after (m)age (l)og
map \ml iMage::Log('',6,'lhutil.log');<Esc>F(la 
" after (l)og (e)xception
"map \le iMage::Log(__FILE__ . ' [' . __LINE__ . '] ' . "\n" . __METHOD__ . "\n" . 'Exception was: ' . $e->getMessage();<Esc>
map \le iMage::Log('' . "\n" . 'Exception was: ' . $e->getMessage() ,7,'lhutil.log');<Esc>0f(la

"""""""""""""""""""""""""""""""""""""""""""""'
" text formatting
"""""""""""""""""""""""""""""""""""""""""""""'
set nowrap

" use indents of 4 spaces, and have them copied down lines:
set shiftwidth=4
set shiftround
set expandtab tabstop=4
set autoindent

" enable filetype detection:
filetype plugin indent on

""""""""filetype specific options """"""""""""""""""""""""""""
" in human-language files, automatically format everything at 72 chars:
autocmd FileType human,mail,rst,viki set formatoptions+=t textwidth=72

" things in braces indent themselves in these filetypes
autocmd FileType perl,css set smartindent

" for HTML and php, generally format text, but if a long line has been created leave it
" alone when editing: Do the same for viki files
autocmd FileType html,php,viki set formatoptions+=cr

" smaller indents in these filetypes
autocmd FileType html,css,php,js set expandtab tabstop=2

" * Search & Replace

" make searches case-insensitive, unless they contain upper-case letters:
set ignorecase
set smartcase

" best-match so far
set incsearch

" scroll the window (but leaving the cursor in the same place) by a couple of
" lines up/down with <Ins>/<Del> (like in `Lynx'):
nnoremap <Ins> 2<C-Y>
nnoremap <Del> 2<C-E>

" use <F6> to cycle through split windows and <Shift>+<F6> to cycle backwards,
nnoremap <F6> <C-W>w
nnoremap <S-F6> <C-W>W

" use <Ctrl>+N/<Ctrl>+P to cycle through files:
nnoremap <C-N> :next<CR>
nnoremap <C-P> :prev<CR>

" have % bounce between angled brackets, as well as t'other kinds:
set matchpairs+=<:>

" * Keystrokes -- Formatting

" have Q reformat the current paragraph (or selected text if there is any):
nnoremap Q gqap
vnoremap Q gq

" have Y behave like D or C
noremap Y y$

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Keystrokes -- Toggles
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" \tp toggle paste and report the change (normal and insert)
nnoremap \tp :set invpaste paste?<CR>

" \tf toggle the automatic insertion of line breaks and report the change
nnoremap \tf :if &fo =~ 't' <Bar> set fo-=t <Bar> else <Bar> set fo+=t <Bar>
\ endif <Bar> set fo?<CR>

" \tl toggle list and report the change: 
nnoremap \tl :set invlist list?<CR>

" \th toggle highlighting of search matches
nnoremap \th :set invhls hls?<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" * Keystrokes -- Insert Mode

" allow <BkSpc> to delete line breaks, beyond the start of the current
" insertion, and over indentations:
set backspace=eol,start,indent

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" * Navigation 
" tabs like Firefox
:imap <C-t> <Esc>:tabnew<CR>
:map <C-t> :tabnew<CR>

" let Ctrl-[hjkl] move between buffers
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" toggle NERDTree
nnoremap \tn <Esc>:NERDTreeToggle<CR>
inoremap \tn <Esc>:NERDTreeToggle<CR>

" exec command this line
fu! s:ExecuteCommandLine()
    let l:Command = getline(".")
    execute "!" . l:Command
endfu

nnoremap \el :call <SID>ExecuteCommandLine()

" print selected as text in command-mode
vnoremap \pl "zy:<C-r>"

" this hilite is for xdebug trace files
" a syntax file is included with xdebug in contrib/
augroup filetypedetect
    au BufNewFile,BufRead *.xt setf xt
augroup END

" strip trailing whitespace, but only in php files and xml files and js files 
" and css
"autocmd BufWritePre *.php :set expandtab<CR>:retab<CR>:%s/\s\+$//e<CR>
"autocmd BufWritePre *.xml :set expandtab<CR>:retab<CR>:%s/\s\+$//e<CR>
"autocmd BufWritePre *.js :set expandtab<CR>:retab<CR>:%s/\s\+$//e<CR>
"autocmd BufWritePre *.css :set expandtab<CR>:retab<CR>:%s/\s\+$//e<CR>
"autocmd BufWritePre *.phtml :set expandtab<CR>:retab<CR>:%s/\s\+$//e<CR>

" force writing to a file using the sudo tee trick
cmap w!! %!sudo tee > /dev/null %

" php settings

" in php indent, case/switch are set at same level
" we want case to be indented one level more than switch
:let g:PHP_vintage_case_default_indent = 1


" draw a php docblock above where we are
nnoremap \db <Esc>:set paste<CR>:exe PhpDoc()<CR>:set nopaste<CR><C-o>2ki
inoremap \db <Esc>:set paste<CR>:exe PhpDoc()<CR>:set nopaste<CR><C-o>2ki

" run file with PHP CLI (CTRL-M)
autocmd FileType php noremap <C-M> :w!<CR>:!/usr/bin/php-5.3 %<CR>

" PHP parser check (CTRL-L)
"autocmd FileType php noremap <C-L> :!/usr/bin/php-5.3 -l %<CR>


" Evervim
" * evervim {{{
nnoremap <silent> ,el :<C-u>EvervimNotebookList<CR>
nnoremap <silent> ,et :<C-u>EvervimListTags<CR>
nnoremap <silent> ,en :<C-u>EvervimCreateNote<CR>
nnoremap <silent> ,eb :<C-u>EvervimOpenBrowser<CR>
nnoremap <silent> ,ec :<C-u>EvervimOpenClient<CR>
nnoremap ,es :<C-u>EvervimSearchByQuery<SPACE>
" " ------------------------ }}}

syntax on
set background=light
"let g:solarized_termcolors=256
"let g:solarized_termtrans=1
colorscheme solarized

"map ,pf <Esc>:EnableFastPHPFolds<Cr>
map ,pf <Esc>:EnablePHPFolds<CR>
map ,pd <Esc>:DisablePHPFolds<CR> 

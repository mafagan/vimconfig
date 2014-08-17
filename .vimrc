set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
"behave mswin
"set the window's initial size and position
winpos 0 0
"set lines=30 columns=80
" 设置当文件被改动时自动载入
set autoread

"set diffexpr=MyDiff()
set autochdir
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction
"4 Blank for tab
set ts=4  
set expandtab

set wildmenu
set foldmethod=manual
set helplang=cn
set cin
set sw=4
set sta
set nobackup
set backspace=2
syntax enable
set nocompatible
set number
filetype on
set history=1000
syntax on
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set showmatch
set ruler

se t_Co=256
let g:solarized_termcolors=256
set background=dark
colorscheme solarized

set incsearch
set fenc=gbk
"locate the STL tags file
"set tags+= c:\tags
"set guifont=Bitstream_Vera_Sans_Mono:h10:cANSI
set foldmethod=marker
map <F3> :silent! Tlist<CR> "按下F3就可以呼出了

"create new tab
map <F2> :tabnew<CR>
map <F5> :shell<CR>

let Tlist_Ctags_Cmd='ctags' "因为我们放在环境变量里，所以可以直接执行
let Tlist_Use_Right_Window=1 "让窗口显示在右边，0的话就是显示在左边
let Tlist_Show_One_File=0 "让taglist可以同时展示多个文件的函数列表，如果想只有1个，设置为1
let Tlist_File_Fold_Auto_Close=1 "非当前文件，函数列表折叠隐藏
let Tlist_Exit_OnlyWindow=1 "当taglist是最后一个分割窗口时，自动推出vim
let Tlist_Process_File_Always=0 "是否一直处理tags.1:处理;0:不处理。不是一直实时更新tags，因为没有必要
let Tlist_Inc_Winwidth=0
set completeopt=menu

"判断windows或linux"
if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:iswindows=1
else
    let g:iswindows=0
endif


if(has("win32") || has("win95") || has("win64") || has("win16"))
    let g:vimrc_iswindows=1
else
    let g:vimrc_iswindows=0
endif
autocmd BufEnter * lcd %:p:h

set completeopt=menu

"对NERD_commenter的设置
let NERDShutUp=1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
"set tags+=c:\stltags

"自动补全的背景色
highlight Pmenu    guibg=darkgrey  guifg=black 
highlight PmenuSel guibg=black     guifg=white

"设置字体
"set guifont=Arial_monospaced_for_SAP:h12:cANSI
"set guifont=consolas:h13:cANSI
"set guifont=Monaco:h13:cANSI
set guifont=Monaco
"设置窗口大小
"set lines=45 columns=135

"括号自动补全
inoremap ( <c-r>=OpenPair('(')<CR>
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap { <c-r>=OpenPair('{')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap [ <c-r>=OpenPair('[')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>
" just for xml document, but need not for now.
"inoremap < <c-r>=OpenPair('<')<CR>
"inoremap > <c-r>=ClosePair('>')<CR>
function! OpenPair(char)
    let PAIRs = {
                \ '{' : '}',
                \ '[' : ']',
                \ '(' : ')',
                \ '<' : '>'
                \}
    if line('$')>2000
        let line = getline('.')
 
        let txt = strpart(line, col('.')-1)
    else
        let lines = getline(1,line('$'))
        let line=""
        for str in lines
            let line = line . str . "\n"
        endfor
 
        let blines = getline(line('.')-1, line("$"))
        let txt = strpart(getline("."), col('.')-1)
        for str in blines
            let txt = txt . str . "\n"
        endfor
    endif
    let oL = len(split(line, a:char, 1))-1
    let cL = len(split(line, PAIRs[a:char], 1))-1
 
    let ol = len(split(txt, a:char, 1))-1
    let cl = len(split(txt, PAIRs[a:char], 1))-1
 
    if oL>=cL || (oL<cL && ol>=cl)
        return a:char . PAIRs[a:char] . "\<Left>"
    else
        return a:char
    endif
endfunction
function! ClosePair(char)
    if getline('.')[col('.')-1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endf
 
inoremap ' <c-r>=CompleteQuote("'")<CR>
inoremap " <c-r>=CompleteQuote('"')<CR>
function! CompleteQuote(quote)
    let ql = len(split(getline('.'), a:quote, 1))-1
    let slen = len(split(strpart(getline("."), 0, col(".")-1), a:quote, 1))-1
    let elen = len(split(strpart(getline("."), col(".")-1), a:quote, 1))-1
    let isBefreQuote = getline('.')[col('.') - 1] == a:quote
 
    if '"'==a:quote && "vim"==&ft && 0==match(strpart(getline('.'), 0, col('.')-1), "^[\t ]*$")
        " for vim comment.
        return a:quote
    elseif "'"==a:quote && 0==match(getline('.')[col('.')-2], "[a-zA-Z0-9]")
        " for Name's Blog.
        return a:quote
    elseif (ql%2)==1
        " a:quote length is odd.
        return a:quote
    elseif ((slen%2)==1 && (elen%2)==1 && !isBefreQuote) || ((slen%2)==0 && (elen%2)==0)
        return a:quote . a:quote . "\<Left>"
    elseif isBefreQuote
        return "\<Right>"
    else
        return a:quote . a:quote . "\<Left>"
    endif
endfunction

"设置编码格式
set fencs=utf-8,GB18030,ucs-bom,default,latin1

"字符统计函数
if !exists("*CalCharCount")
	function CalCharCount()
		exe '%s/\S/&/gn'
	endfunction
endif
"映射命令模式下ctrl+m调用字符统计
nnoremap <C-m> :call CalCharCount()<cr>
"设置标签页
set tabpagemax=18 
set showtabline=2 


"Python part
"pydiction 1.2 python auto complete
"filetype plugin on
"let g:pydiction_location = 'D:\\Programs\\Vim\\vimfiles\\tools\\pydiction\\complete-dict'
"defalut g:pydiction_menu_height == 15
"let g:pydiction_menu_height = 20 

"Compile and run current file
function CheckPythonSyntax()
    let mp = &makeprg
    let ef = &errorformat
    let exeFile = expand("%:t")
    setlocal makeprg=python\ -u
    set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
    silent make %
    copen
    let &makeprg     = mp
    let &errorformat = ef
endfunctio

map <F4> :call CheckPythonSyntax()<CR>

"MiniBuffer Setting
"let g:miniBufExplMapWindowNavVim = 1 
"let g:miniBufExplMapWindowNavArrows = 1 
"let g:miniBufExplMapCTabSwitchBufs = 1 
"let g:miniBufExplModSelTarget = 1 
"

"indent set
let g:indent_guides_guide_size=1

"highlight cursor line and row
set cuc
set cul


" OmniCppComplete
set nocp
filetype plugin on
set tags+=/home/winter/.vim/tags/tags
set tags+=/home/winter/.vim/tags/std_tags
map <F12> :!ctags -R --sort=1 --c++-kinds=+p --fields=+iaS --extra=+q --language-force=C++ -f tags .<CR>
let OmniCpp_NamespaceSearch = 1
let OmniCpp_GlobalScopeSearch = 1
let OmniCpp_ShowAccess = 1
let OmniCpp_ShowPrototypeInAbbr = 1 " 显示函数参数列表
let OmniCpp_MayCompleteDot = 1   " 输入 .  后自动补全
let OmniCpp_MayCompleteArrow = 1 " 输入 -> 后自动补全
let OmniCpp_MayCompleteScope = 1 " 输入 :: 后自动补全
let OmniCpp_DefaultNamespaces = ["std", "_GLIBCXX_STD"]"]

"settings for NERD_commenter
let NERDShutUp=1

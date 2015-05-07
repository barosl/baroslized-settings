scripte utf-8
" vim: set fenc=utf-8 tw=0:
" 파일의 첫부분에 위의 2줄을 꼭 남겨 두십시오.

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 랜덤여신의 Vim 설정 파일
" 마지막 수정: 2005-12-05 19:13:41 KST
" $Id: .vimrc 65 2005-12-05 10:13:55Z barosl $
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 프로그램 기본 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 오리지널 Vi 와의 호환성을 없애고, Vim 만의 기능들을 쓸 수 있게 함.
set nocp

" 모든 옵션을 원래대로 복원
set all&

" 명령어 기록을 남길 갯수 지정
set hi=100

" 백스페이스 사용
set bs=indent,eol,start

" 인코딩 설정
" 문서를 읽을 때 BOM 을 자동으로 제거하려면, fencs 맨 앞에 ucs-bom 를 추가하세요.
"let &tenc=&enc
"set enc=utf-8
set fenc=utf-8
set fencs=utf-8,cp949,cp932,euc-jp,shift-jis,big5,latin1,ucs-2le

" 홈 디렉토리가 존재할 때에만 사용할 수 있는 기능들
if exists("$HOME")

" 홈 디렉토리를 구한다.
" 특정 시스템에서는 홈 디렉토리 경로 끝에 / 또는 \ 문자가
" 붙어 있기 때문에, 그것들을 제거한다.
	let s:home_dir = $HOME
	let s:temp = strpart(s:home_dir,strlen(s:home_dir)-1,1)
	if s:temp == "/" || s:temp == "\\"
		let s:home_dir = strpart(s:home_dir,0,strlen(s:home_dir)-1)
	endif

" Locate the Vim directory
	if has('win32')
		let s:vim_dir = s:home_dir.'/_vim'
	else
		let s:vim_dir = s:home_dir.'/.vim'
	endif

" 경로 설정
	let s:dir_tmp = s:vim_dir.'/tmp'
	let s:dir_backup = s:vim_dir.'/backup'

" 임시 디렉토리 설정
	if isdirectory(s:dir_tmp) || mkdir(s:dir_tmp, 'p')
		set swf
		let &dir = s:dir_tmp
	else
		set noswf
		set dir=.
	endif

" 백업 디렉토리 설정
	if isdirectory(s:dir_backup) || mkdir(s:dir_backup, 'p')
		set bk
		let &bdir = s:dir_backup
		set bex=.bak
	else
		set nobk
	endif

endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 편집 기능 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 커서의 위치를 항상 보이게 함.
set ru

" 완성중인 명령을 표시
set sc

" 줄 번호 표시
set nu

" 줄 번호 표시 너비 설정 (Vim 7)
"set nuw=5

" 탭 크기 설정
set ts=4
set sw=4

" 탭 -> 공백 변환 기능 (사용 안함)
set noet
set sts=0

" 자동 줄바꿈 안함
set nowrap

" 마지막 편집 위치 복원 기능
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "norm g`\"" |
\ endif

" gVim 을 사용중일 경우 클립보드를 unnamed 레지스터로 매핑
" xterm_clipboard 기능이 있을 때에도 매핑 가능
if has("gui_running") || has("xterm_clipboard")
	set cb=unnamed
endif

" magic 기능 사용
set magic

" 여러 가지 이동 동작시 줄의 시작으로 자동 이동
set sol

" 비주얼 모드에서의 동작 설정
set sel=exclusive

" SHIFT 키로 선택 영역을 만드는 것을 허용
" 영역 상태에서 Ctrl+F,B 로 이동하면 영역이 해제되어 버려서 해제
"set km=startsel,stopsel

" 가운데 마우스 버튼으로 붙여넣기 하는 것을 무효화한다.
map <MiddleMouse> <Nop>
map! <MiddleMouse> <Nop>

" 괄호짝 찾기 기능에 사용자 괄호 종류를 더한다.
set mps+=<:>

" 새로 추가된 괄호의 짝을 보여주는 기능
"set sm

" Insert 키로 paste 상태와 nopaste 상태를 전환한다.
" 함수 방식으로 바꾸었다. 자세한 것은 아래로~
"set pt=<Ins>

" 키 입력 대기시간을 무제한으로, 그러나 key codes 에 대해서는 예외
set noto ttimeout

" 키 입력 대기시간 설정 (milliseconds) (ttm 을 음수로 설정하면 tm 을 따라감)
set tm=3000 ttm=100

" 영역이 지정된 상태에서 Tab 과 Shift-Tab 으로 들여쓰기/내어쓰기를 할 수 있도록 함.
vmap <Tab> >gv
vmap <S-Tab> <gv

" 입력이 중단된 후 얼마 후에 swap 파일을 쓸 것인지와
" CursorHold 이벤트의 대기시간을 설정 (milliseconds)
set ut=10

" 몇 글자를 입력받으면 swap 파일을 쓸 것인지 설정
set uc=200


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 검색 기능 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 검색어 강조 기능
set hls

" 검색시 파일 끝에서 처음으로 되돌리기 안함
set nows

" 검색시 대소문자를 구별하지 않음
set ic

" 똑똑한 대소문자 구별 기능 사용
set scs


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 모양 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" GUI 이면, 시작시 크기 설정
if has("gui_running")
	set lines=50
	set co=125
endif

" 시작시 전체화면으로 설정
" 이제 이것도 귀찮아졌다...!
if has("win32")
"	au GUIEnter * simalt ~x
endif

" 추적 수준을 최대로
set report=0

" 항상 status 라인을 표시하도록 함.
set ls=2


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 폰트 설정
if has("gui_running")
	if has("win32")
		set gfn=굴림체:h9:cHANGEUL
"		set gfn=GulimChe:h9:cHANGEUL
	else
		set gfn=GulimChe\ 9
	endif
"	set gfn=Jung9\ 9
"	set gfn=Fixedsys:h12:cHANGEUL
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" filetype 기능 & Syntax Highlighting 기능
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 파일의 종류를 자동으로 인식
filet plugin indent on

" 몇몇 커스텀 확장자들에게 파일 형식 설정
"au BufRead,BufNewFile *.dic setl ft=php

" 파일 형식에 따른 Syntax Highlighting 기능을 켠다
sy enable


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" indent 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 자동 들여쓰기 사용 안함
set noai

" 똑똑한 들여쓰기 사용 안함
set nosi

" 내장된 indent 파일이 없어서 C indent 를 사용하는 경우
"au FileType javascript,jsp setl cin

" 각 언어의 표준 indent 를 사용하는 경우
" 수동 추가하기가 귀찮아져서 결국 자동 인식으로 바꿨다.
"au FileType c,cpp,html,vim,java,sh,python,xml,perl,xf86conf,conf,apache
"\ if expand("<amatch>") != "" |
"\   if exists("b:did_indent") |
"\		unlet b:did_indent |
"\   endif |
"\ runtime! indent/<amatch>.vim |
"\ endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 컬러 스킴
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !has("gui_running")
" 사용하는 터미널 종류에 따라 밝음, 어두움을 설정
" 자고로 터미널은 어두운겨 -ㅅ-
	set bg=light
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 단축키 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 상용구 설정
iab xdate <C-R>=strftime("%Y-%m-%d %H:%M:%S")<CR>
iab xtime <C-R>=strftime("%H:%M:%S")<CR>
"iab xname 랜덤여신

" BufExplorer 플러그인 (스크립트 번호: 42)
" :ls 와 :b 에 익숙해져서 이젠 필요없다...
"nnoremap <silent> <F5> :BufExplorer<CR>

" Vim 자체 Explore 기능
" :E 라는 게 있었군...
"nnoremap <silent> <F6> :Explore<CR>

" Vim 정규식이 아닌 진짜 정규식 사용을 의무화(?)
" \v 라는 글자가 항상 표시되니까 햇갈린다... -.-
"map / /\v


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" GUI 간소화
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if has("gui_running")

" gVim 메뉴를 사용하지 않는다. 대부분의 명령보다 선행되어야 한다.
"	let did_install_default_menus = 1
"	let did_install_syntax_menu = 1
"	let skip_syntax_sel_menu = 1
" 설정 방식이 바뀌었다.
	set go-=m

" 툴바를 보이지 않게 한다.
	set go-=T

" 스크롤바를 표시하지 않는다.
	set go-=l
	set go-=L
	set go-=r
	set go-=R
	set go-=b

" GUI 여서 마우스가 사용 가능하면...
" 마우스를 사용하지 않는다. (누르면 이동되는게 귀찮다!)
"	set mouse=a
	set mouse=

" 마우스 모델을 popup 으로 함.
	set mousem=popup

" '간단한 선택' 다이얼로그가 새 창에서 뜨지 않도록...
	set go+=c

endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 편리한 기능
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use ',' as a leader key
" Must precede any key sequences based on <Leader>
let mapleader = ','

" Tab 자동 완성시 가능한 목록을 보여줌
set wmnu

" 파일 탐색기 설정
let g:explVertical=1
let g:explSplitRight=1
let g:explStartRight=1
let g:explWinSize=20

" vim -b : xxd 포맷으로 바이너리 파일을 수정합니다! (:help hex-editing)
" ...너무 ㅂㅌ적인 방법인 것 같아서 주석처리;
"augroup Binary
"	au!
"	au BufReadPre  *.bin let &bin=1
"	au BufReadPost *.bin if &bin | %!xxd
"	au BufReadPost *.bin set ft=xxd | endif
"	au BufWritePre *.bin if &bin | %!xxd -r
"	au BufWritePre *.bin endif
"	au BufWritePost *.bin if &bin | %!xxd
"	au BufWritePost *.bin set nomod | endif
"augroup END

" Spell Checking 기능 (영어) (Vim 7)
" 기본적으로는 비활성화
"set nospell spelllang=en

" 각종 toggle 기능
fu! ToggleNu()
	let &nu = 1 - &nu
endf
fu! ToggleList()
	let &list = 1 - &list
endf
fu! TogglePaste()
	let &paste = 1 - &paste
endf
fu! ToggleSpell()
	let &l:spell = 1 - &l:spell
endf
map <Leader>n :call ToggleNu()<CR>
map <Leader>l :call ToggleList()<CR>
map <Leader>p :call TogglePaste()<CR>
map <Leader>s :call ToggleSpell()<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 기타 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 매크로 실행중에 화면을 다시 그리지 않음
set lz

" 프로그램 시작시 플러그인 로드
set lpl

"noeol 설정
"au BufNew * set bin | set noeol
"set bin | set noeol

" ㅂㅌ barosl 은 모든 플랫폼에서 unix 줄 변경자를 쓰겠습니다! ..orz
" 경고: 만일 당신의 vim 이 '정상적으로' 동작하길 원하시면,
" 바로 다음줄은 주석처리 하거나 없애세요. -.-;;
set ff=unix

" unix dos mac 줄 변경자 모두 다 읽을 수 있도록 합니다.
set ffs=unix,dos,mac


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 플러그인 설정
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:haskell_indent_if = 4
let g:haskell_indent_case = 4


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filet off
set rtp+=~/.vim/bundle/Vundle.vim
try
	call vundle#begin()
catch
	if confirm('Install Vundle?', "&Yes\n&No") == 1
		!git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim

		call vundle#rc()
		let s:init_vundle = 1
	endif
endtry
Plugin 'gmarik/Vundle.vim'

" List of repositories
Plugin 'zeis/vim-kolor'
Plugin 'Lokaltog/powerline'
Plugin 'tpope/vim-surround'
Plugin 'tomtom/tcomment_vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'wting/rust.vim'

call vundle#end()
filet plugin indent on

if exists('s:init_vundle')
	BundleInstall
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color scheme settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

colo kolor


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Powerline support
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set rtp+=~/.vim/bundle/powerline/powerline/bindings/vim
set nosmd


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Tab page settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set <M-n>=n
set <M-w>=w
set <M-q>=q
set <M-1>=1
set <M-2>=2
set <M-3>=3
set <M-4>=4
set <M-5>=5
set <M-6>=6
set <M-7>=7
set <M-8>=8
set <M-9>=9
set <M-0>=0

noremap <M-n> :tabe<CR>
noremap <M-w> :q<CR>
noremap <M-q> :qa<CR>
noremap <M-PageDown> :tabn<CR>
noremap <M-PageUp> :tabp<CR>

noremap <C-o> :tabe<CR>
noremap <C-e> :q<CR>
noremap <C-g> :qa<CR>
noremap <C-n> :tabn<CR>
noremap <C-p> :tabp<CR>

noremap <M-1> 1gt
noremap <M-2> 2gt
noremap <M-3> 3gt
noremap <M-4> 4gt
noremap <M-5> 5gt
noremap <M-6> 6gt
noremap <M-7> 7gt
noremap <M-8> 8gt
noremap <M-9> 9gt
noremap <M-0> 10gt

if has('gui_running')
	noremap <C-tab> :tabn<CR>
	noremap <C-S-tab> :tabp<CR>
endif


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Miscellaneous settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Shortcuts to stop the highlighting
noremap <Leader><Leader> :noh<CR>
if has('gui_running')
	nnoremap <Esc> :noh<CR>
endif

" Adjust key bindings to the current wrap mode
fu! UpdateWrap()
	if &wrap
		noremap <Up> gk
		noremap <Down> gj
		noremap <Home> g0
		noremap <End> g$
	else
		sil! unm <Up>
		sil! unm <Down>
		sil! unm <Home>
		sil! unm <End>
	endif
endfu

fu! ToggleWrap()
	set wrap!
	call UpdateWrap()
endf

noremap <Leader>w :call ToggleWrap()<CR>

call UpdateWrap()

" Set working directory to the directory of the current file
"au BufEnter * sil! lcd %:p:h

" Toggle space indentation mode
fu! ToggleTab()
	set et!

	if &et
		let s:size = str2nr(input("Input tab size: "))

		let &ts = s:size
		let &sw = s:size
		let &sts = s:size
	else
		let &ts = 4
		let &sw = 4
		let &sts = 0
	endif
endf

noremap <Leader>t :call ToggleTab()<CR>
com! -nargs=* ToggleTab call ToggleTab(<f-args>)

" Key bindings for insert mode
inoremap <S-Tab> <C-o><<
inoremap <C-\> <C-o>^

" Highlight the cursor
"set cul
"set cuc

" Folds are created automatically
"set fdm=indent

" Undo behavior
set ul=2000
set ur=0

" Persistent undo
if &ur
	let s:undo_dir = s:vim_dir.'/undo'
	if isdirectory(s:undo_dir) || mkdir(s:undo_dir, 'p')
		set udf
		let &udir = s:undo_dir
	endif
endif

" Save a file using sudo
com! SudoWrite exe 'sil w !sudo tee '.shellescape(expand('%')).' >/dev/null' | e!

" Shortcut to reload the file
noremap <Leader>e :e<CR>

" Use modelines
set ml
set mls=5

" Always use list mode
set list

" Characters to use in list mode
set lcs=tab:»\ ,trail:·,extends:→,precedes:←,nbsp:␣

" Don't highlight tab characters in HTML files
"au FileType * set lcs-=tab:\ \ 
"au FileType html,xhtml set lcs+=tab:\ \ 

" Highlight columns after 'textwidth'
exe 'set cc=+'.join(range(1, 255), ',+')

" Key sequence to toggle paste mode
set pt=<F4>

" Allow use of ';' instead of ':'
noremap ; :

" Don't use hidden buffers
set nohid

" Use soft tabs instead of hard tabs
set et
let &sts = &ts

" Key sequences to navigate between windows
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Move selected lines
nnoremap <C-Down> ddp
nnoremap <C-Up> ddkP
vnoremap <C-Down> dp`[V`]
vnoremap <C-Up> dkP`[V`]

" Select the previously edited or copied text
noremap gV `[v`]

" Convert leading whitespace between tabs and spaces
noremap <Leader>i :ret!<CR>

" Detect indent style
fu! <SID>DetectIndent()
	let l:line_cnt = 50
	let l:lines = getline(1, l:line_cnt) + getline(line('$')-l:line_cnt+1, '$')

	if len(filter(l:lines, 'v:val =~ "^\\t"')) > len(filter(l:lines, 'v:val =~ "^ "'))
		set noet ts=4 sw=4 sts=0
	endif
endf

au BufReadPost * call <SID>DetectIndent()

" Redraw the screen
noremap <Leader>r :redr!<CR>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End of File
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

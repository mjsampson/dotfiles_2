call plug#begin()

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

" Autocomplete and IntelliSense Engine
Plug 'neoclide/coc.nvim', {'branch': 'release'}


Plug 'LunarWatcher/auto-pairs'


Plug 'pangloss/vim-javascript'    " JavaScript support
Plug 'leafgarland/typescript-vim' " TypeScript syntax
Plug 'maxmellon/vim-jsx-pretty'   " JS and JSX syntax
Plug 'jparise/vim-graphql'        " GraphQL syntax

call plug#end()


" CoC extensions
let g:coc_global_extensions = ['coc-tsserver']



" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction


# https://qiita.com/syui/items/c1a1567b2b76051f50c4

export HISTFILE=${HOME}/.zsh_history

# Number of history entries stored in memory
export HISTSIZE=1000

# Number of history entries stored in history file
export SAVEHIST=1000

# TODO: for the settings
setopt histexpiredupsfirst
setopt histfindnodups

unsetopt noappendhistory
unsetopt nobanghist
unsetopt cshjunkiehistory
unsetopt histallowclobber
unsetopt nohistbeep
unsetopt histfcntllock
unsetopt histignoredups
unsetopt histlexwords
unsetopt histnofunctions
unsetopt nohistsavebycopy
unsetopt histsavenodups
unsetopt histsubstpattern
unsetopt incappendhistory
unsetopt incappendhistorytime

# # 開始と終了を記録
setopt EXTENDED_HISTORY

# function history-all { history -E 1 }

setopt share_history

# # 同じコマンドが履歴にすでにあれば、古い方を削除して新しい方だけを残す
setopt hist_ignore_all_dups

# # 履歴ファイルに保存するときに重複があれば古い方を保存しない（セッション中の重複は許す）
unsetopt hist_save_no_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 補完時にヒストリを自動的に展開
setopt hist_expand

# 履歴をインクリメンタルに追加
# # setopt inc_append_history

# # # インクリメンタルからの検索

# # bindkey "^R" history-incremental-search-backward
# # bindkey "^S" history-incremental-search-forward

fish_add_path $HOME/miniconda3/bin

if type -q pyenv
    eval (pyenv init --path)
    eval (pyenv init -)
end

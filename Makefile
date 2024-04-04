ZSH_DATA_DIR = ~/.local/share/zsh/

install: $(ZSH_DATA_DIR)
	ln -sr zshrc ~/.zshrc
	ln -sr zshenv ~/.zshenv

$(ZSH_DATA_DIR):
	mkdir -p $@

.PHONY: install

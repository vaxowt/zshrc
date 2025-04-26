ZSH_DATA_DIR = ~/.local/share/zsh/
ZSH_CACHE_DIR = ~/.cache/zsh/

install: $(ZSH_DATA_DIR) $(ZSH_CACHE_DIR)
	ln -sr zshrc ~/.zshrc
	ln -sr zshenv ~/.zshenv

$(ZSH_DATA_DIR):
	mkdir -p $@

$(ZSH_CACHE_DIR):
	mkdir -p $@

.PHONY: install

# Source default system settings
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
fi

shopt -s autocd

# Function to parse Git branch with colored arrows for commits
# ahead/behind upstream.
git_ahead_behind_prompt() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
        local upstream
        upstream=$(git rev-parse --abbrev-ref "@{upstream}" 2>/dev/null)
        if [ -n "$upstream" ]; then
            local counts
            counts=$(git rev-list --count --left-right "@{upstream}...HEAD" 2>/dev/null)
            local behind=$(echo "$counts" | cut -f1)
            local ahead=$(echo "$counts" | cut -f2)

            local status=""
            [ "$ahead" -gt 0 ] 2>/dev/null && status+=" \033[32m↑$ahead\033[32m"
            [ "$behind" -gt 0 ] 2>/dev/null && status+=" \033[31m↓$behind\033[34m"

            echo -e " ($branch$status)"
        else
            echo " ($branch)"
        fi
    fi
}
# Color codes: Green = 32m, Blue = 34m, Red = 31m, White = 00m
# Prompt setup: Directory = Green, Branch = Blue, Input = White
export PS1='\[\033[32m\]\w\[\033[34m\]$(git_ahead_behind_prompt)\[\033[00m\] $ '

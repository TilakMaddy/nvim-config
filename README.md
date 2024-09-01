# THIS IS A MODIFIED FORK OF https://github.com/nvim-lua/kickstart.nvim 

Fist watch this video by TJ Devries

[https://youtu.be/m8C0Cq9Uv9o](Neovim Kickstart Guide)


## Extra features I added 
- Solidity support (Nomic Hardhat's solidity LSP)
- Typescript / Node support
- Rust support 
- Harpoon (ThePrimeagen's plugin)

## Steps


First install neovim from brew 

```bash
brew install neovim
```

Also now, make sure npm, npx, rustup is available on path

Install solidity LSP

```bash
npm install @nomicfoundation/solidity-language-server -g
```

Then, add rust LSP to your system 

```bash
rustup component add rust-analyzer
```

Now, we are good to use this fork. Clone the contents of this repository into `~/.config/nvim`

Then start `nvim`

Initially it will take some time to load, then it will be faster from then on.

## Usage 

Vim fundamentals course that I liked by @ThePrimeagen

https://frontendmasters.com/courses/vim-fundamentals/

### 

I also use [lazygit](https://github.com/jesseduffield/lazygit) by the way ...

and [warp](https://www.warp.dev/) with semi-transparent fish background by the way ..


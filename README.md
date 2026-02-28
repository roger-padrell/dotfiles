# My dotfiles (omarchy debloat and customization)
Usage:
1. Install omarchy normally using the ISO and a bootable USB (or any method you want as long as it is a new installation).
1.1 Connect to the internet
2. Clone repo: 
```bash
cd
git clone https://github.com/roger-padrell/dotfiles
cd dotfiles
```
After connecting, you may need to launch another terminal/shell, as the current one may be corrupted.
3. Debloat omarchy: `./scripts/debloat.sh`
4. Setup (install dependencies and setup theme): `./scripts/setup.sh`
5. Update local config (my dotfile customization): `./scripts/update.sh`
6. Enjoy :)

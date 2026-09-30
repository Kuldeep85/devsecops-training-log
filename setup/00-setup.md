# Setup (do this once, about 90 minutes)

## 0. Which machine should I use?
Use a **personal** computer if you can. If you use a work laptop, check your company's policy first about installing Docker, WSL tools and developer software, and **never** mix work accounts, client repositories, client tokens or client screenshots with this practice. Use a separate personal email and a separate personal GitHub account.

## 1. WSL and Ubuntu
Your screenshot shows a black `wsl.exe` window with no prompt. That usually means no Linux distribution is installed yet, or it is still starting. In **Windows PowerShell** run:

```powershell
wsl -l -v
```

- If you see `Ubuntu` with VERSION `2`, start it from the Start menu (**Ubuntu**), or run `wsl -d Ubuntu`.
- If the list is empty: `wsl --install -d Ubuntu`, restart Windows if asked, open **Ubuntu** and create a Linux username and password (you will type the password when you use `sudo`; it will not show as you type).
- If it shows VERSION `1`: `wsl --set-version Ubuntu 2`.

Then, **inside Ubuntu**:

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget jq unzip make tree python3 python3-venv python3-pip python3-yaml
```

## 2. VS Code connected to WSL
Install the **WSL** extension in VS Code. In Ubuntu, `code .` opens the current folder in VS Code running inside WSL.

## 3. Git identity and GitHub access
```bash
git config --global user.name "Your Name"
git config --global user.email "your-personal-email@example.com"
git config --global init.defaultBranch main
ssh-keygen -t ed25519 -C "your-personal-email@example.com"     # press Enter to accept defaults
cat ~/.ssh/id_ed25519.pub
```
Copy the printed line. On GitHub: **Settings → SSH and GPG keys → New SSH key**, paste it. Then test:

```bash
ssh -T git@github.com          # answer "yes"; you should see "Hi <username>! You've successfully authenticated"
```

## 4. Create this training repository on GitHub
1. On GitHub create a **public** repository called `devsecops-training-log` (empty, no README).
2. Then:

```bash
mkdir -p ~/repos && cd ~/repos
unzip ~/Downloads/devsecops-training-log.zip          # adjust to where you saved it
cd devsecops-training-log
git init -b main
git add . && git commit -m "Day 0: initial training log structure"
git remote add origin git@github.com:<your-username>/devsecops-training-log.git
git push -u origin main
chmod +x tools/finish-day.sh
```

## 5. Docker
**Option A: Docker Desktop for Windows** with the WSL 2 backend (check the current licence terms for your situation, and whether your employer allows it on a work laptop).

**Option B: Docker Engine inside Ubuntu** (free):

```bash
# enable systemd in WSL (once)
echo -e "[boot]\nsystemd=true" | sudo tee /etc/wsl.conf
```
Close all terminals, run `wsl --shutdown` in PowerShell, reopen Ubuntu, then:

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker $USER
```
Close and reopen Ubuntu, then check: `docker run --rm hello-world`.

If virtualisation is blocked on your machine, tell yourself early and use a personal computer for the Docker and Kubernetes days.

## 6. Node.js 22 (for the project)
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash     # check the nvm README for the current version
source ~/.bashrc
nvm install 22
node --version
```

## 7. DbVisualizer
You already have it. From Week 4 you will connect it to a **local** MySQL container on `localhost:3306`. Never connect it to a client database for practice.

## 8. Done when
`git --version`, `docker run --rm hello-world`, `node --version` and `ssh -T git@github.com` all work, and your GitHub repo shows the first commit.

# 📂 /testing
this is where the convenience script is setup for Ubuntu environments

## How do I use this script?
> [!CAUTION]  
> ## BEFORE YOU CONTINE!
> this guide has been tested on a GitHub codespaces environment, depending of your OS/environment, some steps may be different than others. **i do not provide support for this script, so if it breaks, welp**

1. get ubuntu, ubuntu 22.04 or higher should be fine
> [!NOTE]  
> other operating systems should work fine, but you may have trouble installing the dependencies required for aether 

2. get the dependencies for aether:
```bash
apt install -y curl zip unzip jq coreutils toilet wget software-properties-common
```
3. make a directory to store the script and get the script:
```bash
mkdir -p aether
cd aether
wget -O script.sh https://aether.loners.software/testing/script.sh
```
4. modify the script with YOUR settings! there are 15 environment variables, where:
* 3 of them are variables set by Pterodactyl
* 10 of them are variables for aether
* 2 of them are variables for the convenience script to work
5. run the script! run this on your terminal:
```bash
chmod +x script.sh
./script.sh
# or if this doesn't work:
bash script.sh
```

> [!TIP]  
> congrats! you can now test aether
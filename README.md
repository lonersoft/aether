# 🥚 aether [![wakatime](https://wakatime.com/badge/github/lonersoft/aether.svg)](https://wakatime.com/badge/github/lonersoft/aether) [![Create and publish the egg on ghcr.io](https://github.com/lonersoft/aether/actions/workflows/docker-publish.yml/badge.svg?branch=main)](https://github.com/lonersoft/aether/actions/workflows/docker-publish.yml)

A simple multiegg that's highly configurable (in my opinion), ~~that's paid~~ all for free and open source!

aether is a multiegg designed to simply server management for hosting providers. Currently, it only supports Minecraft, but more may come soon.

## 🧩 Features
there's not alot of impressive features, but some of them might be useful such as:
* built-in rules: when enabled, the first boot of a server will show them rules to comply with a confirmation
* set MCJars API Key: track some stats like the total requests, and even block some server software from there!
* forced MOTD: put your hosting name on their server's MOTD! this does not block plugins that interact with the MOTD such as [`➚ MiniMOTD`](https://modrinth.com/plugin/minimotd) or [`➚ AdvancedServerList`](https://modrinth.com/plugin/advancedserverlist)
* custom logo: need the banner to be purple? or something else to match your branding? [`➚ head here to get a free custom banner!`](#%EF%B8%8F-hostings-that-use-aether) your hosting will also be on the list

any ideas you may wanna see? [`➚ create an issue!`](https://github.com/lonersoft/aether/issues/new)

## 💖 Donate
aether is free and open-source software. To host this egg, a lot of resources and money (and most importantly, time!) is used to run the servers. To keep our motivation going and keep everything up and running, we rely heavily on [`➚ donations`](https://hcb.hackclub.com/lonersoft/donations). We're also nonprofit and transparent with our finances! 

[➚ **Donate to our nonprofit organization**](https://hcb.hackclub.com/donations/start/lonersoft) or [`➚ view our open finances`](https://hcb.hackclub.com/lonersoft).

## ➕ Installation
1. get the egg [`➚ here`](https://github.com/lonersoft/aether/releases/latest) and download the json file
2. navigate to yourpanelurl.com/admin/nests and create a new nest (optional)
3. upload the json file to your newly created nest, or use a existing nest
4. check the startup tab! there might be features you may want enabled, such as the forced MOTD
4. ???
5. profit

## 🖥️ Hostings that use aether

| Hostings                                     | About                                                                                                                                        | Custom banner? | Notes    |
|---------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|-----|---------------------|
| [**OrynCloud**](https://www.oryncloud.com/) | Host your perfect game server with lightning-fast speeds, 99.9% uptime, and DDoS protection. The premier choice for serious gamers in India. | ✅ | Used in free hosting

want your hosting listed here and/or have a custom banner? [📧 email me!](mailto:hi@amogusreal.tech) it's free!

## 👥 Contributors
wanna contribute? thanks! to start contributing, you have to [`➚ fork this repo`](https://github.com/lonersoft/aether/fork) and then [`➚ open a PR`](https://github.com/lonersoft/aether/compare).

<a href="https://github.com/lonersoft/aether/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=lonersoft/aether" />
</a>

## 🌟 Stargazers
<a href="https://github.com/lonersoft/aether/stargazers/">
  <picture>
    <source media="(prefers-color-scheme: light)" srcset="http://reporoster.com/stars/lonersoft/aether">
    <img alt="stargazer-widget" src="http://reporoster.com/stars/dark/lonersoft/aether">
  </picture>
</a>

## ⚒️ Roadmap
right now, this is what i'm planning to do:

- [ ] 💾 decrease docker image size (current is ~250mb)
- [ ] 🤖 maybe setup bot languages? might take a lot of space tho
- [x] ❓ organize the functions of the egg, current egg is kinda hard to understand in my opinion
- [ ] ⌨️ don't make the startup tab filled with admin-only variables, perhaps with a .json file that people can host themselves?
- [ ] 🔒 lock server softwares that hostings may not need
- [ ] ➕ enable ability to change rules

## 💖 Credits
this project wouldn't have been possible without theses projects:\
Primectyl (closed src): provided some bases of how software install works, basically what inspired me to make my own multiegg\
[`➚ Pterodactyl`](https://pterodactyl.io/): the game panel everyone loves! it is a free, open-source game server management panel built with PHP, React, and Go.\
[`➚ MCJars`](https://mcjars.app): the place where we get the server.jar's, i love the service\
[`➚ MC JAR FILES`](https://mcjarfiles.com/): the place where we get the bedrock vanilla dedicated servers, god i love this service 💖\
and some that i forgot! my bad :(

## 📄 Licensing
aether is licensed under the [`➚ MIT license`](https://github.com/lonersoft/aether/blob/main/LICENSE)

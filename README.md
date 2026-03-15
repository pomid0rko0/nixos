# NixOS — MSI Vector GP77 13VG

## Установка

### 1. Залить конфигурацию в git-репозиторий

### 2. Скачать NixOS minimal ISO

```bash
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso
```

### 3. Записать ISO на флешку

Узнать имя флешки:

```bash
lsblk
```

Записать (заменить `/dev/sdX` на флешку):

```bash
sudo dd if=latest-nixos-minimal-x86_64-linux.iso of=/dev/sdX bs=4M status=progress oflag=sync
```

### 4. Загрузиться с флешки

### 5. Подключиться к Wi-Fi

```bash
sudo systemctl start wpa_supplicant
wpa_cli
> add_network 0
> set_network 0 ssid "имя_сети"
> set_network 0 psk "пароль"
> enable_network 0
> quit
```

### 6. Настроить прокси (если нужен)

Узнать IP телефона (шлюз по умолчанию):

```bash
ip route
```

Задать переменные (заменить `X.X.X.X` на IP из предыдущей команды):

```bash
export http_proxy=http://X.X.X.X:10809
export https_proxy=http://X.X.X.X:10809
```

Проверить:

```bash
curl -I https://cache.nixos.org
```

### 7. Клонировать конфигурацию и установить

```bash
git clone https://github.com/pomid0rko0/nixos.git /tmp/nixos
sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko /tmp/nixos/modules/disko.nix
sudo nixos-generate-config --root /mnt --no-filesystems --dir /tmp/nixos
sudo nixos-install --flake /tmp/nixos#vector
```

### 8. После установки

Задать пароль пользователю:

```bash
sudo passwd pomid0rko_0
```

### 9. Настроить dae (прокси)

dae использует agenix для хранения подписок. После первой загрузки SSH-ключи хоста
генерируются автоматически — нужно привязать к ним секреты.

Получить age-ключ из SSH-ключа хоста:

```bash
nix-shell -p ssh-to-age --run 'cat /etc/ssh/ssh_host_ed25519_key.pub | ssh-to-age'
```

Вставить полученный ключ в `secrets/secrets.nix`:

```nix
let
  vector = "age1...";  # ← ключ из команды выше
in
{
  "vpn-subscriptions.age".publicKeys = [ vector ];
}
```

Создать файл с подписками (формат dae):

```
    subscription_1: 'subscription 1 url addres'
subscription_2: 'subscription 2 url addres'
    subscription_1: 'subscription 1 url addres'
```

Зашифровать подписки (**через `-R`, не `-r`**):

```bash
nix-shell -p age --run 'age -R /etc/ssh/ssh_host_ed25519_key.pub -o secrets/vpn-subscriptions.age subscriptions.txt'
rm subscriptions.txt
```

Применить:

```bash
git add secrets/
sudo nixos-rebuild switch --flake .#vector
```

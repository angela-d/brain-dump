# Initial Ansible Setup On Debian 9
Ansible's official documentation suggests you use a [Launchpad repo](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installing-ansible-on-debian) to install.

- I seen no benefits between the Launchpad repo vs [Debian Stretch backport](https://packages.debian.org/stretch-backports/ansible) (*both* used Python 2, by default, for the host machine running Ansible)
> Individual Linux distribution packages may be packaged for [Python2 or Python3](https://docs.ansible.com/ansible/latest/reference_appendices/python_3_support.html). When running from distro packages you’ll only be able to use Ansible with the Python version for which it was installed.

- When installing Ansible via pip, it's supposed to default to Python3.  I use `pip3` on Debian, so I ran `pip3 install ansible` and after the install, the ansible launcher in ~/.local was a symlink to /usr/bin/ansible, which meant this version would never work -- because /usr/bin/ansible didn't exist.

After some troubleshooting with pip3, I decided to install Ansible to Debian 9 using Debian Stretch's backports repo.

Backports, because it's a newer version than in Debian stable.

Initial install
```bash
sudo apt update && sudo apt -t stretch-backports install "ansible"
```

Install dependencies for Kerberos for Active Directory authentication
```bash
sudo apt install krb5-user libkrb5-dev gcc python-dev
```

Because I use Python3 for all of my local development, I had to install `pip` for Python 2
```bash
sudo apt install python-pip
```

Install Python 2 dependencies (run as your user, not root/sudo!) - pywinrm for Windows Remote Management and Kerberos for AD authentication
```bash
pip install pywinrm[kerberos]
```
I got a segfault!
```text
...
Successfully installed certifi-2020.6.20 cffi-1.14.0 chardet-3.0.4 cryptography-3.0 enum34-1.1.10 idna-2.10 ipaddress-1.0.23 ntlm-auth-1.5.0 pycparser-2.20 pykerberos-1.2.1 pywinrm-0.4.1 requests-2.24.0 requests-ntlm-1.1.0 six-1.15.0 urllib3-1.25.10 xmltodict-0.12.0
Segmentation fault
```
That's because, I *also* have the `python-cryptography` package installed through apt.  Removing it and installing via pip would remove a ton of stuff I use (Ansible, being one of them!) so I decided to ignore it.

## Directory tree of `~/.ansible`
This isn't the "official" (or required) formatting, but it's how I set my environment.
```text
├── hosts
│   └── test.yml
├── playbooks
│   └── critical-win.yml
└── tmp
```
- `hosts` = where I list the hosts for Ansible to manage
- `playbooks` = rulesets for Ansible to use against the hosts
- `tmp` = Default folder added by Ansible, ignore it

## Initial Configuration
See where the Ansible config is kept
```bash
ansible --version
```
> ansible 2.9.11
>
>  config file = /etc/ansible/ansible.cfg
>
> ...

I don't feel like launching super user to modify this, or losing my changes during an upgrade so I changed it's path:
```bash
touch ~/.ansible.cfg
```
By the existence of that file, Ansible will look there before checking in /etc/ for those values.  Anything not in ~/.ansible.cfg will be taken from the default location.

Confirm the change:
```bash
ansible --version
```
> ansible 2.9.11
>
>  config file = /home/angela/.ansible.cfg
>
> ...

Tell Ansible where to look for your hosts
```bash
pico ~/.ansible.cfg
```

Add:
```bash
[defaults]
inventory = /home/angela/.ansible/hosts
interpreter_python = auto
```

Create the directory (as user/non-root or non-sudo)
```bash
mkdir -p ~/.ansible/hosts
```

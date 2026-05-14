#!/bin/bash

# Root kontroll: Kontrolleras om EUID är inte 0 (-ne = not equal) och avsluta programmet (exit 1 eftersom det är något som gick fel)
if [ "$EUID" -ne 0 ]; then
    echo "Inget root"
    exit 1
fi 

# User kontroll: Kontrolleras om det finns något argument ($#) för den username (-eq = equal). Om finns inga argument då avslutar programmet (exit 1)
if [ $# -eq 0 ]; then
    echo "Ingen username"
    exit 1
fi

# Mappar: Vi tar argumentet av username (local username=$1) och skapar olika mapp för den (mkdir -p)
create_folders() {
    local username=$1

    mkdir -p /home/$username/Documents
    mkdir -p /home/$username/Downloads
    mkdir -p /home/$username/Work
}

# Perms: Använder username argumentet för att ge perms för den user (chmod 700 = Change mode)
set_permissions() {
    local username=$1

    chmod 700 /home/$username/Documents
    chmod 700 /home/$username/Downloads
    chmod 700 /home/$username/Work

}

# Välkommen: Tar username argumentet för att printa ut ett välkommen arkiv. (echo) som ska länkas till arkiv (>) och vi sätter perms bara till 600 eftersom vi behöver att användaren ska bara läsa och skriva
create_welcome() {
    local username=$1

    echo "Välkommen $username" > /home/$username/welcome.txt
    cut -d: -f1 /etc/passwd >> /home/$username/welcome.txt

    chmod 600 /home/$username/welcome.txt
}

# Loop för användare med dem andra funktioner
for username in "$@"
do
    echo "Creating $username"
    useradd -m "$username"

    create_folders "$username"
    set_permissions "$username"
    create_welcome "$username"
done

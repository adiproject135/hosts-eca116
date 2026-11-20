
#!/bin/bash

cat /etc/hosts | while read ip host rest
do
    if [[ -z "$ip" || "$ip" == \#* ]]; then
        continue
    fi

    if [[ -z "$host" ]]; then
        continue
    fi

    dns_ip=$(nslookup "$host" 2>/dev/null | awk '/^Name:/{found=1; next} found && /^Address:/{print $2; exit}')

    if [[ -n "$dns_ip" && "$ip" != "$dns_ip" ]]; then
        echo "Bogus IP for $host in /etc/hosts!"
    fi
done

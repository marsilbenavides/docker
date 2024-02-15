# Place in ./bin
- wildfly-21.0.2.Final.tar.gz

# Add admin user
1. Log to instance
```bash
docker exec -it "instance-name" /bin/sh
```
2. Execute
```bash
cd /opt/wildfly-21/bin/
./add-user.sh -u "admin" -p "thePassword"
exit
```

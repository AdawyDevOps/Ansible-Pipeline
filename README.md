# Jenkins + Ansible: Automated Nginx Installation

A hands-on CI/CD lab. Jenkins runs as a Docker container and executes a
Declarative Pipeline that triggers an Ansible playbook to install, start, and
enable Nginx on the same host (the Jenkins container itself).

## Architecture

```
GitHub repo --> Jenkins Pipeline --> Ansible (localhost) --> Nginx
                (Docker container)
```

## Repository Structure

| File | Purpose |
|------|---------|
| `Dockerfile` | Jenkins image with Ansible and sudo installed |
| `inventory.ini` | Inventory with `localhost` and a local connection |
| `playbook.yml` | Refreshes the APT cache, installs Nginx, starts the service |
| `Jenkinsfile` | Declarative Pipeline that runs the playbook |

## Prerequisites

- Windows with WSL 2 and Docker Desktop (WSL integration enabled)
- Git and a GitHub account
- Free ports: `8080` (Jenkins UI) and `8081` (Nginx)

## Quick Start

### 1. Build and run Jenkins

```bash
git clone https://github.com/AdawyDevOps/Ansible-Pipeline.git
cd Ansible-Pipeline

docker build -t jenkins-ansible .

docker run -d --name jenkins \
  -p 8080:8080 -p 50000:50000 -p 8081:80 \
  -v jenkins_home:/var/jenkins_home \
  jenkins-ansible
```

### 2. Unlock Jenkins

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Open `http://localhost:8080`, paste the password, install the suggested
plugins, and create an admin user.

### 3. Create the Pipeline job

1. **New Item** > name it > **Pipeline** > OK
2. Definition: **Pipeline script from SCM**
3. SCM: **Git**, Repository URL: this repo, Branch: `*/main`
4. Script Path: `Jenkinsfile`
5. Save, then **Build Now**

## Verify

```bash
docker exec jenkins service nginx status
docker exec jenkins curl -sI http://localhost
```

Expected: Nginx is running and the response is `HTTP/1.1 200 OK`.
With the `-p 8081:80` mapping you can also open `http://localhost:8081`.

## Idempotency Test

Run the job a second time. The first run changes the system (Nginx is
installed and started). The second run should end with `changed=0` in the
`PLAY RECAP`, because the desired state already exists.

## Troubleshooting

| Problem | Cause | Fix |
|---------|-------|-----|
| `sudo: not found` | sudo missing in the image | Rebuild from the Dockerfile |
| `no hosts matched` | `hosts:` in the playbook does not match the inventory | Use `localhost` in both |
| systemd errors on the service task | Containers have no systemd | Use `use: service` |
| `ansible-playbook: not found` | Ansible not in the container | Rebuild the image |
| Job uses old files | Changes committed but not pushed | `git push`, then Build Now |

## Notes and Limitations

- The target is the Jenkins container itself, not a separate server.
- A container has no init system, so "enabled at boot" is symbolic. After a
  `docker restart`, re-run the pipeline to start Nginx again.
- `NOPASSWD:ALL` in the Dockerfile is for this lab only. In production,
  restrict sudo to the commands that are required.

## Next Steps

- Target a separate Ubuntu VM over SSH using Jenkins Credentials
- Add a stage that tests the page with `curl` and fails on a non-200 response
- Trigger builds automatically with a GitHub webhook

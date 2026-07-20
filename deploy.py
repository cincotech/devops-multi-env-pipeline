#!/usr/bin/env python3

"""
deploy.py

Orchestrateur DevOps

- Exécute Terraform
- Vérifie le résultat
- Lance automatiquement Ansible
- Affiche un résumé final
"""

import subprocess
import sys
from pathlib import Path


# Répertoires du projet
BASE_DIR = Path.home() / "devops-platform"

TERRAFORM_DIR = BASE_DIR / "terraform"
ANSIBLE_DIR = BASE_DIR / "ansible"


def run(command, cwd=None):
    """Exécute une commande et affiche sa sortie en temps réel."""

    print("\n" + "=" * 70)
    print("Exécution :", " ".join(command))
    print("=" * 70)

    process = subprocess.Popen(
        command,
        cwd=cwd,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True
    )

    output = []

    for line in process.stdout:
        print(line, end="")
        output.append(line)

    process.wait()

    return process.returncode, "".join(output)


def terraform():

    print("\n========== TERRAFORM ==========\n")

    rc, _ = run(["terraform", "init"], cwd=TERRAFORM_DIR)

    if rc != 0:
        return False

    rc, _ = run(["terraform", "plan"], cwd=TERRAFORM_DIR)

    if rc != 0:
        return False

    rc, output = run(
        ["terraform", "apply", "-auto-approve"],
        cwd=TERRAFORM_DIR
    )

    if rc != 0:
        return False

    if "Apply complete!" in output:
        return True

    return False


def ansible():

    print("\n========== ANSIBLE ==========\n")

    rc, output = run(
        [
            "ansible-playbook",
            "-i",
            "inventory.ini",
            "site.yml",
            "--ask-become-pass"
        ],
        cwd=ANSIBLE_DIR
    )

    if rc != 0:
        return False

    return output


def main():

    print("\nDEVOPS PLATFORM DEPLOYMENT\n")

    print("1. Terraform")
    success = terraform()

    if not success:
        print("\nTerraform a échoué.")
        sys.exit(1)

    print("\nTerraform terminé avec succès.")

    print("\n2. Ansible")

    result = ansible()

    if not result:
        print("\nLe playbook Ansible a échoué.")
        sys.exit(1)

    print("\n" + "=" * 70)
    print("DEPLOIEMENT TERMINE")
    print("=" * 70)

    print(result)


if __name__ == "__main__":
    main()

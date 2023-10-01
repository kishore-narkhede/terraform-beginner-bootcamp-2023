# Terraform Beginner Bootcamp 2023

## Semantic versioning :mage:

This project is going to use semantic versioning for its tagging.
[semver.org](https://semver.org)

The general format
**MAJOR.MINOR.PATCH**, eg: `1.0.1`

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make backward compatible bug fixes

## Install the terraform CLI

### Considerations with the Terraform CLI changes

The Terraform CLI installation instructions have changed due to gpg keyring changes. Referred to the latest Terraform CLI installation documentation and changed the scripting for install.
[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Considerations for Linux Distributions

This project is built against Ubuntu.
Please consider checking your Linux Distribution and change accordingly to distribution needs.

[How to check OS version in Linux](

https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/

Example of checking OS version:

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
)
```

### Refactoring into bash scripts

While fixing the Terraform CLI gpg depreciation issues, we noticed that bash scripts were a considerable amount of more code. So decided to cretae a bash script to install Terraofmr CLI.

This bash script is located here : [./bin/install_terraform_cli.sh](./bin/install_terraform_cli.sh)

- This will keep the Gitpod Task File ([.gitpod.yml](.gitpod.yml))tidy.
- This allows us to easier to debug and execute manually Terraform CLI install.
- This will allow better portability for other projects that need to install Terraform CLI.

#### Shebang considerations

A Shebang (pronounced as Sha-Bang) tells the bash script what program will interpret the script. eg. `#!/bin/bash`
ChatGPT recommended to use this format for bash `#!/bin/bash/env bash`

- for portability for different OS distributions
- will search the user's PATH for the bash executable

https://en.wikipedia.org/wiki/Shebang_(Unix)

#### Execution Considerations

When executing the bash script, we can use `./` shorthand notation to execute bash script.
eg: `./bin/install_terraform_cli.sh`

If we are using a script in .gotpod.yml, we need to point the script to a program to interprete it.
eg: `source ./bin/install_terraform_cli.sh`

#### Linux Permissions Considerations

In order to make our bash scripts executable, we need to change the linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli.sh
```

alternatively :

```sh
chmod 744 ./bin/install_terraform_cli.sh
```

### Github lifecycle (before, init, command)

We need to be careful when using init() as it will not re-run if we restart an existing workspace.

https://www.warp.dev/terminus/chmod-x

https://www.gitpod.io/docs/configure/workspaces/tasks

### Working with environment variables

#### env command

We can list out all environment variables using the `env` command.

We can filter specific env vars using grep eg: `env | grep AWS_`

#### Setting and unsetting env vars

In the terminal, we can set using `export HELLO=world`

In the terminal, we can unset using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' ./bin/print_message
```

Within a bash script, we can set env without writing export eg

```sh
HELLO='world'
echo $HELLO
```

#### Printing env vars

We can print an env var using echo eg `echo $HELLO`

#### Scoping of env vars

When you open up new bash terminal in VSCode, it will not be aware of env vars that you have set in another window.
If you want env vars to persist across all future bash terminals that are open you need to set env vars in your bash profile. eg `.bash_profile`

#### Persisting env vars in Gitpod

We can persist env vars into Gitpod by storing them in Gitpod Secret Storage

```
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces.

You can also set up env vars in `gitpod.yml`, but this can only contain non-sensitive env vars.

### AWS CLI installation

AWS CLI is installed for the project via the bash script [`./bin/install_aws_cli`](./bin/install_aws_cli)

[Getting Started Install (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS CLI Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

We can check if our AWS credentials are configured correctly by running the following AWS CLI command:

```sh
aws sts get-caller-identity
```

If it is successful, you should see a json payload return that looks like this:

```json
{
  "UserId": "AIDAU5CDERK2J5GRFFKDW",
  "Account": "123456789012",
  "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We will need to generate AWS CLI credits from IAM user in order to use AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io)

-- **Provides** is an interface to APIS that will allow to create resources in terraform.
-- **Modules** are a way to make large amount of terraform code modular, portable and sharable.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`

#### Terraform init

At the start of a new Terraform project we will run `terraform init` to download the binaries for the terraform providers that we'll use in this project.

#### Terraform Plan

This will generate out a changeset, about the state of infrastructure and what will be changed.
We can output the changeset ir plan to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`
This will run a plan and pass the changeset to be executed by terraform. Apply should prompt yes or no.

This can be auto approved by providing the auto approve flag eg `terraform applu --auto-approve`

While creating S3 bucket, needed to change the bucket name to be lowercase. Updated resource for the bucket name.

#### Terraform Destroy

`terraform destroy`
This will destroy resources.

A flag to auto approve can also be used to skip approve prompt. (similar to terraform apply)

#### Terraform Lock Files

`.terraform.lock.hcl` contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File **should be commited** to your version control system (VSC).

`.terraform.tfstate` contain information about the current state of your infrastructure.
This file **should not be commited** to your version control system (VSC).

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

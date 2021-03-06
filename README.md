## Directory Layout

The directory layout is pretty straight forward. It contains a directory for all the project variables and Terraform
files as well as a Makefile for automation. The file tree of the directory looks like this:

    .
    ├── projects
    │   ├── globals
    │   │   └── inputs.tfvars
    │   └── template
    │       └── inputs.tfvars
    ├── Makefile 
    ├── backend.tf
    ├── provider.tf
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── statefile.tf 
    ├── README.md
    └── LICENSE

## Projects

The projects directory stores the .tfvars file for each project. The skeleton repo contains two directories. The globals
directory is run each time Terraform is run. It contains variables that are constant across deployments. The template
directory is an example of an individual project file. When you use Makefile or Jenkinsfile to run the Terraform
command, it will run with the global variables as well as the variables of the defined project. I think of a project as
an individual instantiation of the Terraform state. It could be an environment (development/staging/production),
accounts (aws1, aws2, etc), or even regions (us-west-1, eu-east-1, etc).

### Makefile

I do not remember where I came across the idea to use a Makefile for running my Terraform commands, but it has been
extremely useful. It allows me to run multiple commands at once without typing long command lines. Prior to running the
make file, you need to set two environmental variables. The BUCKET variable is used in the terraform init command to set
the S3 bucket used to store state. The PROJECT variable is the project that you want to run the terraform for. This
variable is used in the name of the Terraform state file as well as to choose which project variables to run.

### Terraform Files

Rather than cramming everything into a single file, I tend to use more files rather than less for readability. To that
end I generally have 5 .tf files that I use when working with Terraform.

#### backend.tf

The backend.tf file contains information about which backend to use (S3 in my case).

#### provider.tf

The provider.tf file contains which provider to use. My directory defaults to the AWS provider, but I have used Azure
and GCP as well.

#### main.tf

This is where I define which modules I want to use. Now that Terraform has a module registry, I try to use that as much
as possible, but occasionally I will write my own.

#### variables.tf

The variables.tf file is used to initialize all the variables that I want to pass in via my projects file.

#### outputs.tf

The outputs.tf file is for storing any outputs that you may want to make available to other Terraform projects at a
later time.

#### statefile.tf

The statefile.tf file is for creating the resources needed to create the S3 bucket and DynamoDB used for the statefile.

### Errata

The README.md and LICENSE file are self explanitory.
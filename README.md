# Automating AWS Infrastructure using Terraform

Automated AWS EC2 provisioning with Terraform, including VPC, subnet, and Internet Gateway setup. Developed reusable infrastructure modules, implemented security groups, and scripted Docker and Nginx installation.


## A) EC2 Provisioning Automation Steps

### Step 1: Virtual Private Cloud (VPC) & Subnet Creation
Begin by setting up a VPC to provide a virtual network tailored to your security and operational needs. Within this VPC, create a subnet that dictates the IP range and networking environment for the instances.

### Step 2: Internet Gateway & Route Table Configuration
Establish an Internet Gateway to enable communication between your VPC and the internet. Connect this gateway to a route table associated with your VPC to direct outbound traffic.

### Step 3: Subnet Association & Route Table Adjustment
Ensure the subnet is associated with the correct route table that includes a route to the Internet Gateway. This step is crucial for enabling internet access for the subnet.

### Step 4: Security Group & Firewall Rules
Create a security group that acts as a virtual firewall, controlling the traffic allowed to and from the EC2 instances. Define rules that specify allowed protocols, ports, and source IP ranges.

### Step 5: EC2 Instance Creation
Launch an EC2 instance within your VPC, selecting the appropriate instance type and configuring settings according to your requirements.

### Step 6: Server Scripting & Service Deployment
Develop a script to automate the server setup, including the installation of Docker and Nginx. Ensure the script validates that the services are running and accessible via a web browser.

## B) Terraform Modules Management

### Step 1: Module Folder Structure
Create a hierarchical folder structure to organize your Terraform modules. This structure should reflect the logical separation of resources.

### Step 2: Resource Grouping
Organize resources into modules based on their logical relationship, such as networking components within a 'subnet' module.

### Step 3: Variable Utilization
Define variables to pass inputs into your modules. This approach allows for flexibility and reusability of the modules across different environments.

### Step 4: Output Values
Configure outputs to retrieve important information from the modules, such as IDs and endpoints, which can be used by other modules or for verification purposes.

### Step 5: Terraform Workflow Execution
Execute `terraform init` to initialize the working directory, followed by `terraform plan` to review any changes before applying them. Finally, run `terraform apply` to create the resources.

### Step 6: Module Expansion
Repeat the aforementioned steps to create additional modules, such as a 'webserver' module, to further modularize and manage your infrastructure.


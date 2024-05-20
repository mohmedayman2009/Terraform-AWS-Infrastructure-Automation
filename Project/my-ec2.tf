/*EC2 SECTION*/


data "aws_ami" "latest-amazon-linux-image" {
    most_recent = true
    owners      = ["amazon"]
    filter{ #filtered by name
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"] #-*-, will ignore expressions between pre and sufix
    }
    filter{ #filtered by virtualization type
        name   = "virtualization-type"
        values = ["hvm"] 
    }
    filter {
        name   = "description"
        values = ["Amazon Linux 2 *"]
    }
}

output "AWS_AMI_ID"{
    /*To get whole object.. just remove .id*/
    value = data.aws_ami.latest-amazon-linux-image.id
}


/*
on ~/.ssh/ we have id_rsa and id_rsa.pub.. 
*/
resource "aws_key_pair" "ssh-key" {
    key_name   = "server-key"
    public_key = file(var.public_key_location)
}

/*EC2 have to be setted on our subnet, and SG, if it not be specifiec, ec2 will be launched on default VPC*/
resource "aws_instance" "myapp-server" {
 
    #AMI ID that we got from data query
    ami           = data.aws_ami.latest-amazon-linux-image.id 
    instance_type = var.instance_type

    subnet_id               = aws_subnet.myapp-subnet-1.id
    vpc_security_group_ids = [aws_security_group.myapp-sg.id]
    availability_zone       = var.avail_zone

    associate_public_ip_address = true
    key_name  = aws_key_pair.ssh-key.key_name
    

    tags = {
        Name = "${var.env_prefix}-server"
    }

    /*Script executed when the server is created*/
    # user_data = <<EOF
    #                 #!/bin/bash
    #                 sudo yum update -y && sudo yum install docker -y
    #                 sudo systemctl start docker
    #                 sudo usermod -aG docker ec2-user
    #                 docker run -p 8080:80 nginx
    #             EOF

    ## but we will use  entry-script.sh
    user_data = file("entry-script.sh")

   #connection have atributes to connect
    connection {
        type        = "ssh"
        host        = self.public_ip
        user        = "ec2-user"
        private_key = file(var.private_key_location)
    }
    #we can execute script, but scripts have to be within server.. so:
    # provisioner"file" {
    #     source      = "entry-script.sh"
    #     destination = "/home/ec2-user/entry-script"
    # }

    # provisioner "remote-exec" {
    #     script = file("entry-script.sh")
    # }

    #to execute some commands, we can use "inline"
    # provisioner "remote-exec" {
    #     inline = [
    #         "export ENV=dev",
    #         "mkdir newdirectory",
    #         "sudo yum update -y",
    #     ]
    # }
    ##

    ## execute commands localmachine:
    provisioner "local-exec" {
        command = "echo ${self.public_ip} > output.txt"
    }
}


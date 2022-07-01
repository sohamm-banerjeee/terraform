data "http" "mypubip" {
         url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "mysg" {
        name = "mysg"
        description = "mysg"
        ingress {
                from_port         = 22
                to_port           = 22
                protocol          = "tcp"
                cidr_blocks       = ["${chomp(data.http.mypubip.body)}/32"]
         }
}

resource "aws_instance" "myinstance" {
        instance_type   = var.instance_type
        ami             = var.ami
        security_groups = ["mysg"]
        tags            = {
                    Name = "mytag"
        }
}

output "mydynamicip" {
         value = data.http.mypubip.body
}
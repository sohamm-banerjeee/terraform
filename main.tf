module "us" {
        source = "./modules/ec2-instance"
        providers = {
                aws = aws.us
        }
        ami = "ami-06640050dc3f556bb"
}

module "eu" {
        source = "./modules/ec2-instance"
        providers = {
                aws = aws.eu
        }
        ami = "ami-0f0f1c02e5e4d9d9f"
}

module "sa" {
        source = "./modules/ec2-instance"
        providers = {
                aws = aws.sa
        }
        ami = "ami-0c1b8b886626f940c"
}
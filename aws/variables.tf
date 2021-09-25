//variables de region

variable "aws_region"{
    description = "region AWS"
    default = "us-east-1"
}


variable "aws_ami"{
    description = "centos aws"
    default = {
        us-east-1 = "ami-087c17d1fe0178315" // Virginia ami
        us-west-2 = "ami-0c2d06d50ce30b442" // Oregon ami
    }
}
variable "key_name"{
    description = "nombre de par ssh"
    default ={
        us-east-1 = "TPO-ARQ" // Virginia KEY
        us-west-2 = "TPO-ARQ-oregon" //Oregon KEY
    }
}

//variables intancia 


variable "intance_type"{
    default = "t2.micro"
    description = "tipo de instancia AWS - default t2.micro"
}

//ASG - Auto Scaling Group

variable "asg_min"{
    default = "1"
    description = " Numero Minino de ASG"
}
variable "asg_max"{
    default = "4"
    description = " Numero Maximo de ASG"
}
variable "asg_desired"{
    default = "2"
    description = " Numero Deseado de ASG"
}

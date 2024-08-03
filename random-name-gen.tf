#random name generator this generates a random name for the ec2 instance
resource "random_pet" "petname"{
    length = 1
}
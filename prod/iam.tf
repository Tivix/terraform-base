# # create policy allows to manage volumes
# resource "aws_iam_policy" "volumes" {
#   name        = "PolicyVolumesManagement"
#   path        = "/"
#   description = "Policy allows to manage volumes"
#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "ec2:CreateTags",
#         "ec2:AttachVolume",
#         "ec2:DetachVolume",
#         "ec2:CreateVolume",
#         "ec2:DeleteVolume",
#         "ec2:DescribeVolumes",
#         "ec2:DescribeVolumeStatus",
#         "ec2:CreateSnapshot",
#         "ec2:DeleteSnapshot",
#         "ec2:DescribeSnapshots"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }
# # create role for EC2
# resource "aws_iam_role" "role" {
#   name = "RoleVolumesManagement"
#   assume_role_policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": "sts:AssumeRole",
#       "Principal": {
#       "Service": "ec2.amazonaws.com"
#       },
#       "Effect": "Allow",
#       "Sid": ""
#     }
#   ]
# }
# EOF
# }
# # assign policy to role
# resource "aws_iam_role_policy_attachment" "roles" {
#   role       = "${aws_iam_role.role.name}"
#   policy_arn = "${aws_iam_policy.volumes.arn}"
# }
# # create instance profile which will be attached to ec2
# resource "aws_iam_instance_profile" "volumes_profile" {
#   name  = "ProfileVolumesManagement"
#   roles = ["${aws_iam_role.role.name}"]
# }


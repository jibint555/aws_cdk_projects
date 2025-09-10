{
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"cloudformation:*",
				"s3:*",
				"ec2:DescribeAvailabilityZones",
				"sts:GetCallerIdentity",
				"iam:GetRole",
				"iam:CreateRole",
				"iam:DeleteRole",
				"iam:AttachRolePolicy",
				"iam:DetachRolePolicy",
				"iam:PassRole",
				"iam:PutRolePolicy",
				"iam:DeleteRolePolicy",
				"iam:GetRolePolicy",
				"iam:ListRolePolicies",
				"iam:TagRole",
				"iam:UntagRole",
				"iam:TagPolicy",
				"iam:UntagPolicy",
				"ecr:*",
				"ssm:*"
			],
			"Resource": "*"
		}
	]
}

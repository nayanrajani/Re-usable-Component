
data "aws_iam_policy" "AdminAccess" {
  name = "AdministratorAccess"
}

data "aws_iam_policy_document" "assume_role_document" {
  statement {
    actions = [
      "sts:AssumeRole",
      "sts:TagSession",
      "sts:SetSourceIdentity"
    ]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::<account-id>:user/<iamusername>"]
    }
  }
}

resource "aws_iam_role" "admin_assume_role" {
  name                = "super-admin-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_document.json
  managed_policy_arns = [data.aws_iam_policy.AdminAccess.arn]
  tags = {
    created-by    = "Nayan-Rajani"
    creation-date = "23/12/22"
  }
}
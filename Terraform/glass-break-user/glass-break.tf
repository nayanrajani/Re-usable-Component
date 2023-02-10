
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
      identifiers = ["arn:aws:iam::292929786526:user/mlzuser"]
    }
  }
}

#arn:aws:iam::${data.aws_caller_identity.source.account_id}:root
#arn:aws:iam::292929786526:user/mlzuser

resource "aws_iam_role" "admin_assume_role" {
  name                = "super-admin-role"
  assume_role_policy  = data.aws_iam_policy_document.assume_role_document.json
  managed_policy_arns = [data.aws_iam_policy.AdminAccess.arn]
  tags = {
    created-by    = "Nayan-Rajani"
    creation-date = "23/12/22"
  }
}
alias TeleCarex.Repo
alias TeleCarex.Accounts.User

users = [
  %{
    username: "dr_smith",
    email: "dr.smith@example.com",
    role: :internal,
    available?: true
  },
  %{
    username: "nurse_jane",
    email: "jane.nurse@example.com",
    role: :internal,
    available?: false
  },
  %{
    username: "therapist_mike",
    email: "mike.therapy@example.com",
    role: :internal,
    available?: true
  },
  %{
    username: "doc_clark",
    email: "clark.doc@example.com",
    role: :internal,
    available?: true
  }
]

Enum.each(users, fn attrs ->
  %User{}
  |> User.changeset(attrs)
  |> Repo.insert!()
end)

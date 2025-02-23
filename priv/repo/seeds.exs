# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Trento.Repo.insert!(%Trento.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

%Trento.Users.User{}
|> Trento.Users.User.changeset(%{
  username: "admin",
  password: "adminpassword",
  confirm_password: "adminpassword"
})
|> Trento.Repo.insert!(on_conflict: :nothing)
